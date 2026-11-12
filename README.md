# Formula 1 2025 Season Analysis – SQL

A SQL analysis of Formula 1 data from the [OpenF1 API](https://openf1.org/), using **SQLite** to relate several tables and answer questions about the 2025 season.

## Objective

Join related F1 datasets (drivers, meetings, results, laps and pit stops) to look at race winners, pit stop performance, fastest laps, top speeds, and driver and team points.

## Tools & Techniques

- **SQLite**, run in Cursor
- **OpenF1 API** as the data source
- `JOIN`s on multiple keys, CTEs (including nested CTEs), `GROUP BY`, aggregates (`COUNT`, `SUM`, `AVG`, `MIN`), `ROW_NUMBER()`, `UNION ALL`, `strftime` and `printf`

## Database Tables

| Table | Description |
|---|---|
| `drivers` | Driver name, number and team for each meeting |
| `meetings` | Grand Prix events with name and start date |
| `sessions` | Sessions within each meeting |
| `session_result` | Finishing position, points and laps completed |
| `laps` | Lap times and speed-trap data |
| `pit` | Pit stops and pit lane duration |
| `stints` | Tyre stints |
| `weather` | Track weather conditions |

The tables are linked through `meeting_key` and `driver_number`.

## Analysis

1. **Race winners**: the race winners of 2025, with date, laps and team.
2. **Pit stops**: the number of pit stops and average pit lane time for each driver in each race.
3. **Fastest lap**: the fastest lap at each Grand Prix.
4. **Highest speed**: the top speed-trap reading across all races.
5. **Driver wins**: the number of 2025 wins for each driver.
6. **Team wins**: the number of 2025 wins for each team.
7. **Team points**: total points for each team in 2025.
8. **Driver points**: each driver's points race by race, with a total row for each driver built using `UNION ALL`.

## How to Run

1. Pull the data from the OpenF1 API and import each dataset into a SQLite database as its own table.
2. Open the `.sql` file in Cursor, or any SQLite tool.
3. Run each section on its own to see the results.

## Key Skills Demonstrated

- Relating several tables with composite join keys
- Building multi-step logic with CTEs
- Ranking and filtering with window functions
- Combining detail rows and totals in one result
