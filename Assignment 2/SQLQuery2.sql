INSERT INTO Agent(id_agent, first_name, last_name) VALUES (1, 'Michael', 'Pop', 'Romania')
INSERT INTO Agent(id_agent, first_name, last_name) VALUES (2, 'Simona', 'A', 'France')
INSERT INTO Agent(id_agent, first_name, last_name) VALUES (3, 'Andrew', 'Si', 'Italy')
INSERT INTO Agent(id_agent, first_name, last_name) VALUES (4, 'Mary', 'Ba', 'Spain')
INSERT INTO Agent(id_agent, first_name, last_name) VALUES (5, 'Anna', 'Taylor', 'Romania')
INSERT INTO Agent(id_agent, first_name, last_name) VALUES (6, 'Mary', 'Lamb', 'France')
INSERT INTO Agent(id_agent, first_name, last_name) VALUES (7, 'Andrew', 'Michael', 'Poland')

INSERT INTO Customer(id_customer,customer_name, c_id_agent) VALUES (1, 'Mary Lu', 1)
INSERT INTO Customer(id_customer, customer_name, c_id_agent) VALUES (2, 'Bru Bet', 2)
INSERT INTO Customer(id_customer, customer_name, c_id_agent) VALUES(3,'Margrett Abi', 1)
INSERT INTO Customer(id_customer, customer_name, c_id_agent) VALUES (4, 'Luna Bil', 3)
INSERT INTO Customer(id_customer, customer_name, c_id_agent) VALUES (5, 'Mark Ti', 3)
INSERT INTO Customer(id_customer, customer_name, c_id_agent) VALUES (6, 'Sony Miss', 4)
INSERT INTO Customer(id_customer, customer_name) VALUES (7, 'Sarah Lee')


/*
Delete customers who have the name starting with m
*/
DELETE FROM Customer
WHERE customer_name LIKE '%m';


SELECT* FROM Agent;

UPDATE Agent SET country_name='Romania'
WHERE id_agent=1;

UPDATE Agent SET country_name='France'
WHERE id_agent=2;

UPDATE Agent SET country_name='Italy'
WHERE id_agent=3;

UPDATE Agent SET country_name='Spain'
WHERE id_agent=4;

UPDATE Agent SET country_name='Romania'
WHERE id_agent=5;


UPDATE Agent SET country_name='France'
WHERE id_agent=6;

UPDATE Agent SET country_name='Poland'
WHERE id_agent=7;

SELECT*FROM Customer;

UPDATE Customer SET country_name='Romania'
WHERE id_customer=1;

UPDATE Customer SET country_name='France'
WHERE id_customer=2;

UPDATE Customer SET country_name='France'
WHERE id_customer=3;

UPDATE Customer SET country_name='Spain'
WHERE id_customer=4;

UPDATE Customer SET country_name='Italy'
WHERE id_customer=5;

UPDATE Customer SET country_name='Spain'
WHERE id_customer=6;


INSERT INTO Country(id_country, country_name) VALUES (1, 'France')
INSERT INTO Country(id_country, country_name) VALUES (2, 'Romania')
INSERT INTO Country(id_country, country_name) VALUES (3, 'Spain')
INSERT INTO Country(id_country, country_name) VALUES (4, 'Belgium')
INSERT INTO Country(id_country, country_name) VALUES (5, 'Italy')
INSERT INTO Country(id_country, country_name) VALUES (5, 'Finland')

SELECT* FROM Country;


INSERT INTO City(id_city, city_name, city_country_id) VALUES (1, 'Paris', 1)
INSERT INTO City(id_city, city_name, city_country_id) VALUES (2, 'Cluj-Napoca', 2)
INSERT INTO City(id_city, city_name, city_country_id) VALUES (3, 'Monza', 5)
INSERT INTO City(id_city, city_name, city_country_id) VALUES (4, 'Brussels', 4)
INSERT INTO City(id_city, city_name, city_country_id) VALUES (5, 'Barcelona', 3)
INSERT INTO City(id_city, city_name, city_country_id) VALUES (6, 'Brasov', 2)
INSERT INTO City(id_city, city_name, city_country_id) VALUES (7, 'Lyon', 1)
INSERT INTO City(id_city, city_name, city_country_id) VALUES (8, 'Madrid', 3)

SELECT* FROM City;


