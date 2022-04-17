const nameDB = 'vaxpass.db';
const nameUserTable = 'user$dbVersion';
const nameCertificateTable = 'certificate$dbVersion';
const nameSQLiteSequenceTable = 'sqlite_sequence';
const notRemoveTableNames = <String>[
  nameUserTable,
  nameCertificateTable,
  nameSQLiteSequenceTable
];
const dbVersion = 3;

const queryCreateUserTable = '''CREATE TABLE IF NOT EXISTS "$nameUserTable" (
        "id"	INTEGER NOT NULL UNIQUE,
	      "system_id"	TEXT NOT NULL UNIQUE,
	      "name"	TEXT NOT NULL,
	      "country_code"	TEXT NOT NULL,
        "document_type"	INTEGER NOT NULL,
	      "country_id"	TEXT NOT NULL,
	      "gender"	INTEGER NOT NULL,
	      "date_of_birth"	TEXT NOT NULL,
	      "email"	TEXT NOT NULL UNIQUE,
	      PRIMARY KEY("id")
      );''';
const queryCreateCertificateTable =
    '''CREATE TABLE IF NOT EXISTS "$nameCertificateTable" (
        "id"	INTEGER NOT NULL UNIQUE,
	      "cert_id"	TEXT NOT NULL UNIQUE,
	      "person_id"	TEXT NOT NULL,
	      "name"	TEXT NOT NULL,
	      "brand"	TEXT NOT NULL,
	      "num_dose"	INTEGER,
	      "issue_time"	TEXT NOT NULL,
	      "issuer"	TEXT NOT NULL,
	      "remark"	TEXT,
	      "global_chain_tx_hash"	TEXT,
	      "global_chain_block_num"	INTEGER,
	      "global_chain_timestamp"	TEXT,
	      "local_chain_id"	TEXT NOT NULL,
	      "local_chain_tx_hash"	TEXT NOT NULL,
	      "local_chain_block_num"	INTEGER NOT NULL,
	      "local_chain_timestamp"	TEXT NOT NULL,
        "is_validated"	INTEGER NOT NULL,
        "merkle_tree_path" TEXT NOT NULL,
        "merkle_tree_indexes" TEXT NOT NULL,
        "global_root_id" TEXT NOT NULL,
	      PRIMARY KEY("id" AUTOINCREMENT)
      );''';
const queryAllTableNames =
    '''SELECT name FROM sqlite_master WHERE type = "table"''';
const queryDropTableByName = 'DROP TABLE IF EXISTS ';

const queryOrderByDESC = ' DESC';
