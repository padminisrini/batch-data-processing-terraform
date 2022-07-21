import json
import os
import boto3

def lambda_handler(event, context):
    inputFilename = os.environ["inputFileName"]
    bucketName = os.environ["bucketName"]
    response = {
        'statuscode' : 200 ,
        'body' : json.dumps ('Input Received - ' + json.dumps(event))
    }
    client = boto3.client('batch')
    response = client.submit_job(
    jobDefinition= os.environ["batch_job_definition_name"],
    jobName= 'dynamodb_import_job1',
    jobQueue= os.environ["batch_queue_name"],
    containerOverrides={
        'environment': [
            {
                'name': 'table',
                'value': os.environ["dynamodb_table_name"],
            },
            {
                'name': 'bucket',
                'value': bucketName,
            },
            {
                'name': 'key',
                'value': "csv/" + inputFilename,
            }
        ]
    },
    )
    print(response)
    print("Job ID is {}.".format(response['jobId']))
    return response