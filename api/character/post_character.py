# import libraries
import json

def post_character(query_params, dynamodb):
    """ post character
    the http function that invokes when the basic character 
    stats are requested to be replaced entirely by the user """

    # initialize response
    response = {'statusCode': '', 'body': ''}

    # WIP - future feat
    response['statusCode'] = 400
    response['body'] = json.dumps({'message': 'HTTP Method not available yet'})

    return response