#!/usr/bin/env python3

import boto3
import os
import sys

ssm = boto3.client('ssm')

def publish_ssm(message, parameter):
    ssm.put_parameter(
        Name=parameter,
        Type='String',
        Value=message,
        Overwrite=True,
    )

def lambda_handler(event, context):
    parameter = os.getenv('SSM_PARAMETER')
    if parameter is None:
        print("ERROR: No SSM parameter defined")
        sys.exit(1)

    for record in event['Records']:
        message = record['Sns']['Message']

        publish_ssm(message, parameter)