INSERT INTO Transport(id_transport, transport_name, transport_city_id) VALUES (1, 'ParisTravel', 1)
INSERT INTO Transport(id_transport, transport_name, transport_city_id) VALUES (2, 'CTP', 2)
INSERT INTO Transport(id_transport, transport_name, transport_city_id) VALUES (3, 'BrusselsVisit', 4)
INSERT INTO Transport(id_transport, transport_name, transport_city_id) VALUES (4, 'SeeLyon', 7)
INSERT INTO Transport(id_transport, transport_name, transport_city_id) VALUES (5, 'BCNGo', 5)

SELECT* FROM Transport;

UPDATE Transport SET transport_name='BarcelonaGo'
WHERE transport_city_id=5 OR id_transport=3;



INSERT INTO Hotel(id_hotel, price, stars, hotel_name, hotel_city_id) VALUES (1, 150, 3, 'Payris Opera', 1)
INSERT INTO Hotel(id_hotel, price, stars, hotel_name, hotel_city_id) VALUES (2, 700, 5, 'Hilton', 1)
INSERT INTO Hotel(id_hotel, price, stars, hotel_name, hotel_city_id) VALUES (3, 100, 2, 'Hotel City Center', 4)
INSERT INTO Hotel(id_hotel, price, stars, hotel_name, hotel_city_id) VALUES (4, 200, 3, 'Termal', 6)
INSERT INTO Hotel(id_hotel, price, stars, hotel_name, hotel_city_id) VALUES (5, 400, 4, 'Ramada', 2)
INSERT INTO Hotel(id_hotel, price, stars, hotel_name, hotel_city_id) VALUES (6, 70, 1, 'SafeStay', 4)
INSERT INTO Hotel(id_hotel, price, stars, hotel_name, hotel_city_id) VALUES (7, 500, 4, 'Hotel de Normandie', 7)
INSERT INTO Hotel(id_hotel, price, stars, hotel_name, hotel_city_id) VALUES (8, 450, 4, 'Cosmo Hotel', 3)
INSERT INTO Hotel(id_hotel, price, stars, hotel_name, hotel_city_id) VALUES (9, 250, 3, 'Leonardo', 5)


SELECT * FROM Hotel;

DELETE FROM Hotel
WHERE Hotel.id_hotel BETWEEN 4 AND 7;

DELETE FROM Hotel 
WHERE Hotel.hotel_city_id=4 AND Hotel.hotel_name='Termal';


DELETE FROM Hotel
WHERE Hotel.id_hotel=2;


INSERT INTO Rooms(id_room, name_room) VALUES (1, 'Single')
INSERT INTO Rooms(id_room, name_room) VALUES (2, 'Duplex')
INSERT INTO Rooms(id_room, name_room) VALUES (3, 'Triple')
INSERT INTO Rooms(id_room, name_room) VALUES (4, 'Family')

DELETE FROM Rooms
WHERE Rooms.id_room IN (1,3);


SELECT * FROM Rooms;

INSERT INTO TypeOfRoom(id_hotel, id_room) VALUES (1, 1)
INSERT INTO TypeOfRoom(id_hotel, id_room) VALUES (1, 2)
INSERT INTO TypeOfRoom(id_hotel, id_room) VALUES (1, 3)
INSERT INTO TypeOfRoom(id_hotel, id_room) VALUES (4, 1)
INSERT INTO TypeOfRoom(id_hotel, id_room) VALUES (4, 2)
INSERT INTO TypeOfRoom(id_hotel, id_room) VALUES (4, 3)
INSERT INTO TypeOfRoom(id_hotel, id_room) VALUES (4, 4)
INSERT INTO TypeOfRoom(id_hotel, id_room) VALUES (9, 1)
INSERT INTO TypeOfRoom(id_hotel, id_room) VALUES (9, 2)
INSERT INTO TypeOfRoom(id_hotel, id_room) VALUES (2, 2)
INSERT INTO TypeOfRoom(id_hotel, id_room) VALUES (6, 4)
INSERT INTO TypeOfRoom(id_hotel, id_room) VALUES (7, 3)
INSERT INTO TypeOfRoom(id_hotel, id_room) VALUES (3, 1)
INSERT INTO TypeOfRoom(id_hotel, id_room) VALUES (3, 2)
INSERT INTO TypeOfRoom(id_hotel, id_room) VALUES (5, 2)
INSERT INTO TypeOfRoom(id_hotel, id_room) VALUES (8, 2)

