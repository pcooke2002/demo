#!/bin/bash
cd /tmp
target_dir =

# Create a directory for the layer
mkdir -p lambda_layer/python


# Create a virtual environment
python3.12 -m venv venv

# Activate the virtual environment
source venv/bin/activate

# Install the required packages

pip install aws-xray-sdk aws-embedded-metrics -t lambda_layer/python --python-version 3.12
cd lambda_layer


pip install aws-xray-sdk aws-embedded-metrics -t lambda_layer/python

# Deactivate the virtual environment
deactivate

# Zip the content

zip -r9 ~/Documents/Workspace/learn-terraform/experiment3/xray-sdk.zip ./

# Navigate back to the original directory
cd ..

# Clean up
rm -rf my-layer

