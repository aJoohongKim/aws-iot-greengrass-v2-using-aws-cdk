CONFIG_THING=$1
CONFIG_CREDENTIAL=$2

PROJECT_PREFIX=IotDataDev

JQ_ARG='.["'$PROJECT_PREFIX'-IoTThingStack"].OutputThingNamePrefix'
THING_NAME=$(cat $CONFIG_THING | jq -r $JQ_ARG) #ex>  

JQ_ARG='.["'$PROJECT_PREFIX'-IoTThingStack"].OutputThingGroupName'
THING_GROUP=$(cat $CONFIG_THING | jq -r $JQ_ARG) #ex>  

JQ_ARG='.["'$PROJECT_PREFIX'-IoTThingStack"].OutputProjectRegion'
REGION=$(cat $CONFIG_THING | jq -r $JQ_ARG) #ex>  

JQ_ARG='.["'$PROJECT_PREFIX'-IoTThingStack"].OutputIoTTokenRole'
ROLE_NAME=$(cat $CONFIG_THING | jq -r $JQ_ARG) #ex>  

JQ_ARG='.["'$PROJECT_PREFIX'-IoTThingStack"].OutputIoTTokenRoleAlias'
ROLE_ALIAS_NAME=$(cat $CONFIG_THING | jq -r $JQ_ARG) #ex>  

AWS_ACCESS_KEY_ID=$(cat $CONFIG_CREDENTIAL | jq -r '.Credentials.AccessKeyId')
AWS_SECRET_ACCESS_KEY=$(cat $CONFIG_CREDENTIAL | jq -r '.Credentials.SecretAccessKey')
AWS_SESSION_TOKEN=$(cat $CONFIG_CREDENTIAL | jq -r '.Credentials.SessionToken')

DEV_ENV=true

java -version

mkdir greengrass
cd greengrass
INSTALL_ROOT=GreengrassCore
curl -s https://d2s8p88vqu9w66.cloudfront.net/releases/greengrass-nucleus-latest.zip > greengrass-nucleus-latest.zip && unzip greengrass-nucleus-latest.zip -d GreengrassCore

GREENGRASS_ROOT=/greengrass/v2
GREENGRASS_JAR=./GreengrassCore/lib/Greengrass.jar
sudo -E java -Droot=$GREENGRASS_ROOT \
  -Dlog.store=FILE \
  -jar $GREENGRASS_JAR \
  --aws-region $REGION \
  --thing-name $THING_NAME \
  --thing-group-name $THING_GROUP \
  --tes-role-name $ROLE_NAME \
  --tes-role-alias-name $ROLE_ALIAS_NAME \
  --component-default-user ggc_user:ggc_group \
  --provision true \
  --setup-system-service true
