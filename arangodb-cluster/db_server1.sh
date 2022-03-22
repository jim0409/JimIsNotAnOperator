arangod --server.authentication=false \
  --server.endpoint tcp://0.0.0.0:8541 \
  --server.export-metrics-api true \
  --cluster.my-address tcp://192.168.51.188:8541 \
  --cluster.my-role DBSERVER \
  --cluster.agency-endpoint tcp://192.168.51.188:8531 \
  --cluster.agency-endpoint tcp://192.168.51.188:8532 \
  --cluster.agency-endpoint tcp://192.168.51.188:8533 \
  --database.directory dbserver1

