# Purpose
In the AWS developer associate exam.  60% of the questions involved Serverless (lambda, and step functions), api gatway, api gatway logging, api gatway throtteling, xray.  This project was written to better understand what that involed and how to configure it in terraform



COMMENT TO SEE IF CREDEINTIALS ARE WORKING



here is my project directory project structure

tree
.
├── README.md
├── lambda_layer
│   └── xray-sdk.zip
├── make-layer-zip.sh
├── mk_structure.sh
├── test.sh
└── terraform_project
    ├── main.tf
    ├── modules
    │   ├── apigateway
    │   │   ├── apigateway.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   ├── cloudwatch
    │   │   ├── log_group.tf
    │   │   ├── metric_alarm.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   ├── dynamodb
    │   │   ├── dynamodb.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   ├── lambda
    │   │   ├── function.tf
    │   │   ├── lambda_function
    │   │   │   └── lambda_function.py
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   ├── lambda_iam
    │   │   ├── iam.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   ├── lambda_layer
    │   │   ├── layer.tf
    │   │   ├── outputs.tf
    │   │   ├── variables.tf
    │   │   └── xray-sdk.zip
    │   └── sns
    │       ├── outputs.tf
    │       ├── sns.tf
    │       └── variables
    ├── outputs.tf
    └── variables.tf
   





# requiements.  "CRUD = create, report (meaning get), update, and delete"
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

the dynamo db table
1) name is called "my_items". 
2) the items will be in the format of { "id": "1", "key1": "value1", "key2": "value2",...} .   
3) once again dynamodb needs to have full monitoring, and xray tracing turned on.   
4) it does not need dynamo streams or point in time recovery.    
5) the hash key is "id"


lambda layer 
1) directory has   xray-sdk.zip in the directory that contains all lambda layer requirements. 
2) the layer resource should reference the zip file directly it should not make a s3 bucket and put the zip there 

SNS:
1) there needs to a sns topic "my-topic" that can send emails
2) there needs to be a dop level variable for "subscription email"  with a default value of ""
3) if 


lambda name requirements   python 3.12 runtime
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

CloudWatch:
1) the alarms should send alerts to the "my-topic" sns topic
2) a topic subscriber should only be created if a top level variable  "emall_subscriber" is not  "" 
3) the log retention should ba a variable specifying the number of days.

API Gateway the name of my api is "my_api"
1) api gatway stages.  "default" and "poc"  only 
2) needs to receive all http methods post, put, get ,delete, and options
3) should have IAM permissions to invoke lambda functions
4) create a deployment  and usage plan
5) make an api key of  "MBmlslh7mf6PIojvCjyRo1Sznd6ZXOZI9Lw4RyT7"
6) all calls to the api should only require authorization they should only need the api key
7) on every request header, body, and request parameters should be validated
8) all api gateway logs should be recorded in the "MyApiGateWayLogs"
9) API Gateway should throttle request to 3 per second with a burst of 6
10) api gateway should set a quota of 100 per day
11) API Gateway should define all http methods for the RESTFUL CRUD operations
12) API Gateway needs to have all relevant IAM permissions to log and invoke lambda functions
13) the URL for the POC and default stages needs to be output to the console
14) AWS API gateway profides documentation feature.   Generate any documentation for my api gateway stages and deployment
15) the apti gateway terraform should be similar to this and needs to incude the AWS api gatway documentation
16) needs to contain a deployment 

generate a testing pythong progroam "test-agigw.py"
1) prompts for the apt gateway url to test
2) it will use "MBmlslh7mf6PIojvCjyRo1Sznd6ZXOZI9Lw4RyT7" as the api key
3) it will exercise all all https methods
4) it create an initial record with an id=1 and have additional information
5) it will get all records in the 
6) it will get the record at id=1
7) it will update the record at id=1
8) then it will get all records and the record at id=1
9) make an options request