SELECT * FROM TypeOfRoom;

DELETE FROM TypeOfRoom
WHERE TypeOfRoom.id_hotel=4;


INSERT INTO ActivityList(id_activity, name_activity) VALUES (1, 'Ski')
INSERT INTO ActivityList(id_activity, name_activity) VALUES (2, 'Volleyball')
INSERT INTO ActivityList(id_activity, name_activity) VALUES (3, 'Basketball')
INSERT INTO ActivityList(id_activity, name_activity) VALUES (4, 'Swimming')
INSERT INTO ActivityList(id_activity, name_activity) VALUES (5, 'Cycling')

SELECT * FROM ActivityList;


INSERT INTO Activity(hotel_id, activity_id) VALUES (7, 1)
INSERT INTO Activity(hotel_id, activity_id) VALUES (5, 4)
INSERT INTO Activity(hotel_id, activity_id) VALUES (4, 3)
INSERT INTO Activity(hotel_id, activity_id) VALUES (2, 2)
INSERT INTO Activity(hotel_id, activity_id) VALUES (2, 4)
INSERT INTO Activity(hotel_id, activity_id) VALUES (5, 5)

SELECT* FROM Activity;




/*
Show only the first 3 hotels ordered by price
*/
SELECT TOP 3*
FROM Hotel
ORDER BY Hotel.price ASC;


/*
Return the distinct country names form both Agent and Customers (union)
*/
SELECT country_name FROM Agent 
UNION 
SELECT country_name FROM Customer;


/*
Show all hotels where the price<100 or it has 2 stars and show the price for 3 nights(or) 
*/
SELECT H.hotel_name, H.price *3 AS PriceFor3Nights
FROM Hotel H
WHERE H.price<100 OR H.stars=2;


/*
Show id_city where in table City the id_city is >= 4 and in Table Hotel the hotel_city_id<7 (intersect)
*/
SELECT id_city
FROM City
WHERE id_city>=4
INTERSECT
SELECT hotel_city_id
FROM Hotel
WHERE hotel_city_id<7;

SELECT * FROM City;
SELECT * FROM Hotel;



/*
Show the id of the cities that have transport (intersect)
*/
SELECT id_city
FROM City
INTERSECT
SELECT transport_city_id
FROM Transport

SELECT * FROM City;
SELECT * FROM Transport;


/*
Show all agents that have the first name "Mary" and "Andrew" (in)
*/
SELECT *
FROM Agent
WHERE first_name IN ('Mary', 'Andrew')
ORDER BY first_name;


/*
Show all cities that don't have a transportation (except)
*/
SELECT id_city
FROM City
EXCEPT
SELECT transport_city_id
FROM Transport

SELECT * FROM City;
SELECT * FROM Transport;


/*
Show all agents that don't have the first name "Mary", "Andrew" (not in)
*/
SELECT *
FROM Agent
WHERE first_name NOT IN ('Mary', 'Andrew')
ORDER BY last_name;


/*
Show (first 4 agents) that have customers associeted to them; show null to the agents that don't have customers (right join)
*/
SELECT TOP 4*
FROM Agent RIGHT JOIN Customer ON c_id_agent=id_agent;

SELECT * FROM Agent;
SELECT * FROM Customer;


/*
Show distinct cities that have hotels that have activities (left join 3 tables)
*/
/*
SELECT City.city_name, Hotel.id_hotel, Activity.activity_id
FROM ((Hotel
	    LEFT JOIN City ON Hotel.hotel_city_id=City.id_city)
		LEFT JOIN Activity ON Hotel.id_hotel=Activity.hotel_id)
ORDER BY activity_id;*/


SELECT DISTINCT City.city_name
FROM ((Hotel
	    LEFT JOIN City ON Hotel.hotel_city_id=City.id_city)
		LEFT JOIN Activity ON Hotel.id_hotel=Activity.hotel_id)
--ORDER BY activity_id;


SELECT * FROM City;
SELECT * FROM Hotel;
SELECT * FROM Activity;


/*
Show cities that have hotels that have double rooms, and that have activities
*/
SELECT City.city_name, Hotel.hotel_name, TypeOfRoom.id_room, Activity.activity_id, Hotel.price+20 AS PriceHotelWithTVA
FROM (((City
		INNER JOIN Hotel ON City.id_city = Hotel.hotel_city_id)
		INNER JOIN TypeOfRoom ON Hotel.id_hotel=TypeOfRoom.id_hotel
		AND TypeOfRoom.id_room=2)
		INNER JOIN Activity ON Hotel.id_hotel=Activity.hotel_id);

