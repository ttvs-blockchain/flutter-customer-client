const nameDB = 'vaxpass.db';
const nameUserTable = 'user';
const nameCertificateTable = 'certificate';

const columnID = 'id';
const columnSystemID = 'system_id';
const columnName = 'name';
const columnCountryCode = 'country_code';
const columnCountryID = 'country_id';
const columnGender = 'gender';
const columnDateOfBirth = 'date_of_birth';
const columnEmail = 'email';

const columnUserID = 'user_id';
const columnCertID = 'cert_id';
const columnPersonID = 'person_id';
const columnBrand = 'brand';
const columnNumDose = 'num_dose';
const columnIssueTime = 'issue_time';
const columnIssuer = 'issuer';
const columnRemark = 'remark';
const columnGlobalChainTxHash = 'global_chain_tx_hash';
const columnGlobalChainBlockNum = 'global_chain_block_num';
const columnGlobalChainTimestamp = 'global_chain_timestamp';
const columnLocalChainID = 'local_chain_id';
const columnLocalChainTxHash = 'local_chain_tx_hash';
const columnLocalChainBlockNum = 'local_chain_block_num';
const columnLocalChainTimestamp = 'local_chain_timestamp';
const columnIsValidated = 'is_validated';

const queryCreateUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
        "id"	INTEGER NOT NULL UNIQUE,
	      "system_id"	TEXT NOT NULL UNIQUE,
	      "name"	TEXT NOT NULL,
	      "country_code"	TEXT NOT NULL,
	      "country_id"	TEXT NOT NULL,
	      "gender"	INTEGER NOT NULL,
	      "date_of_birth"	TEXT NOT NULL,
	      "email"	TEXT NOT NULL UNIQUE,
	      PRIMARY KEY("id")
      );''';
const queryCreateCertificateTable =
    '''CREATE TABLE IF NOT EXISTS "certificate" (
        "id"	INTEGER NOT NULL UNIQUE,
	      "cert_id"	TEXT NOT NULL UNIQUE,
	      "person_id"	TEXT NOT NULL,
	      "name"	TEXT NOT NULL,
	      "brand"	TEXT NOT NULL,
	      "num_dose"	INTEGER,
	      "issue_time"	TEXT NOT NULL,
	      "issuer"	TEXT NOT NULL,
	      "remark"	TEXT,
	      "global_chain_tx_hash"	TEXT UNIQUE,
	      "global_chain_block_num"	INTEGER,
	      "global_chain_timestamp"	TEXT,
	      "local_chain_id"	TEXT NOT NULL,
	      "local_chain_tx_hash"	TEXT NOT NULL UNIQUE,
	      "local_chain_block_num"	INTEGER NOT NULL,
	      "local_chain_timestamp"	TEXT NOT NULL,
        "is_validated"	INTEGER NOT NULL,
	      PRIMARY KEY("id" AUTOINCREMENT)
      );''';
const queryOrderByDESC = ' DESC';
