/*
1) Select a distinct list of ordered airports codes.
*/
SELECT departAirport AS Airports FROM flight GROUP BY departAirport;
/*
2)  Provide a list of delayed flights departing from San Francisco (SFO).
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
*/
SELECT DISTINCT flight.departAirport AS Cities 
FROM flight
INNER JOIN airline
on airline.ID=flight.airlineID
WHERE airline.name="American";
/*
4)  Provide a distinct list of airlines that conducts flights departing from ATL.
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
*/
SELECT departAirport, arriveAirport, miles
FROM flight
WHERE miles=(SELECT MAX(miles) FROM flight);
/*
10)List the top 5 passengers that have flown the most miles. Order by miles.
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
*/ 
SELECT airline.name AS Airline, AVG(flight.miles) AS ' Avg Miles Per Flight' 
FROM airline
INNER JOIN flight
ON airline.ID=flight.airlineID
GROUP BY airline.name;

/*
15)Which airlines had flights that arrived early?
*/
SELECT airline.name 
FROM airline
INNER JOIN flight
ON airline.ID=flight.airlineID
WHERE flight.scheduledArriveDateTime > flight.actualArriveDateTime
GROUP BY airline.name;
































