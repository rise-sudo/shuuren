def post_confirmation_handler(event, context):

    # send post authentication data to cloudwatch logs
    # code source: https://docs.amazonaws.cn/en_us/cognito/latest/developerguide/user-pool-lambda-post-authentication.html
    print("Authentication successful")
    print("Trigger function =", event['triggerSource'])
    print("User pool = ", event['userPoolId'])
    print("App client ID = ", event['callerContext']['clientId'])
    print("User ID = ", event['userName'])

    # return to Amazon Cognito
    return event