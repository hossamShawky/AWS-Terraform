import json
import boto3
from boto3.dynamodb.conditions import Key

dynamodb = boto3.resource('dynamodb')
table_name = 'apigateway-table'
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    http_method = event['httpMethod']
    path_parameters = event.get('pathParameters')
    body = event.get('body')

    if http_method == 'GET':
        if path_parameters:
            return get_item(path_parameters['id'])
        else:
            return get_all_items()
    elif http_method == 'POST':
        return create_item(json.loads(body))
    elif http_method == 'PUT':
        return update_item(path_parameters['id'], json.loads(body))
    elif http_method == 'DELETE':
        return delete_item(path_parameters['id'])
    else:
        return {
            'statusCode': 405,
            'body': json.dumps({'message': f'Unsupported method: {http_method}'})
        }

def get_item(item_id):
    try:
        response = table.get_item(Key={'id': item_id})
        if 'Item' not in response:
            return {'statusCode': 404, 'body': json.dumps({'message': 'Item not found'})}
        return {'statusCode': 200, 'body': json.dumps(response['Item'])}
    except Exception as e:
        return {'statusCode': 500, 'body': json.dumps({'message': str(e)})}

def get_all_items():
    try:
        response = table.scan()
        return {'statusCode': 200, 'body': json.dumps(response['Items'])}
    except Exception as e:
        return {'statusCode': 500, 'body': json.dumps({'message': str(e)})}

def create_item(item):
    try:
        table.put_item(Item=item)
        return {'statusCode': 201, 'body': json.dumps(item)}
    except Exception as e:
        return {'statusCode': 500, 'body': json.dumps({'message': str(e)})}

def update_item(item_id, item):
    try:
        response = table.update_item(
            Key={'id': item_id},
            UpdateExpression="set #name=:n, #value=:v",
            ExpressionAttributeNames={'#name': 'name', '#value': 'value'},
            ExpressionAttributeValues={':n': item['name'], ':v': item['value']},
            ReturnValues="ALL_NEW"
        )
        return {'statusCode': 200, 'body': json.dumps(response['Attributes'])}
    except Exception as e:
        return {'statusCode': 500, 'body': json.dumps({'message': str(e)})}

def delete_item(item_id):
    try:
        table.delete_item(Key={'id': item_id})
        return {'statusCode': 204, 'body': None}
    except Exception as e:
        return {'statusCode': 500, 'body': json.dumps({'message': str(e)})}
    

# import json

# def lambda_handler(event, context):
#     # TODO implement
#     return {
#         'statusCode': 200,
#         'body': json.dumps('Hello from Lambda!HOSSAM')
#     }
