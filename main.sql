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

WITH pits AS (
    SELECT
        driver_number,
        COUNT(*) AS qty_pits,
        AVG(lane_duration) AS pit_avg_time
    FROM pit
    GROUP BY driver_number
    )
SELECT
    d.full_name AS driver,
    d.team_name AS team,
    s.position,
    qty_pits,
    pit_avg_time
FROM pits p
    JOIN drivers d
        ON p.driver_number = d.driver_number
    JOIN session_result s
        ON d.driver_number = s.driver_number
WHERE s.position IS NOT NULL
ORDER BY s.position;


-- **************** FASTEST LAP *****************

WITH fastest AS (
    SELECT
        driver_number,
        meeting_key,
        MIN(lap_duration) AS fastest_lap
    FROM laps
    GROUP BY 1
    HAVING lap_duration IS NOT NULL
    ORDER BY 2
    LIMIT 1
)
SELECT
    d.full_name AS driver,
    d.team_name AS team,
    m.meeting_name AS gp,
    fastest_lap
FROM fastest t
    JOIN drivers d
        ON t.driver_number = d.driver_number
    JOIN meetings m
        ON t.meeting_key = m.meeting_key;


-- **************** HIGHEST SPEED *****************

WITH speed AS (
    SELECT
        st_speed AS speed,
        driver_number,
        meeting_key
    FROM laps
    WHERE st_speed IS NOT NULL
    ORDER BY st_speed DESC
    LIMIT 1
)
SELECT 
    d.full_name AS driver,
    d.team_name AS team,
    m.meeting_name AS gp,
    speed
FROM speed s
    JOIN drivers d
        ON s.driver_number = d.driver_number
    JOIN meetings m
        ON s.meeting_key = m.meeting_key;