import boto3
import json

dynamodb = boto3.resource('dynamodb')

def get_character_handler(event, context)
    """ get character handler
    the handler that invokes when the basic character stats
    need to be retrieved as per the api invocation parameters """
    
    # initialize response
    response = {'statusCode': '', 'body': ''}
    
    # select the appropriate table
    character_table = dynamodb.Table('character')
    
    # read the body
    body = json.loads(event.get('body'))
    
    # attempt to get the character data
    character_info = character_table.get_item(
        Key={
            'user': body['user']
        }
    )
    
    if character_info.get('Item'):
        # initialize character info
        character_info = character_info['Item']
    
    # otherwise assume no such user exists
    else:
        # set the response
        response['statusCode'] = 400
        response['body'] = json.dumps({'message': 'User does not exist'})
    
    return response