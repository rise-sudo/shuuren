# import libraries
import boto3, json

# import specific http method functions
from get_character import get_character
from post_character import post_character
from put_character import put_character

# initialize connection to dynamodb
dynamodb = boto3.resource('dynamodb')

def set_character_http_mapping():
    """ set character http mapping
    maps the specific http method functions
    with the appropriate http method the user invoked"""

    # initialize character http mapping
    character_http_mapping = {
        'GET': get_character,
        'POST': post_character,
        'PUT': put_character,
    }

    return character_http_mapping

def character_handler(event, context):
    """ character handler
    the handler that invokes when the character stats
    need to be updated as per the api invocation parameters """

    # initialize response
    response = {'statusCode': '', 'body': ''}

    # initialize the http method
    http_method = event.get('httpMethod', '')

    # initialize query string parameters
    query_params = event.get('queryStringParameters', {})

    # initialize the character http mapping
    character_http_mapping = set_character_http_mapping()

    # check if valid http method
    if http_method in character_http_mapping:
        # invoke the http function accordingly
        response = character_http_mapping[http_method](query_params, dynamodb)
    else:
        # set the response
        response['statusCode'] = 400
        response['body'] = json.dumps({'message': 'Invalid API Call'})

    return response