# import libraries
import json

def get_character(query_params, dynamodb):
    """ get character
    the http function that invokes when the basic character
    stats are requested to be retrieved by the user """
    
    # initialize response
    response = {'statusCode': '', 'body': ''}
    
    # select the appropriate table
    character_table = dynamodb.Table('character')
        
    # attempt to get the character data
    character_info = character_table.get_item(
        Key={
            'user': query_params['user']
        }
    )

    if character_info.get('Item'):
        # initialize character info
        character_info = character_info['Item']
        
        # set the response
        response['body'] = character_info
        response['statusCode'] = 200
        
    # otherwise assume no such user exists
    else:
        # set the response
        response['statusCode'] = 400
        response['body'] = json.dumps({'message': 'User does not exist'})
        
    return response