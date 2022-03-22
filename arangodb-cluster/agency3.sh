arangod --server.endpoint tcp://0.0.0.0:8533 \
  --server.authentication false \
  --server.export-metrics-api true \
  --agency.my-address tcp://192.168.51.188:8533 \
  --agency.activate true \
  --agency.size 3 \
  --agency.endpoint tcp://192.168.51.188:8531 \
  --agency.endpoint tcp://192.168.51.188:8532 \ 
  --agency.endpoint tcp://192.168.51.188:8533 \
  --agency.supervision true \
  --database.directory agent3

