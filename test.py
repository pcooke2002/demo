import requests
import boto3

api_key = "MBmlslh7mf6PIojvCjyRo1Sznd6ZXOZI9Lw4RyT7"
api_url = input("Enter the API Gateway URL: ")

headers = {
    'x-api-key': api_key,
    'Content-Type': 'application/json'
}


def create_item():
    global response
    # Create an item
    item1 = {
        "id": 1,
        "key1": "value1",
        "key2": "value2"
    }
    response = requests.post(f"{api_url}/items", json=item1, headers=headers)
    print("Create Item:", response.json())

def get_all_items():
    global response
    # Get all items
    response = requests.get(f"{api_url}/items", headers=headers)
    print("Get All Items:", response.json())


def get_item_by_id():
    global response
    # Get item by id
    response = requests.get(f"{api_url}/items?id=1", headers=headers)
    print("Get Item by ID:", response.json())




def update_item():
    global response
    # Update item
    item2 = {
        "id": 1,
        "key1": "new_value1",
        "key2": "new_value2"
    }
    response = requests.put(f"{api_url}/items", json=item2, headers=headers)
    print("Update Item:", response.json())

def options():
    global response
    # Make OPTIONS request
    response = requests.options(f"{api_url}/items", headers=headers)
    print("OPTIONS Request:", response.json())



def delete_item():
    global response
    # Delete item
    response = requests.delete(f"{api_url}/items?id=1", headers=headers)
    print("Delete Item:", response.json())


for count in range(1, 5):
    create_item()
    get_all_items()
    get_item_by_id()
    update_item()
    get_all_items()
    get_item_by_id()
    delete_item()
    get_all_items()



options()

