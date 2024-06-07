import requests
import boto3

api_key = "MBmlslh7mf6PIojvCjyRo1Sznd6ZXOZI9Lw4RyT7"
api_url = input("Enter the API Gateway URL: ")

headers = {
    'x-api-key': api_key,
    'Content-Type': 'application/json'
}

# Create an item
item1 = {
    "id": 1,
    "key1": "value1",
    "key2": "value2"
}
response = requests.post(f"{api_url}/items", json=item1, headers=headers)
print("Create Item:", response.json())

# Get all items
response = requests.get(f"{api_url}/items", headers=headers)
print("Get All Items:", response.json())

# Get item by id
response = requests.get(f"{api_url}/items?id=1", headers=headers)
print("Get Item by ID:", response.json())

# Update item
item2 = {
    "id": 1,
    "key1": "new_value1",
    "key2": "new_value2"
}
response = requests.put(f"{api_url}/items", json=item2, headers=headers)
print("Update Item:", response.json())

# Get all items after update
response = requests.get(f"{api_url}/items", headers=headers)
print("Get All Items after update:", response.json())

# Get item by id after update
response = requests.get(f"{api_url}/items?id=1", headers=headers)
print("Get Item by ID after update:", response.json())

# Delete item
response = requests.delete(f"{api_url}/items?id=1", headers=headers)
print("Delete Item:", response.json())

# Get all items
response = requests.get(f"{api_url}/items", headers=headers)
print("Get All Items:", response.json())

# Make OPTIONS request
response = requests.options(f"{api_url}/items", headers=headers)
print("OPTIONS Request:", response.json())

