CREATE USER readonly IDENTIFIED BY 'test';
GRANT SELECT ON *.* TO readonly;