SELECT * FROM City;
SELECT * FROM Hotel;
SELECT * FROM TypeOfRoom;
SELECT * FROM Activity;


/*
Show hotels that have double rooms and that have activities with their name
*/

SELECT Hotel.hotel_name, TypeOfRoom.id_room, ActivityList.name_activity
FROM (((Hotel
		INNER JOIN TypeOfRoom ON Hotel.id_hotel=TypeOfRoom.id_hotel
		AND TypeOfRoom.id_room=2)
		INNER JOIN Activity ON Hotel.id_hotel=Activity.hotel_id)
		INNER JOIN ActivityList ON Activity.activity_id = ActivityList.id_activity);

SELECT * FROM Hotel;
SELECT * FROM TypeOfRoom;
SELECT * FROM Activity;
SELECT * FROM ActivityList;



/*
Show hotels that have rooms of 2, and swimming activity (inner join 2 many-yo-many)
*/
SELECT Hotel.hotel_name, Rooms.name_room, ActivityList.name_activity, Hotel.price * 7 AS PriceFor7Nights
FROM ((((Hotel
		INNER JOIN TypeOfRoom ON Hotel.id_hotel=TypeOfRoom.id_hotel)
		INNER JOIN Rooms ON TypeOfRoom.id_room=Rooms.id_room AND Rooms.id_room=2)
		INNER JOIN Activity ON Hotel.id_hotel=Activity.hotel_id)
		INNER JOIN ActivityList ON Activity.activity_id=ActivityList.id_activity AND
		ActivityList.name_activity='Swimming');

SELECT * FROM Hotel;
SELECT * FROM TypeOfRoom;
SELECT * FROM Rooms;
SELECT * FROM Activity;
SELECT * FROM ActivityList;


/*
Show cities from a given country with their transportation (full join)
*/
SELECT DISTINCT City.city_name, Transport.id_transport
FROM City
FULL JOIN Transport ON City.id_city = Transport.transport_city_id
WHERE city_country_id=2;

SELECT * FROM City;
SELECT * FROM Transport;


/*
Show hotels that have single rooms
*/
SELECT*
FROM Hotel
WHERE Hotel.id_hotel IN (
						SELECT TypeOfRoom.id_hotel
						FROM TypeOfRoom
						WHERE TypeOfRoom.id_room IN (
													SELECT Rooms.id_room
													FROM Rooms
													WHERE Rooms.id_room=1));



/*
Show all the cities from Spain 
*/
SELECT *
FROM City
WHERE City.city_country_id IN (
							SELECT Country.id_country
							FROM Country
							WHERE Country.country_name='Spain');


/*
Show DISTINCT cities where the price of the hotel %30 equals to 0 (exists)
*/
SELECT DISTINCT City.city_name
FROM City
WHERE EXISTS ( SELECT Hotel.hotel_name 
			   FROM Hotel
			   WHERE City.id_city = Hotel.hotel_city_id AND Hotel.price%30=0);

SELECT * FROM City;
SELECT * FROM Hotel;


/*
Show Customers that have as agent a person who has the first name 'Michael'
*/
SELECT Customer.customer_name
FROM Customer
WHERE EXISTS ( SELECT Agent.first_name
			   FROM Agent
				WHERE Agent.id_agent=Customer.c_id_agent AND Agent.first_name='Michael')
ORDER BY Customer.customer_name;

SELECT * FROM Customer;
SELECT * FROM Agent;


/*
Show cities that have hotels with price > 300
*/
SELECT C.*
FROM City C INNER JOIN
	( SELECT *
	FROM Hotel H
	WHERE H.price>300) t
ON C.id_city=t.hotel_city_id

SELECT * FROM City;
SELECT * FROM Hotel;



/*
Show customers that have as agent a person with the first name Andrew
*/
SELECT C.*
FROM 
	( SELECT *
	FROM Agent A
	WHERE A.first_name='Andrew') t, Customer C
WHERE C.c_id_agent=t.id_agent

SELECT * FROM Agent;
SELECT * FROM Customer;


