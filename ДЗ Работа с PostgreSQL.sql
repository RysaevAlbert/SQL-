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
	duration integer NOT NULL,
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
	
