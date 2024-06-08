-- LEVEL 1

-- Question 1: Number of users with sessions

SELECT distinct u.id, u.name, u.surname
FROM users u
JOIN sessions s on u.id = s.user_id;

-- Question 2: Number of chargers used by user with id 1

SELECT distinct c.label
FROM users u
JOIN sessions s on u.id = s.user_id
JOIN chargers c on s.charger_id = c.id
WHERE u.id = 1;


-- LEVEL 2

-- Question 3: Number of sessions per charger type (AC/DC):

SELECT c.type, count(*) as Numero_sesiones
FROM chargers c
JOIN sessions s
ON s.charger_id = c.id
GROUP BY c.type;

-- Question 4: Chargers being used by more than one user

SELECT c.label
FROM chargers c
JOIN (
SELECT s.charger_id, count(distinct s.user_id) as Number_users
FROM sessions s 
JOIN users u ON s.user_id = u.id
GROUP BY s.charger_id) sub 
ON c.id = sub.charger_id
WHERE Number_users > 1

-- Question 5: Average session time per charger

SELECT c.label, ROUND(AVG(timestampdiff(MINUTE,s.start_time,s.end_time)),2) as Avg_session_time
FROM chargers c
JOIN sessions s ON c.id = s.charger_id
GROUP BY c.label;

-- LEVEL 3

-- Question 6: Full username of users that have used more than one charger in one day (NOTE: for date only consider start_time)

SELECT u.name, u.surname
FROM users u
JOIN(
SELECT s.user_id, s.start_time, count(distinct s.charger_id) as Charger_used
FROM sessions s
GROUP BY s.user_id, s.start_time) sub
ON u.id = sub.user_id
WHERE sub.Charger_used > 1;


-- Question 7: Top 3 chargers with longer sessions

SELECT c.label, max(ROUND(timestampdiff(MINUTE,s.start_time,s.end_time),2)) as session_time
FROM chargers c
JOIN sessions s ON c.id = s.charger_id
GROUP BY c.label
ORDER BY session_time DESC
LIMIT 3;

-- Question 8: Average number of users per charger (per charger in general, not per charger_id specifically)

SELECT sub.type, AVG(sub.User_per_charger)
FROM(
SELECT c.type, count(s.user_id) as User_per_charger
FROM sessions s
JOIN chargers c ON s.charger_id = c.id 
GROUP BY c.type) sub
GROUP BY sub.type;

-- Question 9: Top 3 users with more chargers being used

SELECT u.name, u.surname
FROM users u
JOIN(
SELECT s.user_id, count(distinct s.charger_id) as Charger_used
FROM sessions s
GROUP BY s.user_id) sub
ON u.id = sub.user_id
ORDER BY sub.Charger_used DESC
LIMIT 3;


-- LEVEL 4

-- Question 10: Number of users that have used only AC chargers, DC chargers or both

WITH cte_chargers AS(
SELECT s.user_id,
CASE
WHEN c.type = 'AC' THEN 'AC'
WHEN c.type = 'DC' THEN 'DC'
END AS Type
FROM sessions s
JOIN chargers c ON s.charger_id = c.id
), cte_users_types AS (
    SELECT 
        user_id,
        MAX(CASE WHEN Type = 'AC' THEN 1 ELSE 0 END) AS AC,
        MAX(CASE WHEN Type = 'DC' THEN 1 ELSE 0 END) AS DC
    FROM cte_chargers
    GROUP BY user_id
)

SELECT
CASE 
WHEN AC = 1 AND DC = 1 THEN 'Los dos'
WHEN AC = 1 AND DC = 0 THEN 'Solo AC'
WHEN AC = 0 AND DC = 1 THEN 'Solo DC'
END AS typeUser,
count(*) as result
from cte_users_types
GROUP BY typeUser;

-- Question 11: Monthly average number of users per charger

SELECT sub.charger_id, AVG(sub.conteo_usuario)
FROM(
select s.charger_id, MONTH(s.start_time) as MES, count(s.user_id) AS conteo_usuario
from sessions s
GROUP BY MES, s.charger_id) sub
GROUP BY sub.charger_id

-- Question 12: Top 3 users per charger (for each charger, number of sessions)

WITH cte_user AS (
    SELECT 
        charger_id,
        user_id,
        COUNT(*) AS sesiones
    FROM sessions s
    GROUP BY s.charger_id, s.user_id
),
cte_ranked_users AS (
    SELECT
        charger_id,
        user_id,
        sesiones,
        ROW_NUMBER() OVER (PARTITION BY charger_id ORDER BY sesiones DESC) AS ranking
    FROM cte_user 
)
SELECT
    charger_id,
    user_id,
    sesiones
FROM cte_ranked_users
WHERE ranking <= 3
ORDER BY charger_id, ranking;



-- LEVEL 5

-- Question 13: Top 3 users with longest sessions per month (consider the month of start_time)
    
WITH cte_duracion_sesiones AS (
    SELECT
        user_id,
        MONTH(start_time) AS month,
        TIMESTAMPDIFF(MINUTE, start_time, end_time) AS duracion
    FROM sessions
),
cte_ranked_sessions AS (
    SELECT
        user_id,
        month,
        duracion,
        ROW_NUMBER() OVER (PARTITION BY month ORDER BY duracion DESC) AS ranking
    FROM cte_duracion_sesiones
)
SELECT
    user_id,
    month,
    duracion
FROM cte_ranked_sessions
WHERE ranking <= 3
ORDER BY month, ranking;


-- Question 14. Average time between sessions for each charger for each month (consider the month of start_time)


--  No sabia como solucionarlo