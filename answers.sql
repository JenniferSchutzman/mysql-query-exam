/*
1) Select a distinct list of ordered airports codes.
Airports
ATL
CLT
DEN
LAX
SFO
*/
SELECT departAirport AS Airports FROM flight GROUP BY departAirport;
/*
2)  Provide a list of delayed flights departing from San Francisco (SFO).
name	flightNumber	scheduledDepartDateTime	arriveAirport	status
Delta	999				2017-10-25 12:00:00		LAX				delayed
Delta	234				2017-10-25 	12:30:00
*/
SELECT airline.name, flight.flightNumber, flight.scheduledDepartDateTime, 
flight.arriveAirport, flight.status
FROM airline
INNER JOIN flight
ON airline.ID=flight.airlineID
WHERE flight.departAirport='SFO'
AND flight.status='delayed';
/*
3)  Provide a distinct list of cities that American airlines departs from.
Cities
ATL
DEN
LAX
*/
SELECT DISTINCT flight.departAirport AS Cities 
FROM flight
INNER JOIN airline
on airline.ID=flight.airlineID
WHERE airline.name="American";
/*
4)  Provide a distinct list of airlines that conducts flights departing from ATL.
Airline
American
Delta
*/
SELECT DISTINCT airline.name AS Airline
FROM airline
INNER JOIN flight 
ON airline.ID=flight.airlineID
WHERE flight.departAirport='ATL';
/*
5) Provide a list of airlines, 
flight numbers, departing airports, and arrival airports where flights departed on time.
Hint: The scheduled and actual depart date times can be used to determine if a flight is on time.
*/
SELECT airline.name, flight.flightNumber, flight.departAirport, flight.arriveAirport
FROM airline
INNER JOIN flight
ON airline.ID=flight.airlineID
WHERE flight.scheduledDepartDateTime=flight.actualDepartDateTime;
/*
6)  Provide a list of airlines, flight numbers, gates, status, and arrival times arriving 
into Charlotte (CLT) on 10-30-2017. Order your results by the arrival time.
Airline	Flight	Gate	Arrival	Status
American	1021	B5	10:15:00	scheduled
American	1021	B12	12:15:00	scheduled
American	1021	B13	14:15:00	scheduled
*/
SELECT airline.name AS Airline, flight.flightNumber AS Flight, 
flight.gate AS Gate, TIME(flight.scheduledArriveDateTime) AS Arrival,
flight.status AS Status
FROM airline
INNER JOIN flight 
ON airline.ID=flight.airlineID
WHERE flight.arriveAirport='CLT' AND airline.name='American';
/*
7) List the number of reservations by flight number. Order by reservations in descending order.
flight	reservations
flight	reservations
654		15
3333	7
1021	5
1033	5
3242	3
3456	1
*/
SELECT flight.flightNumber AS flight, COUNT(reservation.ID) AS reservations
FROM flight
INNER JOIN reservation
ON flight.ID=reservation.flightID
GROUP BY flight.flightNumber
ORDER BY reservations desc;
/*
8)List the average ticket cost for coach by airline and route. 
Order by AverageCost in descending order.

airline	departAirport	arriveAirport	AverageCost
Delta	ATL				LAX				375.000000
Delta	DEN				SFO				372.500000
American	LAX			DEN				366.750000
American	ATL			CLT				262.500000
American	DEN			ATL				258.666667
*/ 
SELECT airline.name AS airline, flight.departAirport, flight.arriveAirport, AVG(reservation.cost) AS AverageCost
FROM airline
INNER JOIN flight
ON airline.ID=flight.airlineID
JOIN reservation
ON flight.ID=reservation.flightID
WHERE reservation.class='coach'
GROUP BY reservation.flightID
ORDER BY AverageCost desc;
/*
9)Which route is the longest?

departAirport	arriveAirport	miles
SFO	CLT	2290
*/
SELECT departAirport, arriveAirport, miles
FROM flight
WHERE miles=(SELECT MAX(miles) FROM flight);
/*
10)List the top 5 passengers that have flown the most miles. Order by miles.

firstName	lastName	miles
Mick	Jagger	3470
George	Harrison	3077
Neil	Young	2800
Peter	Buck	2800
Joe	Strummer	1477
*/
SELECT passenger.firstName, passenger.lastName, SUM(flight.miles) AS miles
FROM flight 
INNER JOIN reservation 
ON flight.ID=reservation.flightID 
JOIN passenger 
ON reservation.passengerID=passenger.ID 
GROUP BY passenger.ID
ORDER BY miles desc
Limit 5;
/*
11)  Provide a list of American airline flights ordered by 
route and arrival date and time. 

Hint: String and Date Functions

Name	Route			Arrive Date	Arrive Time
American	ATL --> CLT	2017-10-30	10:15:00
American	ATL --> CLT	2017-10-30	12:15:00
American	ATL --> CLT	2017-10-30	14:15:00
American	DEN --> ATL	2017-10-01	13:30:00
American	DEN --> ATL	2017-10-30	09:30:00
American	DEN --> ATL	2017-10-30	13:30:00
American	LAX --> DEN	2017-10-25	14:30:00
American	LAX --> STL	2017-10-03	14:00:00
*/
SELECT airline.name AS Name,CONCAT(flight.departAirport," --> ",flight.arriveAirport) AS Route, 
DATE(flight.scheduledArriveDateTime) AS 'Arrive Date',
TIME(flight.scheduledArriveDateTime) AS 'Arrive Time'
FROM airline
INNER JOIN flight
ON airline.ID=flight.airlineID
WHERE airline.name='American'
ORDER BY Route, flight.scheduledArriveDateTime;
/*
12)Provide a report that counts the number of reservations and totals the reservation 
costs (as Revenue) by Airline, flight, and route. Order the report by total revenue in 
descending order.

Airline	Flight	Route		Reservation Count	Revenue
American 654	DEN --> ATL	15				11334.99
American 3333	LAX --> DEN	7				4541.00
American 1021	ATL --> CLT	5				4275.01
Delta	1033	DEN --> SFO	5				3133.00
Delta	3242	ATL --> LAX	3				1560.00
United	3456	CLT --> CHS	1				599.00
*/
SELECT airline.name AS Airline, flight.flightNumber AS Flight, 
CONCAT(flight.departAirport," --> ",flight.arriveAirport) AS Route,
COUNT(reservation.ID) AS 'Reservation Count', 
SUM(reservation.cost) AS Revenue 
FROM airline
INNER JOIN flight
ON airline.ID=flight.airlineID
Join reservation 
ON flight.ID=reservation.flightID 
GROUP BY flight.ID
ORDER BY Revenue DESC;

/*
13) List the average cost per reservation by route. Round results down to the dollar.

Route	Avg Revenue
ATL --> CLT	855
DEN --> ATL	755
LAX --> DEN	648
DEN --> SFO	626
CLT --> CHS	599
ATL --> LAX	520
*/
 
SELECT CONCAT(flight.departAirport," --> ",flight.arriveAirport) AS Route, 
ROUND(AVG(reservation.cost)) AS 'Avg Revenue'
FROM flight
INNER JOIN reservation
ON flight.ID=reservation.flightID
GROUP BY Route
ORDER BY 'Avg Revenue' DESC;


/*
14) List the average miles per flight by airline.
Airline	Avg Miles Per Flight
American	860.1250
Delta	1139.3333
United	336.5000
*/ 
SELECT airline.name AS Airline, AVG(flight.miles) AS ' Avg Miles Per Flight' 
FROM airline
INNER JOIN flight
ON airline.ID=flight.airlineID
GROUP BY airline.name;

/*
15)Which airlines had flights that arrived early?

Airline:
Delta

*/
SELECT airline.name 
FROM airline
INNER JOIN flight
ON airline.ID=flight.airlineID
WHERE flight.scheduledArriveDateTime > flight.actualArriveDateTime
GROUP BY airline.name;
































