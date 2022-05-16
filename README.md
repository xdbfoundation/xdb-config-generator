# DigitalBits Config Generator

This generator was created to simplify config generation for large amounts of quorum sets

The generator expects a `config.json` file to be present in the project root. 

You can find this file, along with actual structure of DigitalBits Quorum Sets, here - https://livenet.digitalbits.io/config.json

## Params

The generator expects 9 parameters to be provided through CLI arguments:
```
    "node_home_domain": a home domain to which the node is belong to,
    "node_seed": a secret seed of the node, 
    "node_name": name of the node,
    "db_name": name of a database, 
    "db_user": database user, 
    "db_password": database password, 
    "db_host": database host, 
    "history_get": how to get the history of the node,
    "history_put": how to put the history of the node
```
Exactly in that ^ order.


## Usage example
```
cd xdb-config-generator
wget https://livenet.digitalbits.io/config.json
pip install -r requirements.txt

python generator.py livenet.example.com SAZLJGZ4GAVWNSU44R3SFD4NAZMZEVTS375USHGNJMGSWV7JRHALZDEF my_node_1 db_name my_user secret_password localhost:5432 "curl -sf https://history.livenet.example.com/livenet/my_node_1/{0} -o {1}" "aws s3 cp {0} s3://my_history_bucket/livenet/my_node_1/{1}" > /etc/digitalbits.cfg
```