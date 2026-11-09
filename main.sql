-- **************** CHECKING THE TABLES *****************

SELECT
    *
FROM drivers;

SELECT
    *
FROM laps;

SELECT
    *
FROM meetings;

SELECT
    *
FROM pit;

SELECT
    *
FROM session_result;

SELECT
    *
FROM sessions;

SELECT
    *
FROM stints;

SELECT
    *
FROM weather;


-- **************** CHECKING RESULTS *****************

SELECT
    m.meeting_name AS race,
    SUBSTR(m.date_start, 1, 10) AS event_date,
    s.number_of_laps AS laps,
    s.position,
    d.full_name AS driver,
    d.team_name AS team,
    s.points
FROM session_result s
    JOIN meetings m
        ON s.meeting_key = m.meeting_key
    JOIN drivers d
        ON s.driver_number = d.driver_number;


-- **************** CHECKING PITS *****************