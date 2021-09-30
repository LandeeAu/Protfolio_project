

 WITH pop_vs_vac (continent, location, date, population, new_vaccinations, vaccined_people)
 AS(
SELECT
	dea.continent,
	dea.location,
	dea.date,
	dea.population ,
	vac.new_vaccinations,
	SUM(cast(new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date )
	AS vaccined_people
	--(SUM(cast(new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date ))/ CAST(dea.population AS int) AS vacc_rate
	 
FROM 
	covid_death AS dea INNER JOIN covid_vacc AS vac ON dea.location = vac.location 
	AND dea.date =vac.date
WHERE
	dea.continent IS NOT NULL 
ORDER BY 
	dea.location,dea.date 
	)

SELECT *,(vaccined_people/cast(population as int))*100
FROM pop_vs_vac


--TEMP TABLE
DROP TABLE IF  EXISTS percent_population_vaccinated
CREATE TEMP TABLE  percent_population_vaccinated
( Continent varchar(255),
  location varchar(255),
  date timestamp,
  population numeric,
 new_vaccinations numeric,
 vaccined_people numeric);

INSERT INTO percent_population_vaccinated 
SELECT
	dea.continent,
	dea.location,
	dea.date,
	cast(dea.population AS numeric) ,
	cast(vac.new_vaccinations AS numeric),
	SUM(cast(new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date )
	AS vaccined_people
	--(SUM(cast(new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date ))/ CAST(dea.population AS int) AS vacc_rate
	 
FROM 
	covid_death AS dea INNER JOIN covid_vacc AS vac ON dea.location = vac.location 
	AND dea.date =vac.date
WHERE
	dea.continent IS NOT NULL 
ORDER BY 
	dea.location,dea.date 
	
	
SELECT *, (vaccined_people/population)*100 AS vaccined_rate
FROM percent_population_vaccinated


CREATE VIEW percent_population_vaccinated AS
SELECT
	dea.continent,
	dea.location,
	dea.date,
	cast(dea.population AS numeric) ,
	cast(vac.new_vaccinations AS numeric),
	SUM(cast(new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date )
	AS vaccined_people
	--(SUM(cast(new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date ))/ CAST(dea.population AS int) AS vacc_rate
	 
FROM 
	covid_death AS dea INNER JOIN covid_vacc AS vac ON dea.location = vac.location 
	AND dea.date =vac.date
WHERE
	dea.continent IS NOT NULL 
ORDER BY 
	dea.location,dea.date 
