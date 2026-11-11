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

WITH dupe AS (
    SELECT
        m.meeting_name AS race,
        SUBSTR(m.date_start, 1, 10) AS event_date,
        s.number_of_laps AS laps,
        s.position,
        d.full_name AS driver,
        d.team_name AS team,
        CAST(s.points AS INTEGER) AS points
    FROM session_result s
        LEFT JOIN meetings m
            ON s.meeting_key = m.meeting_key
        LEFT JOIN drivers d
            ON s.driver_number = d.driver_number
    WHERE position = 1 AND strftime('%Y', event_date) = '2025'
)
SELECT 
    DISTINCT *
FROM dupe;


-- **************** CHECKING PITS *****************

WITH pit_data AS (
    WITH pits AS (
        SELECT
            meeting_key,
            driver_number,
            COUNT(*) AS qty_pits,
            AVG(lane_duration) AS pit_avg_time
        FROM pit
        GROUP BY driver_number, meeting_key
        )
    SELECT
        m.meeting_name AS race,
        d.full_name AS driver,
        d.team_name AS team,
        s.position,
        qty_pits,
        pit_avg_time
    FROM pits p
        JOIN drivers d
            ON p.driver_number = d.driver_number
            AND p.meeting_key = d.meeting_key
        JOIN session_result s
            ON d.driver_number = s.driver_number
            AND p.meeting_key = s.meeting_key
        JOIN meetings m
            ON p.meeting_key = m.meeting_key
            AND p.meeting_key = m.meeting_key
    WHERE s.position IS NOT NULL
    ORDER BY pit_avg_time
)
SELECT
    DISTINCT *
FROM pit_data;


-- **************** FASTEST LAP *****************

WITH lap_data AS (
    WITH fastest AS (
        SELECT
            driver_number,
            meeting_key,
            MIN(lap_duration) AS fastest_lap
        FROM laps
        GROUP BY 1, 2
        HAVING lap_duration IS NOT NULL
        ORDER BY 3
        -- LIMIT 1
    )
    SELECT
        d.full_name AS driver,
        d.team_name AS team,
        m.meeting_name AS gp,
        fastest_lap,
        ROW_NUMBER() OVER(
            PARTITION BY m.meeting_name
        ) AS r_n
    FROM fastest t
        JOIN drivers d
            ON t.driver_number = d.driver_number
        JOIN meetings m
            ON t.meeting_key = m.meeting_key
)
SELECT
    driver,
    team,
    gp,
    fastest_lap
FROM lap_data
WHERE r_n = 1
ORDER BY fastest_lap;


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

