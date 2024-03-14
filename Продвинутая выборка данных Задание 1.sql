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
	duration VARCHAR(40),
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

insert into track (track_id, "name", "duration", album_id) values (1, 'Uprising', '5:03', 1);
insert into track (track_id, "name", "duration", album_id) values (2, 'Resistance', '5:46', 1);
insert into track (track_id, "name", "duration", album_id) values (3, 'Rape Me', '2:50', 2);
insert into track (track_id, "name", "duration", album_id) values (4, 'Serve the Servants', '3:36', 2);
insert into track (track_id, "name", "duration", album_id) values (5, 'Mama', '3:56', 3);
insert into track (track_id, "name", "duration", album_id) values (6, 'Раз и навсегда', '3:36', 3);

insert into collections (collections_id , "name", year_release) values (1, 'New collections', '1/1/2011');
insert into collections (collections_id , "name", year_release) values (2, 'Old collections', '1/1/2012');
insert into collections (collections_id , "name", year_release) values (3, 'Best collections', '1/1/2013');
insert into collections (collections_id , "name", year_release) values (4, 'Rock collections', '1/1/2014');

insert into performers_genre  (artist_id, id_music_genre) values (1, 2);
insert into performers_genre  (artist_id, id_music_genre) values (2, 2);
insert into performers_genre  (artist_id, id_music_genre) values (3, 1);
insert into performers_genre  (artist_id, id_music_genre) values (4, 3);

insert into album_artist  (album_id , artist_id) values (1, 1);
insert into album_artist  (album_id , artist_id) values (2, 2);
insert into album_artist  (album_id , artist_id) values (3, 4);

insert into collections_track (collections_id  , track_id) values (1, 5);
insert into collections_track (collections_id  , track_id) values (2, 3);
insert into collections_track (collections_id  , track_id) values (4, 1);
