# CAKM for Oracle TDE

## Overview
CipherTrust Application Key Management (CAKM) for Oracle Transparent Data Encryption (TDE) provides a secure way to manage encryption keys for Oracle databases. This document outlines auomation for CAKM integration with Oracle TDE.

## Automation scripts

### 1. Migration from Auto-Login File Wallet to Auto-Login HSM Wallet
- **Description**: Migrates an existing Auto-Login File Wallet to an HSM-based Auto-Login Wallet.
- **Benefits**: Enhanced security by leveraging HSM for key management.
- **Steps**:
  1. Configure CipherTrust Manager for Oracle TDE.
  2. Export existing keys from Auto-Login File Wallet.
  3. Import and register keys into the HSM Wallet.
  4. Update Oracle TDE to use the new HSM Wallet.
  5. Validate the migration and database encryption.

### 2. Migration from Auto-Login File Wallet with PDB to Auto-Login HSM Wallet with PDB
- **Description**: Migrates an Oracle TDE Auto-Login File Wallet with Pluggable Databases (PDBs) to an HSM-based Auto-Login Wallet.
- **Benefits**: Ensures seamless encryption across PDBs while using HSM for key security.
- **Steps**:
  1. Identify PDBs using the current Auto-Login File Wallet.
  2. Export encryption keys from the File Wallet.
  3. Register keys into CipherTrust Manager and configure HSM integration.
  4. Update PDBs to use the new HSM Wallet.
  5. Perform validation and testing.

### 3. Migrating Back from Auto-Login HSM Wallet to Auto-Login File Wallet
- **Description**: Provides a rollback mechanism by migrating from an HSM Wallet back to a File Wallet.
- **Benefits**: Ensures business continuity in case of HSM unavailability.
- **Steps**:
  1. Export keys from the HSM Wallet.
  2. Import them into a new Auto-Login File Wallet.
  3. Update Oracle TDE to use the new File Wallet.
  4. Validate and test decryption operations.

## Prerequisites
- Oracle Database with TDE enabled.
- CipherTrust Manager (version 2.19 or later recommended).
- Required permissions for managing Oracle Wallets and TDE keys.

## Validation
The following use cases have been successfully validated with CipherTrust Manager 2.19:
- Migration from Auto-Login File to Auto-Login HSM Wallet.
- Migration from Auto-Login File Wallet with PDB to Auto-Login HSM Wallet with PDB.
- Migration back from Auto-Login HSM Wallet to Auto-Login File Wallet.
- TDE master key rotation.

## Support
For any issues or further assistance, please refer to the official **CipherTrust Manager Documentation** on https://thalesdocs.com or contact your security administrator.

