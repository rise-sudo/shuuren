# import standard libraries
import json

def get_character(dynamodb)
    """ get character
    the http function that invokes when the basic character
    stats are requested to be retrieved by the user """
    
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
        
        # set the response
        response['body'] = {'str': character_info['str'],
                            'dex': character_info['dex'],
                            'exp': character_info['exp'],
                            'int': character_info['int'],
                            'level': character_info['level']
                           }                 
        response['statusCode'] = 200
        
    # otherwise assume no such user exists
    else:
        # set the response
        response['statusCode'] = 400
        response['body'] = json.dumps({'message': 'User does not exist'})
        
    return response