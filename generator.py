import json
import sys
import boto3
from botocore.exceptions import ClientError
from jinja2 import Environment, FileSystemLoader

def get_secret(secret_name):
    """
    Retrieves a secret from AWS Secrets Manager
    """
    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(service_name='secretsmanager')

    try:
        get_secret_value_response = client.get_secret_value(SecretId=secret_name)
    except ClientError as e:
        print("Error retrieving secret: ", e)
        sys.exit(1)
    else:
        if 'SecretString' in get_secret_value_response:
            secret = get_secret_value_response['SecretString']
            return json.loads(secret)
        else:
            print("Error: Secret does not contain 'SecretString'")
            sys.exit(1)

# Configuration file and template loader
config = json.load(open("config.json", "r"))

env = Environment(loader=FileSystemLoader('templates'))
template = env.get_template('stellar-core.tpl')

# Command line arguments for node specific details
node_home_domain = sys.argv[1]
node_seed = sys.argv[2]
node_name = sys.argv[3]

# Construct the secret name
secret_name = f"xdbchain/livenet/db-parameters/{node_name}"

# Get the secret from AWS Secrets Manager
secret = get_secret(secret_name)

# Prepare the data for the template
data = {
    "config": config,
    "node_home_domain": node_home_domain,
    "node_seed": node_seed,
    "node_name": node_name,
    "db_name": secret["dbname"],
    "db_user": secret["username"],
    "db_password": secret["password"],
    "db_host": secret["host"]
}

# Render the template with the data
render = template.render(**data)

# Output the rendered configuration
print(render)
