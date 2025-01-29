# CAKM for Oracle TDE

![image](https://github.com/user-attachments/assets/b4d44877-442f-4d95-8eba-642867355029)


## Overview
CipherTrust Application Key Management (CAKM) for Oracle Transparent Data Encryption (TDE) provides a secure way to manage encryption keys for Oracle databases. This document outlines auomation for CAKM integration with Oracle TDE.

## Automation scripts for Oracle 19c Exadata Cloud@Customer (ExaCC) environment 

### 1. Migration from Auto-Login File Wallet to Auto-Login HSM Wallet
- **Description**: Migrates an existing Auto-Login File Wallet to an HSM-based Auto-Login Wallet.
- **Benefits**: Enhanced security by leveraging HSM for key management.
- **Steps**:
  1. Install CAKM for Oracle TDE library.
  2. Integrate CAKM for Oracle TDE library with CipherTrust Manager.
  3. Ensure that Auto-Login File wallet is in open state.
  4. Run the Migrate_from_Auto-Login_Software_Wallet_to_Auto-Login_HSM_Wallet bash script.
  5. Validate the migration and database encryption.

### 2. Migration from Auto-Login File Wallet with PDB to Auto-Login HSM Wallet with PDB
- **Description**: Migrates an Oracle TDE Auto-Login File Wallet with Pluggable Databases (PDBs) to an HSM-based Auto-Login Wallet.
- **Benefits**: Ensures seamless encryption across PDBs while using HSM for key security.
- **Steps**:
  1. Install CAKM for Oracle TDE library.
  2. Integrate CAKM for Oracle TDE library with CipherTrust Manager.
  3. Ensure that Auto-Login File wallet is in open state with PDB database.
  4. Run the Migrating_Auto-Login_File_with_PDB_to_Auto-Login_HSM_wallet_with_PDB bash script.
  5. Validate the migration and database encryption.

### 3. Migrating Back from Auto-Login HSM Wallet to Auto-Login File Wallet
- **Description**: Provides a rollback mechanism by migrating from an HSM Wallet back to a File Wallet.
- **Benefits**: Ensures business continuity in case of HSM unavailability.
- **Steps**:
  1. Ensure that Auto-Login HSM wallet is in open state.
  2. Run the Migrating_back_from_Auto-Login_HSM_Wallet_to_Auto-Login_File_Wallet bash script.
  3. Validate the migration and database encryption.

## Prerequisites
- Oracle19C Database with TDE enabled.
- CipherTrust Manager.
- CAKM for Oracle TDE library
- Required permissions for managing Oracle Wallets and TDE keys.

## Support
For any issues or further assistance, please refer to the official **CipherTrust Manager Documentation** on https://thalesdocs.com or contact your security administrator.

