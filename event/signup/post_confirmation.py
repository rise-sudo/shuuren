import boto3

dynamodb = boto3.resource('dynamodb')

def post_confirmation_handler(event, context):
    """ post confirmation handler
    the handler that invokes when a successful verification of a
    new user account has completed and this populates the db
    with the new user's basic character stats """

    # select the appropriate table
    table = dynamodb.Table('character_info')

    # populate item based on the user
    table.put_item(
       Item={
            'username': event['userName'],
            'str': 10,
            'dex': 10,
            'int': 10,
            'lv': 1,
            'exp': 0
        }
    )

    return event