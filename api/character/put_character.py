# import libraries
import json

def put_character(query_params, dynamodb):
    """ put character
    the http function that invokes when the basic character 
    stats are requested to be updated by the user """

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
        # initialize character info
        character_info = character_info['Item']

        # initialize validity flag for stats
        valid_stat = False

        # initialize skipped stats if they do not exist
        skipped_stats = []

        # initialize updated stats if stats were updated successfully
        updated_stats = []

        # iterate through the query params
        for user_stat_name, user_stat_update_value in query_params.items():
            # skip user parameter
            if user_stat_name == 'user':
                continue

            # initialize the user stat name and value
            user_stat_name = user_stat_name.lower()

            # attempt to convert user value to an integer
            try:
                user_stat_update_value = int(user_stat_update_value)

            # return error in case supplied user stat is not an integer
            except ValueError:
                # set the response
                response['statusCode'] = 400
                response['body'] = json.dumps({'message': 'All parameters provided must be integers'})

                return response

            # check if user supplied param exists within character info
            if user_stat_name.lower() in character_info:
                # update valid stat flag
                valid_stat = True

                # initialize the stat values
                character_stat_value = int(character_info[user_stat_name])
                updated_stat_value = character_stat_value + user_stat_update_value

                # update the updated stats for response
                updated_stats.append({user_stat_name.upper(): f'{character_stat_value} --> {updated_stat_value}'})

                # update the stat in the character info entry
                character_info[user_stat_name] = str(updated_stat_value)
                
            # add to the skipped stats list otherwise
            else:
                skipped_stats.append(user_stat_name)
                    
        # update the character table accordingly
        character_table.put_item(Item=character_info)

        # set the response
        if valid_stat:
            response['statusCode'] = 200
            response['body'] = json.dumps({
                'message': f'Updated Successfully', 
                'updated': updated_stats, 
                'skipped': skipped_stats
            })
        else:
            response['statusCode'] = 400
            response['body'] = json.dumps({
                'message': f'User supplied stats do not exist', 
                'updated': updated_stats, 
                'skipped': skipped_stats
            })

    # otherwise assume no such user exists
    else:
        # set the response
        response['statusCode'] = 400
        response['body'] = json.dumps({'message': 'User does not exist'})

    return response
