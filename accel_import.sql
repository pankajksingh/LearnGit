use test ;

create table accel(
T bigint, #Unix time (miliseconds since 1/1/1970)
X float,
Y float,
Z float,
Device smallint
);

#import data for training
LOAD DATA LOCAL INFILE 'C:/Tree/GitHub/Test/LearnGit/train.csv' 
INTO TABLE accel 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

select distinct device from accel;
-- Number of rows=
--  {7,8,9,12}

select count(*) from accel where device=7;
-- 523187 rows

#Test data
drop table acceltest;
create table acceltest(
T bigint, #Unix time (miliseconds since 1/1/1970)
X float,
Y float,
Z float,
SequenceId int
);


LOAD DATA LOCAL INFILE 'C:/Tree/GitHub/Test/LearnGit/test.csv' 
INTO TABLE acceltest 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
/* Number of rows 27007200 */

select distinct SequenceId from acceltest;
-- Number of ids=1000
-- {100006,100011,100012}

select count(*) from acceltest where sequenceid=100006;
-- 300

/*
(@T, X, Y,Z,Device)
set T =  DATE_ADD('1970-01-01 00:00:00',INTERVAL 1000*@T MICROSECOND);
*/


#query top rows
select * from accel LIMIT 1,2;

    

#time operations
SELECT FROM_UNIXTIME('1336645068531');
SELECT DATE_ADD('1970-01-01 00:00:00',INTERVAL 1336645068531000 MICROSECOND);




SELECT FROM_UNIXTIME(1196440219)