/*
Show the number of customers per country
*/
SELECT COUNT(Customer.id_customer) AS CustomersPerCountry, Customer.country_name
FROM Customer
GROUP BY Customer.country_name

SELECT * FROM Customer;


/*
Show countries that have more than 1 agents
*/
SELECT COUNT(Agent.id_agent) AS AgentPerCountry, Agent.country_name
FROM Agent
GROUP BY Agent.country_name
HAVING COUNT(Agent.id_agent) >1


/*
Show the sum of the prices of the hotels that have the numbers of stars greater than the minimum number of stars from hotels from Paris, grouped by the number of stars
*/
SELECT SUM(Hotel.price) SumPrice, Hotel.stars
FROM Hotel
GROUP BY Hotel.stars
HAVING Hotel.stars>(SELECT MIN(H1.stars)
					FROM Hotel H1
					WHERE H1.hotel_city_id=1);

SELECT * FROM Hotel;



/*
Show number of hotels, grouped by the type of rooms, where the number of hotels is > than the number of hotels with the price <200
*/
SELECT COUNT(TypeOfRoom.id_hotel)NrOfHotels, TypeOfRoom.id_room
FROM TypeOfRoom
GROUP BY TypeOfRoom.id_room
HAVING COUNT(TypeOfRoom.id_hotel)>(SELECT COUNT(id_hotel)
									FROM Hotel
									WHERE Hotel.price<200);

SELECT * FROM Hotel;


/*
Show customers that have as an agent a person from Romania
*/
SELECT Customer.customer_name
FROM Customer
WHERE Customer.c_id_agent = ANY 
		(SELECT id_agent
		 FROM Agent
		 WHERE Agent.country_name='Romania');

SELECT * FROM Customer;
SELECT * FROM Agent;


/*
Show customers that have as an agent a person from Romania
*/
SELECT Customer.customer_name
FROM Customer
WHERE Customer.c_id_agent IN
		(SELECT id_agent
		 FROM Agent
		 WHERE Agent.country_name='Romania');

SELECT * FROM Customer;
SELECT * FROM Agent;

/*
Show hotels at which the price for 3 nights is <1200
*/
SELECT Hotel.hotel_name
FROM Hotel
WHERE Hotel.id_hotel = ANY
		( SELECT id_hotel
		  FROM Hotel H1
		  WHERE H1.price*3 < 1200);
SELECT * FROM Hotel;


/*
Show the hotels that has maximum price of a hotel where price*3<1200
*/

SELECT *
FROM Hotel
WHERE Hotel.price =
	(SELECT MAX(H1.price)
	 FROM Hotel H1
	 WHERE H1.price*3<1200);



/*
SELECT MAX(Hotel.price)
FROM Hotel
WHERE Hotel.id_hotel = ANY
		( SELECT id_hotel
		  FROM Hotel H1
		  WHERE H1.price*3 < 1200);
SELECT * FROM Hotel;*/


/*
Count how many hotels have the price*3<1200
*/
SELECT COUNT(Hotel.hotel_name)
FROM Hotel
WHERE Hotel.id_hotel = ANY
		( SELECT id_hotel
		  FROM Hotel H1
		  WHERE H1.price*3 < 1200);
SELECT * FROM Hotel;

/*
The ALL command returns true if all of the subquery values meet the condition.
Show hotels that have only 1 star
*/
SELECT Hotel.hotel_name
FROM Hotel
WHERE Hotel.id_hotel = ALL
		(SELECT id_hotel	
		 FROM Hotel H1
		 WHERE H1.stars =1);


/*
Show the hotel that has the maximum id and has only 1 star
*/
SELECT Hotel.hotel_name
FROM Hotel
WHERE Hotel.id_hotel =
	(SELECT MAX(id_hotel)
	 FROM Hotel H1
	 WHERE H1.stars=1);



/*
Show all activity names from the hotel with id 4
*/
SELECT name_activity
FROM ActivityList
WHERE id_activity=ALL
	(SELECT activity_id
	 FROM Activity
	 WHERE hotel_id=4);


SELECT * FROM ActivityList;
SELECT * FROM Activity;
SELECT * FROM Hotel;

/*
Show all activities that hotel with id 2 doesn't have
*/
SELECT name_activity
FROM ActivityList
WHERE id_activity NOT IN
	(SELECT activity_id
	 FROM Activity
	 WHERE hotel_id=2);

