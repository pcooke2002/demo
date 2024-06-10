# Purpose
In the AWS developer associate exam.  60% of the questions involved Serverless (lambda, and step functions), api gatway, api gatway logging, api gatway throtteling, xray.  This project was written to better understand what that involed and how to configure it in terraform
 

# Requirements

tree
.<br>

├── README.md<br>
├── lambda_layer<br>
│   └── xray-sdk.zip<br>
├── make-layer-zip.sh<br>
├── mk_structure.sh<br>
├── test.sh<br>
└── terraform_project<br>
    ├── main.tf<br>
    ├── modules<br>
    │   ├── apigateway<br>
    │   │   ├── apigateway.tf<br>
    │   │   ├── outputs.tf<br>
    │   │   └── variables.tf<br>
    │   ├── cloudwatch<br>
    │   │   ├── log_group.tf<br>
    │   │   ├── metric_alarm.tf<br>
    │   │   ├── outputs.tf<br>
    │   │   └── variables.tf<br>
    │   ├── dynamodb<br>
    │   │   ├── dynamodb.tf<br>
    │   │   ├── outputs.tf<br>
    │   │   └── variables.tf<br>
    │   ├── lambda<br>
    │   │   ├── function.tf<br>
    │   │   ├── lambda_function<br>
    │   │   │   └── lambda_function.py<br>
    │   │   ├── outputs.tf<br>
    │   │   └── variables.tf<br>
    │   ├── lambda_iam<br>
    │   │   ├── iam.tf<br>
    │   │   ├── outputs.tf<br>
    │   │   └── variables.tf<br>
    │   ├── lambda_layer<br>
    │   │   ├── layer.tf<br>
    │   │   ├── outputs.tf<br>
    │   │   ├── variables.tf<br>
    │   │   └── xray-sdk.zip<br>
    │   └── sns<br>
    │       ├── outputs.tf<br>
    │       ├── sns.tf<br>
    │       └── variables<br>
    ├── outputs.tf<br>
    └── variables.tf<br>


This is to make a terraform  example REST based aws api gateway to lambda to dynamodb system.

In the current directory is a directory "terraform_project"   it will host all of the Infrastructure as code files.  
all output blocks needs to be in outputs.tf.  
all variable blocks needs to be in variables.tf

there is a script "mk_structure.sh"  will be used to make the structure of the terraform_project directory.  the terraform needs to broken up by aws service.   

i need full restful crud operations
   create
   update
   get as in get all values and get specific id
   delete
   info or options

   the all services should enable all enhanced logging

## dynamo db table
1) name is called "my_items". 
2) the items will be in the format of { "id": "1", "key1": "value1", "key2": "value2",...} .   
3) once again dynamodb needs to have full monitoring, and xray tracing turned on.   
4) it does not need dynamo streams or point in time recovery.    
5) the hash key is "id"


## lambda layer 
1) directory has   xray-sdk.zip in the directory that contains all lambda layer requirements. 
2) the layer resource should reference the zip file directly it should not make a s3 bucket and put the zip there 

## SNS:
1) there needs to a sns topic "my-topic" that can send emails
2) there needs to be a dop level variable for "subscription email"  with a default value of ""


## lambda name requirements   python 3.12 runtime
1) name should be "my_api_gw_function" and will receive request from API gateway to perform REST activity on the "my_items" table
2) there should be an terraform archive that creates a zip in the lambda directory every time terraform apply runs
3) the lambda should not create s3 buckets it should just specify the zip
4) the lambda needs to define functions that support all REST workflows.  create, update, retreive or get, and delete.
4) The handler should start and stop xray tracing at the benginning and end of the handler 
5) every handler method/function should start/stop a new xray sub-segment
6) the all functions needs to  print name and any arguments so that they appear in cloud watch logs.
7) before and after any database activity make an xray annotation that the request for DB activity has started or ended.
8) for creating or deleting records needs to have an emf metric that indicated that an item is created or destroyed.
7) the lambda needs to deal with the database returning a non-serializable number for its id
8) xray annotions where execeptions are caught or raised
9) the table name should be passed as an environmental variable to the lambda function.  
10) the lambda function needs appropriate permission to log and connect to create, get, update, delete dynamo dp records
11) the coded lambda python needs to be in terraform_project/modules/lambda/lambda_function/lambda_function.py
12) have any enhanced monitoring turned on 

