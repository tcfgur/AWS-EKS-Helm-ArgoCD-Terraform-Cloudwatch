import logging
import boto3
import json
import pg8000
import socket
from flask import Flask, jsonify
from flask_cors import CORS
import watchtower
from logging.handlers import RotatingFileHandler

# Flask uygulamasını oluştur
app = Flask(__name__)
CORS(app)

# CloudWatch Logs istemcisini oluştur ve global olarak ayarla
boto3.setup_default_session(region_name='eu-central-1')
cloudwatch = boto3.client('logs')

# CloudWatch Log grubunun adı
log_group_name = '/eks-backend/application/logs'

# Log grubunu kontrol et ve oluştur
def ensure_log_group():
    try:
        response = cloudwatch.describe_log_groups(logGroupNamePrefix=log_group_name)
        if not any(group['logGroupName'] == log_group_name for group in response['logGroups']):
            cloudwatch.create_log_group(logGroupName=log_group_name)
            logger.info("CloudWatch Log grubu oluşturuldu.")
        else:
            logger.info("CloudWatch Log grubu zaten mevcut.")
    except Exception as e:
        logger.error("CloudWatch Log grubu oluşturma hatası: %s", str(e))

# Logger ayarları
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

# Konsol ve CloudWatch için log handler'ları ayarla
console_handler = logging.StreamHandler()
logger.addHandler(console_handler)

cloudwatch_handler = watchtower.CloudWatchLogHandler(log_group=log_group_name)
logger.addHandler(cloudwatch_handler)

ensure_log_group()

# PostgreSQL bilgilerini al ve bağlan
def get_postgresql_version():
    secrets_manager_client = boto3.client('secretsmanager')
    rds_client = boto3.client('rds')
    
    try:
        secret_response = secrets_manager_client.get_secret_value(SecretId='ukcasestudy-postgresql-credentials')
        secret_data = json.loads(secret_response['SecretString'])
        endpoint = rds_client.describe_db_instances(DBInstanceIdentifier='my-postgresql-db')['DBInstances'][0]['Endpoint']['Address']
        
        conn = pg8000.connect(host=endpoint, database='postgres', user=secret_data['username'], password=secret_data['password'])
        cursor = conn.cursor()
        cursor.execute("SELECT version();")
        postgres_version = cursor.fetchone()[0]
        cursor.close()
        conn.close()
        return postgres_version
    except Exception as e:
        logger.error("PostgreSQL sürümünü alma hatası: %s", str(e))
        return str(e)

@app.route('/get-postgresql-version')
def get_postgresql_version_endpoint():
    postgres_version = get_postgresql_version()
    hostname = socket.gethostname()
    return jsonify({"postgresql_version": postgres_version, "hostname": hostname})

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)