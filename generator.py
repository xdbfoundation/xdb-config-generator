import json
import sys
from jinja2 import Environment, FileSystemLoader


config = json.load(open("config.json", "r"))

env = Environment(loader=FileSystemLoader('templates'))
template = env.get_template('digitalbits-core.tpl')

data = {
    "config": config, 
    "node_home_domain": sys.argv[1],
    "node_seed": sys.argv[2], 
    "node_name": sys.argv[3],
    "db_name": sys.argv[4], 
    "db_user": sys.argv[5], 
    "db_password": sys.argv[6], 
    "db_host": sys.argv[7], 
    "history_get": sys.argv[8],
    "history_put": sys.argv[9]
}

render = template.render(**data)

print(render)
