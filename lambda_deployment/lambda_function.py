import pymysql
import os
import json

# Fetch RDS details from environment variables
RDS_HOST = os.environ['RDS_HOST']
RDS_USER = os.environ['RDS_USER']
RDS_PASSWORD = os.environ['RDS_PASSWORD']
RDS_DB_NAME = os.environ['RDS_DB_NAME']

# Establish connection to the RDS instance
def connect_to_rds():
    try:
        connection = pymysql.connect(
            host=RDS_HOST,
            user=RDS_USER,
            password=RDS_PASSWORD,
            database=RDS_DB_NAME,
            cursorclass=pymysql.cursors.DictCursor
        )
        return connection
    except Exception as e:
        print(f"ERROR: Unable to connect to RDS: {e}")
        raise e

# Lambda handler
def lambda_handler(event, context):
    try:
        # Connect to RDS
        connection = connect_to_rds()
        print("SUCCESS: Connection to RDS instance succeeded")

        # Simple query
        with connection.cursor() as cursor:
            cursor.execute("SELECT NOW() AS current_time")
            result = cursor.fetchone()

        # Return the query result
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Connection successful',
                'current_time': result['current_time']
            })
        }
    except Exception as e:
        print(f"ERROR: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Internal server error',
                'error': str(e)
            })
        }
    finally:
        if 'connection' in locals() and connection.open:
            connection.close()
