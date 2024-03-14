CREATE TABLE IF NOT EXISTS Artist (
	artist_id SERIAL PRIMARY KEY, 
	name VARCHAR(40) UNIQUE NOT NULL 
	);
	
CREATE TABLE IF NOT EXISTS Genre (
	genre_id SERIAL PRIMARY KEY, 
	name VARCHAR(40) UNIQUE NOT NULL 
	);

CREATE TABLE IF NOT EXISTS Performers_genre (
	artist_id integer REFERENCES Artist(artist_id),
	id_music_genre integer REFERENCES Genre(genre_id),
	CONSTRAINT cpk_PG1 PRIMARY KEY (artist_id, id_music_genre)
	);

CREATE TABLE IF NOT EXISTS Album (
	album_id SERIAL PRIMARY KEY, 
	name VARCHAR(40) NOT NULL,
	year_release DATE NOT NULL
	);

CREATE TABLE IF NOT EXISTS Album_artist (
	artist_id integer REFERENCES Artist(artist_id),
	album_id integer REFERENCES Album(album_id),
	CONSTRAINT cpk_AA PRIMARY KEY (artist_id, album_id)
	);

CREATE TABLE IF NOT EXISTS Track (
	track_id SERIAL PRIMARY KEY, 
	name VARCHAR(40) UNIQUE NOT NULL,
	duration NUMERIC(2),
	album_id integer REFERENCES Album(album_id)
	);

CREATE TABLE IF NOT EXISTS Collections (
	collections_id SERIAL PRIMARY KEY, 
	name VARCHAR(40) NOT NULL,
	year_release DATE NOT NULL
	);

CREATE TABLE IF NOT EXISTS Collections_track (
	collections_id integer REFERENCES Collections(collections_id),
	track_id integer REFERENCES Track (track_id),
	CONSTRAINT cpk_CT PRIMARY KEY (collections_id,track_id)
	);
	
insert into artist (artist_id, "name") values (1, 'Muse');
insert into artist (artist_id, "name") values (2, 'Nirvana');
insert into artist (artist_id, "name") values (3, 'NILETTO');
insert into artist (artist_id, "name") values (4, 'Basta');

insert into genre (genre_id , "name") values (1, 'Pop');
insert into genre (genre_id , "name") values (2, 'Rock');
insert into genre (genre_id , "name") values (3, 'Rapping');

insert into album (album_id , "name", year_release) values (1, 'The Resistance', '9/11/2011');
insert into album (album_id , "name", year_release) values (2, 'In Utero', '19/9/1993');
insert into album (album_id , "name", year_release) values (3, 'Basta 1', '1/11/2006');
insert into album (album_id , "name", year_release) values (4, 'Basta 5', '1/11/2020');

insert into track (track_id, "name", duration, album_id) values (1, 'Uprising', 5.2, 1)
ON CONFLICT ( track_id ) 
DO UPDATE SET
name=EXCLUDED.name,
duration =EXCLUDED.duration,
album_id =EXCLUDED.album_id;

insert into track (track_id, "name", duration, album_id) values (2, 'Resistance', 5.5, 1)
ON CONFLICT ( track_id ) 
DO UPDATE SET
name=EXCLUDED.name,
duration =EXCLUDED.duration,
album_id =EXCLUDED.album_id;

insert into track (track_id, "name", duration, album_id) values (3, 'Rape Me', 2.2, 2)
ON CONFLICT ( track_id ) 
DO UPDATE SET
name=EXCLUDED.name,
duration =EXCLUDED.duration,
album_id =EXCLUDED.album_id;

insert into track (track_id, "name", duration, album_id) values (4, 'Serve the Servants', 3.2, 2)
ON CONFLICT ( track_id ) 
DO UPDATE SET
name=EXCLUDED.name,
duration =EXCLUDED.duration,
album_id =EXCLUDED.album_id;

