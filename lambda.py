import os
import psycopg2
import json
import boto3

def lambda_handler(event, context):
    secret_name = os.environ['DB_SECRET_ARN']
    region_name = os.environ['AWS_REGION']

    # Fetch credentials from Secrets Manager
    session = boto3.session.Session()
    client = session.client(service_name='secretsmanager', region_name=region_name)
    secret = json.loads(client.get_secret_value(SecretId=secret_name)['SecretString'])

    try:
        conn = psycopg2.connect(
            host=secret['host'],
            dbname=os.environ['DB_NAME'],
            user=secret['username'],
            password=secret['password'],
            port=secret['port']
        )
        cur = conn.cursor()
        cur.execute("CALL svc_registration_migration.p_s3translation_all(7, 'motus-dev-data-translation', 2);")
        conn.commit()
        cur.close()
        conn.close()
        return {"status": "success"}
    except Exception as e:
        print(f"DB Connection failed: {e}")
        return {"status": "error", "message": str(e)}
