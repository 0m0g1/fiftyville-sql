-- Keep a log of any SQL queries you execute as you solve the mystery.

-- Check the description of the crime
SELECT description
FROM crime_scene_reports
WHERE year = 2021
AND month = 7
AND day = 28
AND street = 'Humphrey Street';

--There was theft and littering.

--Find the names and transcripts of the witnesses
SELECT name,transcript
FROM interviews
WHERE year = 2021
AND month = 7
AND day = 28;

-- Findling the names of the 3 witnesses from the transcripts
SELECT name, transcript
FROM interviews
WHERE year = 2021
AND month = 7
AND day = 28
AND transcript LIKE '%bakery%';
-- Eugene, Raymond, and Ruth were the witnesses

-- Eugene said the thief withdrew money from an ATM in Leggett Street
-- Check the account of the person who made the transaction

SELECT account_number, amount
FROM atm_transactions
WHERE year = 2021
AND month = 7
AND day = 28
AND atm_location = 'Leggett Street'
AND transaction_type = 'withdraw';

-- Find the names associated with the account number.
SELECT name, atm_transactions.amount
FROM people
JOIN bank_accounts
ON people.id = bank_accounts.person_id
JOIN atm_transactions
ON bank_accounts.account_number = atm_transactions.account_number
WHERE atm_transactions.year = 2021
AND atm_transactions.month = 7
AND atm_transactions.day = 28
AND atm_transactions.atm_location = 'Leggett Street'
AND atm_transactions.transaction_type = 'withdraw';

-- The thief drove away in a car from the bakery, within 10 minutes from the theft
-- Checking the license plates of cars within that time frame.
SELECT name, bakery_security_logs.hour, bakery_security_logs.minute
FROM people
JOIN bakery_security_logs
ON people.license_plate = bakery_security_logs.license_plate
WHERE bakery_security_logs.year = 2021
AND bakery_security_logs.month = 7
AND bakery_security_logs.day = 28
AND bakery_security_logs.activity = 'exit'
AND bakery_security_logs.hour = 10
AND bakery_security_logs.minute >= 15
AND bakery_security_logs.minute <= 25
ORDER BY bakery_security_logs.minute;

-- Information about the Fiftyville airport
SELECT abbreviation, full_name, city
FROM airports
WHERE city = 'Fiftyville';

-- Finding the flights on July 29 from
SELECT flights.id, full_name, city, flights.hour, flights.minute
FROM airports
JOIN flights
ON airports.id = flights.destination_airport_id
WHERE flights.origin_airport_id =
(SELECT id
FROM airports
WHERE city = 'Fiftyville')
AND flights.year = 2021
AND flights.month = 7
AND flights.day = 29
ORDER BY flights.hour, flights.minute;

-- The first flight is at 8:20 to New York City (Flight id- 36). This could be the place where the thief went to.
-- Checking the list of passengers in that flight
SELECT passengers.flight_id, name, passengers.passport_number, passengers.seat
FROM people
JOIN passengers
ON people.passport_number = passengers.passport_number
JOIN flights
ON passengers.flight_id = flights.id
WHERE flights.year = 2021
AND flights.month = 7
AND flights.day = 29
AND flights.hour = 8
AND flights.minute = 20
ORDER BY passengers.passport_number;

-- Checking the phone call records to find the one who bought the tickets.
-- Checking the possible names of the caller
SELECT name, phone_calls.duration
FROM people
JOIN phone_calls
ON people.phone_number = phone_calls.caller
WHERE phone_calls.year = 2021
AND phone_calls.month = 7
AND phone_calls.day = 28
AND phone_calls.duration <= 60
ORDER BY phone_calls.duration;

-- Checking the possible names of the receiver
SELECT name, phone_calls.duration
FROM people
JOIN phone_calls
ON people.phone_number = phone_calls.receiver
WHERE phone_calls.year = 2021
AND phone_calls.month = 7
AND phone_calls.day = 28
AND phone_calls.duration <= 60
ORDER BY phone_calls.duration;

-- Bruce is present in all the 4 lists ( List of passengers, list of atm transactions, list of people who called, and list of people who drove from the bakery).
-- He went to New York -he took a flight to New York.
-- His accomplice is Robin who purchased the flight ticket, and helped Him escape to the New York City.