#!/bin/sh
#
# Install AWSCLI
#
yum install awscli -y
#
# Install AWSCLI
#
/bin/curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
python get-pip.py
pip install awscli
#
# Setup DNS record update
#
PRIVATEIP=$(curl -s 'http://169.254.169.254/latest/meta-data/local-ipv4')
cat << EOF > /root/dns_update.json
{"Comment": "Bastion DNS record update","Changes":[{"Action":"UPSERT","ResourceRecordSet":{"Name":"${hostname}.${dns_domain_name}","Type":"A","TTL":300,"ResourceRecords":[{"Value":"$PRIVATEIP"}]}}]}
EOF
#
# Update DNS record
#
aws route53 change-resource-record-sets --hosted-zone-id ${hosted_zone_id} --change-batch file:///root/dns_update.json
#
# Set hostname
#
hostname ${hostname}.${dns_domain_name}
hostnamectl set-hostname ${hostname}.${dns_domain_name}
#
# Setup SSM Agent
#
yum install amazon-ssm-agent python-deltarpm -y
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent
echo "systemctl start amazon-ssm-agent" >> /etc/rc.local
#
# Setup SSM Agent RHEL
#
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent
#
# Add EPEL
#
yum install -y wget 
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y epel-release-latest-7.noarch.rpm 
#
# Install tinyproxy
#
yum install -y tinyproxy
systemctl enable tinyproxy
systemctl start tinyproxy
#
# Init to allow VPC
#
sed -i -e 's@Allow 127.0.0.1@Allow ${vpc_cidr}@g'  /etc/tinyproxy/tinyproxy.conf
systemctl restart tinyproxy
#
# Install region specific CodeDeploy agent
#
yum install -y ruby
wget https://aws-codedeploy-${aws_region}.s3.amazonaws.com/latest/install
chmod +x ./install
./install auto
#
# Install Cloudwatch logs agent
#
#curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
#python ./awslogs-agent-setup.py --region ${aws_region}
#
# Allow for additional commands
#
${supplementary_user_data}
