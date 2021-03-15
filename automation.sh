
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
