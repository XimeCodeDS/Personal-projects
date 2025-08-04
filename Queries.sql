-- JOINS
 
 SELECT * FROM benn.college_football_players
 
 SELECT * FROM benn.college_football_teamsT
 
SELECT teams.conference AS conference,
       AVG(players.weight) AS average_weight
  FROM benn.college_football_players players
  JOIN benn.college_football_teams teams
    ON teams.school_name = players.school_name
 GROUP BY teams.conference
 ORDER BY AVG(players.weight) DESC
 
SELECT players.school_name,
        players.player_name,
        players.position,
        players.weight
 FROM benn.college_football_players players
 WHERE players.state = 'GA'
 ORDER BY weight DESC
 
 SELECT  *
  FROM benn.college_football_players players
  JOIN benn.college_football_teams teams
    ON teams.school_name = players.school_name
 
SELECT teams.conference AS conference,
       AVG(players.weight) AS avg_weight
  FROM benn.college_football_players players
  JOIN benn.college_football_teams teams
   ON teams.school_name = players.school_name
GROUP BY teams.conference 
ORDER BY AVG(players.weight) DESC


SELECT players.*,
       teams.*
  FROM benn.college_football_players players
  JOIN benn.college_football_teams teams -- JOIN and INNER JOIN are the same
    ON teams.school_name = players.school_name

    
SELECT players.school_name AS players_school_name,  --if columns are named the same in both tables, you can change the name for both
       teams.school_name AS teams_school_name
  FROM benn.college_football_players players
  JOIN benn.college_football_teams teams
    ON teams.school_name = players.school_name
  
SELECT * FROM   benn.college_football_players

SELECT * FROM   benn.college_football_teams

SELECT teams.conference AS conference,
       players.player_name,
       players.school_name
    FROM benn.college_football_players players
    JOIN benn.college_football_teams teams
       ON teams.school_name = players.school_name
    WHERE teams.division  = 'FBS (Division I-A Teams)'


SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
    
SELECT * FROM tutorial.crunchbase_companies

SELECT * FROM tutorial.crunchbase_acquisitions


SELECT COUNT(companies.permalink) AS companies_rowcount,
       COUNT(acquisitions.company_permalink)
 FROM tutorial.crunchbase_companies companies
LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
  ON companies.permalink = acquisitions.company_permalink
  

SELECT companies.state_code,
       COUNT(DISTINCT companies.permalink) AS companies_unique,
       COUNT( DISTINCT acquisitions.company_permalink) AS acquired_companies
 FROM tutorial.crunchbase_companies companies
LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
  ON companies.permalink = acquisitions.company_permalink
  WHERE companies.state_code IS NOT NULL
  GROUP BY companies.state_code
  ORDER BY COUNT( DISTINCT acquisitions.company_permalink) DESC


  SELECT companies.permalink,
       companies.name,
       companies.status,
       COUNT(investments.investor_permalink) AS investors
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments_part1 investments
    ON companies.permalink = investments.company_permalink
   AND investments.funded_year > companies.founded_year + 5
 GROUP BY 1,2, 3
 
 
 SELECT companies.permalink,
       companies.name,
       companies.status,
       COUNT(investments.investor_permalink) AS investors
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments_part1 investments
    ON companies.permalink = investments.company_permalink
 WHERE investments.funded_year > companies.founded_year + 5
 GROUP BY 1,2, 3  -- This technique is especially useful for creating date ranges as shown above. It's important to note that this produces a different result than the following query because it only joins rows that fit the investments.funded_year > companies.founded_year + 5 condition rather than joining all rows and then filtering


  -- Union

  SELECT *
  FROM tutorial.crunchbase_investments_part1

 UNION

 SELECT *
   FROM tutorial.crunchbase_investments_part2


-- change data type

SELECT CAST(funding_total_usd AS VARCHAR) AS total_founding,
CAST( founded_at_clean AS VARCHAR ) AS founded_clean
FROM tutorial.crunchbase_companies_clean_date

--running totals

SELECT duration_seconds,
       SUM(duration_seconds) OVER (ORDER BY start_time) AS running_total
  FROM tutorial.dc_bikeshare_q1_2012


-- rollup

SELECT city, productline, SUM(sales) AS Sales_total
FROM jason_eliot.sales_mode_jason
GROUP BY ROLLUP(city, productline)
ORDER BY city, Sales_total DESC;

-- this query creates a new table with the same dimensions and data as the one selected from

CREATE TABLE new_sales_table AS
SELECT * FROM jason_eliot.sales_mode_jason;


-- here we see the difference in using these three indexing techniques

SELECT 
   id,
   salary,
   department_id,
   RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) AS rank_salary,
   DENSE_RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) AS denserank_salary,
   ROW_NUMBER() OVER(PARTITION BY department_id ORDER BY salary DESC) AS row_number_salary
FROM dmcintos.employee;


