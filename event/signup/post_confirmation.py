import boto3

dynamodb = boto3.resource('dynamodb')

def post_confirmation_handler(event, context):
    """ post confirmation handler
    the handler that invokes when a successful verification of a
    new user account has completed and this populates the db
    with the new user's basic character stats """

    # select the appropriate table
    character_table = dynamodb.Table('character')

    # populate item based on the user
    character_table.put_item(
       Item={
            'user': event['userName'],
            'str': '10',
            'dex': '10',
            'int': '10',
            'level': '1',
            'exp': '0'
        }
    )

    return event