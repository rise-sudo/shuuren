# import standard libraries
import json

def put_character(dynamodb):
    """ put character
    the http function that invokes when the basic character 
    stats are requested to be updated by the user """

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

    # if the character info is available
    if character_info.get('Item'):
        # initialize character info
        character_info = character_info['Item']

        # initialize the stats
        str_stat = body.get('str', '0')
        int_stat = body.get('int', '0')
        dex_stat = body.get('dex', '0')

        # initialize the level
        level = body.get('level', '0')

        # initialize the experience
        exp = body.get('exp', '0')

        # update the stats
        try:
            character_info['str'] = str(int(character_info['str']) + int(str_stat))
            character_info['int'] = str(int(character_info['int']) + int(int_stat))
            character_info['dex'] = str(int(character_info['dex']) + int(dex_stat))

            # update the level
            character_info['level'] = str(int(character_info['level']) + int(level))

            # update the experience
            character_info['exp'] = str(int(character_info['exp']) + int(exp))

            # update the db entry
            character_table.put_item(
               Item=character_info
            )

            # set the response
            response['statusCode'] = 200
            response['body'] = json.dumps({'message': 'Updated Successfully'})

        # return error if the parameter was not integers
        except ValueError:
            # set the response
            response['statusCode'] = 400
            response['body'] = json.dumps({'message': 'Parameters provided must be integers'})

    # otherwise assume no such user exists
    else:
        # set the response
        response['statusCode'] = 400
        response['body'] = json.dumps({'message': 'User does not exist'})

    return response
