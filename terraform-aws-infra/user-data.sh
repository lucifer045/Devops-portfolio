#!/bin/bash
# Simple user-data to install nginx and a demo page
yum update -y
amazon-linux-extras install nginx1 -y || yum install -y nginx
systemctl enable nginx
systemctl start nginx

cat > /usr/share/nginx/html/index.html <<'EOF'
<html>
  <head><title>DevOps Portfolio Demo</title></head>
  <body>
    <h1>DevOps Portfolio Demo</h1>
    <p>Deployed by Terraform - $(date)</p>
  </body>
</html>
EOF
