LOG_FILE_PATH="/var/log/stellar-core.log"
BUCKET_DIR_PATH="/var/history/buckets"

NODE_HOME_DOMAIN="{{node_home_domain}}"

NODE_SEED="{{node_seed}} self"
NODE_IS_VALIDATOR=true

DATABASE="postgresql://dbname={{db_name}} user={{db_user}} password={{db_password}} host={{db_host}}"

HTTP_PORT=11626
PUBLIC_HTTP_PORT=true

NETWORK_PASSPHRASE="LiveNet Global XDBChain Network ; November 2023"

PEER_PORT=11625

KNOWN_CURSORS=["HORIZON"]

FAILURE_SAFETY=1
CATCHUP_COMPLETE=true

{%- for c_home_domain in config %}

[[HOME_DOMAINS]]
HOME_DOMAIN="{{c_home_domain}}"
QUALITY="HIGH"

{%- for quorum in config[c_home_domain] %}
{% if c_home_domain == node_home_domain and quorum["NAME"] == node_name %}
{% else %}
[[VALIDATORS]]
NAME="{{quorum["NAME"]}}"
HOME_DOMAIN="{{c_home_domain}}"
PUBLIC_KEY="{{quorum["PUBLIC_KEY"]}}"
ADDRESS="{{quorum["ADDRESS"]}}"
HISTORY="{{quorum["HISTORY"]}}"
{% endif %}
{% endfor %}

{% endfor %}

[HISTORY.local]
get="aws s3 cp s3://xdbfoundation-history/livenet/s{{node_name}}/{0} {1}"
put="aws s3 cp {0} s3://xdbfoundation-history/livenet/s{{node_name}}/{1}"