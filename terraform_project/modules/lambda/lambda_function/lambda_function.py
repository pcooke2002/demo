import json
import boto3
import os
import logging
from aws_xray_sdk.core import patch_all, xray_recorder
from decimal import Decimal

patch_all()

logger = logging.getLogger()
logger.setLevel(logging.INFO)
dynamodb = boto3.resource('dynamodb')
table_name = os.getenv('TABLE_NAME')
table = dynamodb.Table(table_name)

def response(status_code, body):
    return {
        'statusCode': status_code,
        'body': json.dumps(body)
    }

def lambda_handler(event, context):
    xray_recorder.begin_segment('LambdaHandler')
    logger.info(f"Received event: {json.dumps(event)}")

    http_method = event['httpMethod']
    resource = event['resource']

    try:
        if http_method == 'POST':
            return create_item(event)
        elif http_method == 'GET':
            return get_item(event)
        elif http_method == 'PUT':
            return update_item(event)
        elif http_method == 'DELETE':
            return delete_item(event)
        elif http_method == 'OPTIONS':
            return options()
        else:
            return response(405, f"Method {http_method} not allowed")
    except Exception as e:
        logger.error(f"Error processing request: {str(e)}")
        return response(500, f"Error processing request: {str(e)}")
    finally:
        xray_recorder.end_segment()

def create_item(event):
    xray_recorder.begin_subsegment('CreateItem')
    item = json.loads(event['body'])
    item['id'] = int(item['id'])
    table.put_item(Item=item)
    put_metric_data('my_api_gw_function', 'ItemCreated', 1)
    xray_recorder.end_subsegment()
    return response(200, {"message": "Item created", "item": item})

def get_item(event):
    xray_recorder.begin_subsegment('GetItem')
    params = event.get('queryStringParameters')
    if params and 'id' in params:
        item_id = int(params['id'])  # Convert id to decimal
        result = table.get_item(Key={'id': item_id})
        item = result.get('Item')

        if item:
            item['id'] = int(item['id'])

        xray_recorder.end_subsegment()
        if item:
            return response(200, item)
        else:
            return response(404, {"message": "Item not found"})
    else:
        scan = table.scan()
        items = scan.get('Items', [])
        for item in items:
            item['id'] = int(item['id'])  # Convert id to int for the response
        items = scan.get('Items', [])
        xray_recorder.end_subsegment()
        return response(200, items)

def update_item(event):
    xray_recorder.begin_subsegment('UpdateItem')
    item = json.loads(event['body'])
    item['id'] = int(item['id'])
    table.update_item(
        Key={'id': item['id']},
        UpdateExpression="SET key1 = :val1, key2 = :val2",
        ExpressionAttributeValues={
            ':val1': item['key1'],
            ':val2': item['key2']
        }
    )
    xray_recorder.end_subsegment()
    return response(200, {"message": "Item updated", "item": item})

def delete_item(event):
    xray_recorder.begin_subsegment('DeleteItem')
    params = event.get('queryStringParameters')
    if params and 'id' in params:
        item_id = int(params['id'])
        table.delete_item(Key={'id': int(item_id)})
        xray_recorder.end_subsegment()
        put_metric_data('my_api_gw_function', 'ItemDeleted', 1)
        return response(200, {"message": "Item deleted"})
    else:
        xray_recorder.end_subsegment()
        return response(400, {"message": "Item id not provided"})

def options():
    return response(200, {"message": "Options request successful"})


def put_metric_data(function_name, metric_name, metric_value):
    xray_recorder.begin_subsegment('put_metric_data')
    cloudwatch = boto3.client('cloudwatch')

    response = cloudwatch.put_metric_data(
        Namespace='AWS/Lambda',
        MetricData=[
            {
                'MetricName': metric_name,
                'Dimensions': [
                    {
                        'Name': 'FunctionName',
                        'Value': function_name
                    },
                ],
                'Value': metric_value,
                'Unit': 'Count'
            },
        ]
    )
    xray_recorder.end_subsegment()
    return response
