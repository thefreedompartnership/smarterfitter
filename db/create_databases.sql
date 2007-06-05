create database smarterfitter_development;
create database smarterfitter_test;
create database smarterfitter_production;
grant all on smarterfitter_development.* to 'tim'@'localhost';
grant all on smarterfitter_test.* to 'tim'@'localhost';
grant all on smarterfitter_production.* to 'tim'@'localhost';