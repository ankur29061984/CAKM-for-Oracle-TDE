echo "********************************Migrate from Auto-login Software Wallet to Auto login HSM Wallet******************************"

usage ()
{
  echo 'Usage : sh Migrate_from_Auto-Login_Software_Wallet_to_Auto-Login_HSM_Wallet.sh <Oracle env fileanme> <File wallet password> <CM_Username:CM_Password>'
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

SHUTDOWN IMMEDIATE;

STARTUP;

ADMINISTER KEY MANAGEMENT SET KEYSTORE OPEN IDENTIFIED BY "$FILE_PWD";

ALTER DATABASE OPEN;

ALTER SYSTEM SET TDE_CONFIGURATION="KEYSTORE_CONFIGURATION=FILE" scope=both;

COLUMN WRL_PARAMETER FORMAT A50;

SET LINES 200;

SELECT WRL_TYPE, WRL_PARAMETER, WALLET_TYPE, STATUS FROM V\$ENCRYPTION_WALLET;

select masterkeyid from v\$database_key_info;

ADMINISTER KEY MANAGEMENT ADD SECRET '$CM_USER_PWD' FOR CLIENT 'HSM_PASSWORD' IDENTIFIED BY "$FILE_PWD" with backup;

ADMINISTER KEY MANAGEMENT CREATE AUTO_LOGIN KEYSTORE FROM KEYSTORE IDENTIFIED BY "$FILE_PWD";

ALTER SYSTEM SET TDE_CONFIGURATION="KEYSTORE_CONFIGURATION=HSM|FILE" scope=both;

select masterkeyid from v\$database_key_info;

ADMINISTER KEY MANAGEMENT SET ENCRYPTION KEY IDENTIFIED BY "$CM_USER_PWD" FORCE KEYSTORE MIGRATE USING "$FILE_PWD";

COLUMN WRL_PARAMETER FORMAT A50;

SET LINES 200;

SELECT WRL_TYPE, WRL_PARAMETER, WALLET_TYPE, STATUS FROM V\$ENCRYPTION_WALLET;

select masterkeyid from v\$database_key_info;

select key_id,creation_time,key_use,keystore_type,origin,con_id from v\$encryption_keys order by CREATION_TIME desc;

CREATE TABLESPACE ENCRYPTED_SPACE DATAFILE '\$ORACLE_HOME/dbs/enc_space.dbf' SIZE 150M ENCRYPTION USING 'AES256' DEFAULT STORAGE (ENCRYPT);

CREATE TABLE CUSTOMERS (ID INT, NAME VARCHAR (200), CREDIT_LIMIT INT) TABLESPACE ENCRYPTED_SPACE;

INSERT INTO CUSTOMERS VALUES (1, 'Bob', 10000);

SELECT * FROM CUSTOMERS;

SELECT * FROM V\$ENCRYPTED_TABLESPACES;

exit

EOF

echo "Going to stop the database"
srvctl stop database -d $ORACLE_UNQNAME

echo "Going to start the database"
srvctl start database -d $ORACLE_UNQNAME