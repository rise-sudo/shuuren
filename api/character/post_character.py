# import libraries
import json

def post_character(query_params, dynamodb):
    """ post character
    the http function that invokes when the basic character 
    stats are requested to be replaced entirely by the user
    in other words this resets the user stats as well as removes any custom stats """

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

    # if the character info is available
    if character_info.get('Item'):
        # reset the values entirely with defaults
        character_table.put_item(
           Item={
                'user': query_params['user'],
                'str': '10',
                'dex': '10',
                'int': '10',
                'level': '1',
                'exp': '0'
            }
        )

        # set the response
        response['statusCode'] = 200
        response['body'] = json.dumps({'message': f"User {query_params['user']} stats have been reset successfully"})

    # otherwise assume no such user exists
    else:
        # set the response
        response['statusCode'] = 400
        response['body'] = json.dumps({'message': 'User does not exist'})

    return response