## CloudWatch:
1) the alarms should send alerts to the "my-topic" sns topic
2) a topic subscriber should only be created if a top level variable  "emall_subscriber" is not  "" 
3) the log retention should ba a variable specifying the number of days.

## API Gateway 
1) the name of my api is "my_api"
2) api gatway stages.  "default" and "poc"  only 
3) needs to receive all http methods post, put, get ,delete, and options
4) should have IAM permissions to invoke lambda functions
5) create a deployment  and usage plan
6) make an api key of  "MBmlslh7mf6PIojvCjyRo1Sznd6ZXOZI9Lw4RyT7"
7) all calls to the api should only require authorization they should only need the api key
8) on every request header, body, and request parameters should be validated
9) all api gateway logs should be recorded in the "MyApiGateWayLogs"
10) API Gateway should throttle request to 3 per second with a burst of 6
11) api gateway should set a quota of 100 per day
12) API Gateway should define all http methods for the RESTFUL CRUD operations
13) API Gateway needs to have all relevant IAM permissions to log and invoke lambda functions
14) the URL for the POC and default stages needs to be output to the console
15) AWS API gateway profides documentation feature.   Generate any documentation for my api gateway stages and deployment
16) the apti gateway terraform should be similar to this and needs to incude the AWS api gatway documentation
17) needs to contain a deployment 
18) AWS API Gateway and Lambda have special integration with both X-ray and parameter mapping.  
    1) AWS API Gateway to other destination may need special mapping actions to and from.
    2) Investigate integration requests and responses when the request or response needs to be massaged into an acceptable format. 

## Generate a testing python program
1) prompts for the apt gateway url to test
2) it will use "MBmlslh7mf6PIojvCjyRo1Sznd6ZXOZI9Lw4RyT7" as the api key
3) it will exercise all all https methods
4) it create an initial record with an id=1 and have additional information
5) it will get all records in the 
6) it will get the record at id=1
7) it will update the record at id=1
8) then it will get all records and the record at id=1
9) make an options request


# Lesson leaned
## Terraform
1) breaking up complex into submodules can be useful for complex workflows.
2) Better understanding of how to pass variables and outputs between modules.

## Lambda
1) code guru does not support python 3.10+
2) EMF and alarms require diligence to ensure dimensions are synchronized.
3) xray annotations is useful.
   1) Tracking the execution path of your code: You can add annotations at the start and end of important operations or functions in your code. This can help you understand the flow of execution in your code.
   2) Adding metadata to traces: Annotations can be used to add additional metadata to your X-Ray traces. This can be useful for filtering and searching traces later.  
   3) Capturing the state of your application: If you want to capture the state of your application at a certain point in time, you can add an annotation with that information.  
   4) Error handling: You can add annotations in your error handling code to provide more context about the errors.

## API Gateway
1) api keys.
   1) have to have some form of authentication.
   2) either api key, cognito or certificate. 
   3) can use key with cognito or certificate.
2) Configuring API gateway to send logs to cloudwatch is not as straight forward as it seems.
3) Supports throttling bursts. 
   1) Throttling burst limit: The maximum number of requests that API Gateway allows to pass through in a burst. The burst limit is the number of requests that can be sent at once. If the burst limit is exceeded, API Gateway will return a 429 Too Many Requests response code.
   2) API Gateway has a lot of features that can be configured.  It is important to understand what is needed and what is not.
4) Stages, deployments are not optional.
5) need a usage plan if need throttling, quotas

## SNS
1) Don't create subscriptions in real code.
2) Use another pipeline to manage subscriptions.



