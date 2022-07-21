import json
import os
import boto3

def lambda_handler(event, context):
    inputFilename = os.environ["inputFileName"]
    bucketName = os.environ["bucketname"]
    response = {
        'statuscode' : 200 ,
        'body' : json.dumps ('Input Received - ' + json.dumps(event))
    }
    client = boto3.client('batch')
    response = client.submit_job(
    jobDefinition='dynamodb_import_job_definition',
    jobName='dynamodb_import_job1',
    jobQueue='dynamodb_import_queue',
    containerOverrides={
        'environment': [
            {
                'name': 'table_name',
                'value': 'batch-test-table',
            },
            {
                'name': 'bucket_name',
                'value': 'batch-test-bucket-ap-1',
            },
            {
                'name': 'key',
                'value': 'sample-zip.csv',
            }
        ]
    },
    )
    print(response)
    print("Job ID is {}.".format(response['jobId']))
    return response