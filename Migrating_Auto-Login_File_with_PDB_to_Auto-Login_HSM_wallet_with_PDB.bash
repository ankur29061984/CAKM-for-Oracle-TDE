echo "**************************Migrate Auto-Login File wallet with PDB to Auto-Login HSM wallet with PDB**************************"

usage ()
{
  echo 'Usage : sh Migrating_Auto-Login_File_with_PDB_to_Auto-Login_HSM_wallet_with_PDB.sh <Oracle env fileanme> <File wallet password> <CM_Username:CM_Password>'
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

COLUMN WRL_PARAMETER FORMAT A50;

SET LINES 200;

SELECT WRL_TYPE, WRL_PARAMETER, WALLET_TYPE, STATUS FROM V\$ENCRYPTION_WALLET;

!mv /var/opt/oracle/dbaas_acfs/THALES/wallet_root/tde/cwallet.sso /var/opt/oracle/dbaas_acfs/THALES/wallet_root/tde/cwallet_bkp.sso

shutdown immediate;

startup;

ADMINISTER KEY MANAGEMENT SET KEYSTORE OPEN IDENTIFIED BY "$FILE_PWD";

alter database open;

ALTER PLUGGABLE DATABASE ALL OPEN READ WRITE;

show parameter WALLET_ROOT;

ALTER SYSTEM SET TDE_CONFIGURATION="KEYSTORE_CONFIGURATION=HSM|FILE" scope=both;

show parameter TDE_CONFIGURATION;

ADMINISTER KEY MANAGEMENT SET ENCRYPTION KEY IDENTIFIED BY "$CM_USER_PWD" MIGRATE USING "$FILE_PWD" with backup;

COLUMN WRL_PARAMETER FORMAT A50;

SET LINES 200;

SELECT WRL_TYPE, WRL_PARAMETER, WALLET_TYPE, STATUS FROM V\$ENCRYPTION_WALLET;

ADMINISTER KEY MANAGEMENT SET KEY IDENTIFIED BY "$CM_USER_PWD" CONTAINER=ALL;

COLUMN WRL_PARAMETER FORMAT A50;

SET LINES 200;

select * from v\$encryption_wallet;

ADMINISTER KEY MANAGEMENT SET KEYSTORE CLOSE IDENTIFIED BY "$CM_USER_PWD";

ALTER SYSTEM SET TDE_CONFIGURATION="KEYSTORE_CONFIGURATION=FILE" SCOPE=both;

ADMINISTER KEY MANAGEMENT SET KEYSTORE OPEN IDENTIFIED BY "$FILE_PWD" CONTAINER=ALL;

ADMINISTER KEY MANAGEMENT ADD SECRET '$CM_USER_PWD' FOR CLIENT 'HSM_PASSWORD' IDENTIFIED BY "$FILE_PWD" with backup;

ADMINISTER KEY MANAGEMENT CREATE AUTO_LOGIN KEYSTORE FROM KEYSTORE IDENTIFIED BY "$FILE_PWD";

ALTER SYSTEM SET TDE_CONFIGURATION="KEYSTORE_CONFIGURATION=HSM|FILE" scope=both;

shutdown immediate;

startup;

ALTER PLUGGABLE DATABASE ALL OPEN READ WRITE;

select WRL_TYPE, STATUS, WALLET_TYPE from v\$encryption_wallet;

show con_name;

COLUMN WRL_PARAMETER FORMAT A50;

SET LINES 200;

select * from v\$encryption_wallet;

ALTER SESSION SET CONTAINER = PDB19C;

COLUMN WRL_PARAMETER FORMAT A50;

SET LINES 200;

select * from v\$encryption_wallet;

exit

EOF

echo "Going to stop the database"
srvctl stop database -d $ORACLE_UNQNAME

echo "Going to start the database"
srvctl start database -d $ORACLE_UNQNAME
