
#Update package
sudo apt update -y

#Install apache if not installed
REQUIRED_PKG="apache2"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  sudo apt-get --yes install $REQUIRED_PKG 
fi


#Start apache server if not service not running
if ! pidof apache2 > /dev/null
then
    /etc/init.d/apache2 restart > /dev/null
fi

#Create a tar archive
myname="Vivek"
timestamp=$(date '+%d%m%Y-%H%M%S')
tar -cf ${myname}-httpd-logs-${timestamp}.tar *.log
mv vivek-httpd-logs-$timestamp.tar /tmp

#install awscli
sudo apt install awscli

#Copy to S3
aws s3 \
s3_bucket="arn:aws:s3:::upgrad-vivek"
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar

#Task 3 update
#create inventory.html
cd /var/www/html/

touch inventory.html
cat > inventory.html <<EOF
<html>
 <head>
 </head>
 <body>
    <div class="row">
        <div class="column left">
            <h2>Log Type</h2>
            <p>Data..</p>
        </div>
        <div class="Column middle">
            <h2>Time Created</h2>
            <p>Data..</p>
        </div>
        <div class="column middle"
            <h2>Type</h2>
            <p>Data..</p>
        </div>
        <div class="colum right"
            <h2>Size</h2>
            <p>Data..</p>
        </div>
    </div>
 </body>
</html>

EOF

#create cron job to run everyday at 3 am
cd /etc/cron.d/

cat>automation<< EOF

#output
0 3 * * * /root/Automation_Project/automation.sh
EOF
