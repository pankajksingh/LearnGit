use test ;

create table accel(
T bigint, #Unix time (miliseconds since 1/1/1970)
X float,
Y float,
Z float,
Device smallint
);


LOAD DATA LOCAL INFILE 'C:/Tree/GitHub/Test/LearnGit/train.csv' 
INTO TABLE accel 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

/*
(@T, X, Y,Z,Device)
set T =  DATE_ADD('1970-01-01 00:00:00',INTERVAL 1000*@T MICROSECOND);
*/

select * from accel LIMIT 1,2;

SELECT FROM_UNIXTIME('1336645068531');
SELECT DATE_ADD('1970-01-01 00:00:00',INTERVAL 1336645068531000 MICROSECOND);




SELECT FROM_UNIXTIME(1196440219)