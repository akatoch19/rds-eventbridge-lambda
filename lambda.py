import os
import psycopg2
import json
import boto3

def lambda_handler(event, context):
    secret_name = os.environ['DB_SECRET_ARN']
    region_name = os.environ['AWS_REGION']
    db_name = os.environ['DB_NAME']
    stored_proc = os.environ['STORED_PROCEDURE']

    # Fetch credentials from Secrets Manager
    session = boto3.session.Session()
    client = session.client(service_name='secretsmanager', region_name=region_name)
    secret = json.loads(client.get_secret_value(SecretId=secret_name)['SecretString'])

    try:
        conn = psycopg2.connect(
            host=secret['host'],
            dbname=db_name,
            user=secret['username'],
            password=secret['password'],
            port=secret['port']
        )
        cur = conn.cursor()

        # Safely execute stored procedure
        print(f"Executing stored procedure: {stored_proc}")
        cur.execute(f"CALL {stored_proc};")

        conn.commit()
        cur.close()
        conn.close()
        return {"status": "success", "procedure": stored_proc}
    except Exception as e:
        print(f"DB Connection or Execution failed: {e}")
        return {"status": "error", "message": str(e)}
