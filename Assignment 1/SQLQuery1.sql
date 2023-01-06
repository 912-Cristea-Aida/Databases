CREATE TABLE Agent(
	id_agent INT PRIMARY KEY,
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	country_name VARCHAR(100)
)


CREATE TABLE Customer(
	id_customer INT PRIMARY KEY,
	customer_name VARCHAR(100),
	c_id_agent INT REFERENCES Agent(id_agent),
	country_name VARCHAR(100)
)


CREATE TABLE Country(
	id_country INT PRIMARY KEY,
	country_name VARCHAR(100)
)


CREATE TABLE City(
	id_city INT PRIMARY KEY,
	city_name VARCHAR(100),
	city_country_id INT REFERENCES Country(id_country)
)


CREATE TABLE Transport(
	id_transport INT PRIMARY KEY,
	transport_name VARCHAR(100),
	transport_city_id INT REFERENCES City(id_city)
)


CREATE TABLE Hotel(
	id_hotel INT PRIMARY KEY,
	price INT,
	stars INT,
	hotel_name VARCHAR(100),
	hotel_city_id INT REFERENCES City(id_city),
	CHECK(stars > 0)
)



CREATE TABLE Rooms(
	id_room INT PRIMARY KEY,
	name_room VARCHAR(50)
)


CREATE TABLE TypeOfRoom(
	id_hotel INT NOT NULL,
	id_room INT NOT NULL,
	FOREIGN KEY (id_hotel) REFERENCES Hotel(id_hotel),
	FOREIGN KEY (id_room) REFERENCES Rooms(id_room),
	UNIQUE(id_hotel, id_room)
)


CREATE TABLE ActivityList(
	id_activity INT PRIMARY KEY,
	name_activity VARCHAR(100)
)



CREATE TABLE Activity(
	hotel_id INT NOT NULL,
	activity_id INT NOT NULL,
	FOREIGN KEY (hotel_id) REFERENCES Hotel(id_hotel),
	FOREIGN KEY (activity_id) REFERENCES ActivityList(id_activity),
	PRIMARY KEY(hotel_id, activity_id)
)