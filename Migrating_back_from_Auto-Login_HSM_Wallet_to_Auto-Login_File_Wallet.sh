echo "*****************************Migrating back from Auto-login HSM Wallet to Auto login File Wallet*********************************"

usage ()
{
  echo 'Usage : sh Migrating_back_from_Auto-Login_HSM_Wallet_to_Auto-Login_File_Wallet.sh <Oracle env fileanme> <File wallet password> <CM_Username:CM_Password>'
  exit
}
if [ "$#" -ne 3 ]
then
        usage
fi

ENV_FILE="$1"
FILE_PWD="$2"
CM_USER_PWD="$3"

source $ENV_FILE

sqlplus / as sysdba <<EOF

!mv /var/opt/oracle/dbaas_acfs/THALES/wallet_root/tde/cwallet.sso /var/opt/oracle/dbaas_acfs/THALES/wallet_root/tde/cwallet_bkp.sso

ALTER SYSTEM SET TDE_CONFIGURATION="KEYSTORE_CONFIGURATION=FILE|HSM" scope=both;

ADMINISTER KEY MANAGEMENT SET ENCRYPTION KEY IDENTIFIED BY "$FILE_PWD" reverse migrate using "$CM_USER_PWD" with backup;

shu immediate;

startup;

ADMINISTER KEY MANAGEMENT SET KEYSTORE OPEN IDENTIFIED BY "$FILE_PWD";

alter database open;

ADMINISTER KEY MANAGEMENT CREATE AUTO_LOGIN KEYSTORE FROM KEYSTORE IDENTIFIED BY "$FILE_PWD";

shu immediate;

startup;

COLUMN WRL_PARAMETER FORMAT A50;

SET LINES 200;

SELECT WRL_TYPE, WRL_PARAMETER, WALLET_TYPE, STATUS FROM V\$ENCRYPTION_WALLET;

exit
EOF

echo "Going to stop the database"
srvctl stop database -d $ORACLE_UNQNAME

echo "Going to start the database"
srvctl start database -d $ORACLE_UNQNAME
