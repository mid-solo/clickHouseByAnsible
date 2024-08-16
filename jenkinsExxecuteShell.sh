#!/bin/bash -e

echo "Keeper count:$keeper_count"
echo "Node count: $node_count"
echo "Team name: $team"
echo "Cluster name: $cluster"

if [ "$node_count" -gt 0 ] && [ "$node_count" -le 10 ] && [ "$keeper_count" -gt 0 ] && [ "$keeper_count" -le 10 ]; then
    echo "node and keeper count are within limits. Proceed"
else
    echo "node_count and keeper_count should be between 1 and 10."
    exit 1
fi

# File to store used parameter pairs
USED_PAIRS_FILE="/data/ext/used_pairs.txt"

# Read input parameters
VAR1="${team}"
VAR2="${cluster}"

# Check if the pairs file exists, if not create it
if [ ! -f "$USED_PAIRS_FILE" ]; then
    touch "$USED_PAIRS_FILE"
fi

# Check if the var2 value has already been used with a different var1
if grep -q "^.*,${VAR2}$" "$USED_PAIRS_FILE" && ! grep -q "^${VAR1},${VAR2}$" "$USED_PAIRS_FILE"; then
    echo "Value ${VAR2} has already been used with a different var1."
    exit 1
fi

# Store the new pair if not already present
if ! grep -q "^${VAR1},${VAR2}$" "$USED_PAIRS_FILE"; then
    echo "${VAR1},${VAR2}" >> "$USED_PAIRS_FILE"
    echo "Pair (${VAR1}, ${VAR2}) stored successfully."
else
    echo "Pair (${VAR1}, ${VAR2}) already exists."
fi


clickhouse_password=$(gcloud secrets versions access latest --secret=CLICKHOUSE_PASSWORD)
access_key=$(gcloud secrets versions access latest --secret=PROD_CH_ACCESS_ID)
secret_key=$(gcloud secrets versions access latest --secret=PROD_CH_SECRET_KEY)

ansible-playbook  /data/dist/playbooks/click-house/playbook.yaml --extra-vars "keeper_count=${keeper_count} node_count=${node_count} team=${team} cluster=${cluster} access_key=${access_key} secret_key=${secret_key} clickhouse_password=${clickhouse_password}"