insert into track (track_id, "name", duration, album_id) values (5, 'MY Mama', 3.5, 3)
ON CONFLICT ( track_id ) 
DO UPDATE SET
name=EXCLUDED.name,
duration =EXCLUDED.duration,
album_id =EXCLUDED.album_id;

insert into track (track_id, "name", duration, album_id) values (6, 'Раз и навсегда', 4.5, 3)
ON CONFLICT ( track_id ) 
DO UPDATE SET
name=EXCLUDED.name,
duration =EXCLUDED.duration,
album_id =EXCLUDED.album_id;

insert into collections (collections_id , "name", year_release) values (1, 'New collections', '1/5/2011');
insert into collections (collections_id , "name", year_release) values (2, 'Old collections', '1/5/2012');
insert into collections (collections_id , "name", year_release) values (3, 'Best collections', '1/5/2013');
insert into collections (collections_id , "name", year_release) values (4, 'Rock collections', '1/5/2019');

delete from collections  
where collections_id = 4;

delete from collections_track 
where collections_id = 4;

insert into performers_genre  (artist_id, id_music_genre) values (1, 2);
insert into performers_genre  (artist_id, id_music_genre) values (2, 2);
insert into performers_genre  (artist_id, id_music_genre) values (3, 1);
insert into performers_genre  (artist_id, id_music_genre) values (4, 3);

insert into album_artist  (album_id , artist_id) values (1, 1);
insert into album_artist  (album_id , artist_id) values (2, 2);
insert into album_artist  (album_id , artist_id) values (3, 4);
insert into album_artist  (album_id , artist_id) values (4, 4);

insert into collections_track (collections_id  , track_id) values (1, 5);
insert into collections_track (collections_id  , track_id) values (2, 3);
insert into collections_track (collections_id  , track_id) values (4, 1);

--Задание 2 Пункт 1
SELECT name, duration FROM track  
where duration = (select max(duration) from track)

--Задание 2 Пункт 2
SELECT name, duration FROM track t 
WHERE  duration >= 3.5

--Задание 2 Пункт 3
SELECT name, year_release FROM collections
WHERE  year_release > '1/1/2018' and year_release < '31/12/2020'

--Задание 2 Пункт 4
SELECT name FROM artist a 
WHERE a."name"  NOT LIKE '% %';

--Задание 2 Пункт 5
SELECT name FROM track t 
WHERE  t."name" like '%MY%'

--Задание 3 Пункт 1
SELECT g.name, COUNT(genre_id) FROM performers_genre pg 
LEFT JOIN genre g ON g.genre_id  = pg.id_music_genre 
GROUP BY g.name;

--Задание 3 Пункт 2
SELECT a.name, COUNT(t2.album_id) FROM track t2  
LEFT JOIN album a ON a.album_id  = t2.album_id 
WHERE  a.year_release > '1/1/2010' and year_release < '31/12/2012'
GROUP BY a.name;

--Задание 3 Пункт 3
SELECT a.name, avg(t2.duration) FROM track t2  
LEFT JOIN album a ON a.album_id  = t2.album_id 
GROUP BY a.name;

--Задание 3 Пункт 4 
SELECT distinct a.name FROM artist a
where a."name" not in (
	select distinct a."name" from artist a 
	left JOIN album_artist aa ON a.artist_id  = aa.artist_id
	left JOIN album a2 ON a2.album_id  = aa.album_id
	where extract(year from a2.year_release) = 2020
	)
GROUP BY a.name;

--Задание 3 Пункт 5 
SELECT collections."name"  FROM collections
LEFT JOIN collections_track ON collections.collections_id  = collections_track.collections_id 
LEFT JOIN track ON collections_track.track_id = track.track_id 
LEFT JOIN album ON track.album_id = album.album_id 
LEFT JOIN album_artist ON album.album_id  = album_artist.album_id
LEFT JOIN artist ON album_artist.artist_id = artist.artist_id 
WHERE artist.name = 'Muse'
GROUP BY collections."name";