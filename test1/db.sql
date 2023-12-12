DELETE a 
FROM
	crime_data AS a
	LEFT JOIN ( SELECT incident_id, max( start_date_time ) start_date_time, max( offence_code ) offence_code FROM crime_data GROUP BY incident_id ) b ON a.incident_id = b.incident_id 
	AND b.offence_code = a.offence_code 
WHERE
	b.offence_code IS NULL;
	
UPDATE crime_data 
SET dispatch_time = start_date_time 
WHERE
	dispatch_time IS NULL;
	
DELETE 
FROM
	crime_data 
WHERE
	incident_id IS NULL 
	OR offence_code IS NULL 
	OR dispatch_time IS NULL 
	OR victims IS NULL 
	OR crime_name1 IS NULL 
	OR crime_name2 IS NULL 
	OR crime_name3 IS NULL 
	OR city IS NULL 
	OR start_date_time IS NULL;

	
DELETE 
FROM
	crime_data 
WHERE
	YEAR ( start_date_time )< 2020;
UPDATE crime_data 
SET city = UPPER( city );

CREATE TABLE crimes (
	incident_id INT ( 11 ) PRIMARY KEY,
	offence_code INT ( 11 ),
	dispatch_time datetime,
	victims INT ( 11 ),
	city VARCHAR ( 255 ),
	start_date_time datetime 
);

CREATE TABLE offences ( 
	offence_code INT ( 11 ) PRIMARY KEY, 
	crime_name1 VARCHAR ( 255 ), 
	crime_name2 VARCHAR ( 255 ), 
	crime_name3 VARCHAR ( 255 ) 
);

INSERT INTO crimes ( incident_id, offence_code, dispatch_time, victims, city, start_date_time ) SELECT
incident_id,
offence_code,
dispatch_time,
victims,
city,
start_date_time 
FROM
	crime_data;
	
INSERT INTO offences ( offence_code, crime_name1, crime_name2, crime_name3 ) SELECT
DISTINCT(offence_code),
crime_name1,
crime_name2,
crime_name3 
FROM
	crime_data;