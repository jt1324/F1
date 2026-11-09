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


-- **************** CHECKING RESULT *****************

SELECT
    m.meeting_name,
    SUBSTR(m.date_start, 1, 10) AS event_date,
    s.number_of_laps,
    s.position,
    d.full_name,
    d.team_name,
    s.points
FROM session_result s
JOIN meetings m
ON s.meeting_key = m.meeting_key
JOIN drivers d
ON s.driver_number = d.driver_number;