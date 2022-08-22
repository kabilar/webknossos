START TRANSACTION;

DROP VIEW webknossos.datastores_;
ALTER TABLE webknossos.datastores add isForeign BOOLEAN NOT NULL DEFAULT false;
UPDATE webknossos.datastores set isForeign = false;
CREATE VIEW webknossos.dataStores_ AS SELECT * FROM webknossos.dataStores WHERE NOT isDeleted;
UPDATE webknossos.releaseInformation set schemaVersion = 85;

COMMIT TRANSACTION;
