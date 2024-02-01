-- Viewing distinct id for each table

SELECT COUNT(distinct(id))  AS TotalDailyactivityid
FROM Casestudyfitbit.dbo.dailyActivity
SELECT COUNT(distinct(id)) AS TotalhourlyId
FROM Casestudyfitbit.dbo.hourlySteps
SELECT COUNT(distinct(id)) AS TotalweightlogId
FROM Casestudyfitbit.dbo.weightLogInfo
SELECT COUNT(distinct(id)) AS TotalsleepdayId
FROM Casestudyfitbit.dbo.sleepDay

--Checking for duplicates

SELECT Id,sleepaday,COUNT(*) AS DuplicateValue
FROM Casestudyfitbit.dbo.sleepDay
GROUP BY Id,sleepaday
HAVING COUNT (*) >1

--DELETING THE DUPLICATE

WITH CTE AS ( SELECT Id, sleepaday, ROW_NUMBER() OVER (PARTITION BY Id, sleepaday ORDER BY Id, sleepaday) rownum
FROM Casestudyfitbit.dbo.sleepDay
)
DELETE
FROM CTE 
WHERE rownum >1;

--JOINING TABLES DAILYACTIVITY AND SLEEPDAY

SELECT activity.id, activity.activitydate, sleep.Id, sleep.Sleepaday
FROM Casestudyfitbit.DBO.dailyActivity AS activity
JOIN Casestudyfitbit.dbo.sleepDay AS sleep
	ON activity.id = sleep.Id

--AVERAGE MOVEMENTS BY USER DAILY

SELECT AVG(TotalSteps) AS Avgsteps,
	   AVG(TotalDistance) AS Avgdistance,
	   AVG(Calories) AS Avgcalories,
	   AVG(VeryActiveMinutes) AS veryactive,
	   AVG(lightlyActiveMinutes) AS lighlyactive,
	   AVG(fairlyActiveMinutes) AS fairlyactive,
	   AVG(SedentaryMinutes) AS sedentaryactive
FROM Casestudyfitbit.dbo.dailyActivity

SELECT AVG(TotalSleepRecords) AS sleeprecords,
	   AVG(TotalMinutesAsleep) AS minutesasleep,
	   AVG(TotalTimeInBed) AS timeinbed
FROM Casestudyfitbit.dbo.sleepDay

----FINDING THE PERCENT OF ACVTIVENESS(TAB)

SELECT  Id,
	SUM(VeryActiveDistance) AS VeryActive,
	SUM(ModeratelyActiveDistance) AS ModeratlyActive,
	SUM(LightActiveDistance) AS LighlyActive,
	SUM(SedentaryActiveDistance) AS SedantaryActive,
	SUM(Calories) As TotalCalories
FROM Casestudyfitbit.dbo.dailyActivity
GROUP BY Id

--Differentiating sleep and calories by users(TABLEAU)

SELECT Activity.id,
	SUM(TotalTimeInBed) AS Totalsleep,
	SUM(TotalMinutesAsleep) AS Timinbed,
	SUM(Calories) AS Total_calroies
FROM Casestudyfitbit.dbo.dailyActivity Activity
FULL JOIN Casestudyfitbit.dbo.sleepday Sleepday
	ON Activity.id = Sleepday.id
WHERE TotalTimeInBed IS NOT NULL
GROUP BY Activity.id

-- Min, Max And Average weight of all users

SELECT MIN(WeightKg) AS Min_weight,
			 MAX(WeightKg) AS Max_weight,
			 AVG(WeightKg) AS Avg_weight,
			 MIN(BMI) AS Min_BMI,
			 MAX(BMI) AS Max_BMI,
			 AVG(BMI) AS Avg_BMI
FROM Casestudyfitbit.dbo.weightLogInfo

-- Average step by hours to see what time of day users where more active

SELECT  id,
 SUM(StepTotal) AS Totalsteps_hours
FROM Casestudyfitbit.dbo.hourlysteps
GROUP BY id

--Comparing Average weight vs non-sedentary minutes

SELECT activity.id,AVG(VeryActiveMinutes)+AVG(lightlyActiveMinutes)+ AVG(fairlyActiveMinutes)+ AVG(SedentaryMinutes) AS Avg_total_minutes,
				Avg(WeightKg) AS Avg_weight
FROM Casestudyfitbit.dbo.dailyactivity activity
JOIN Casestudyfitbit.dbo.weightlogInfo weight
		ON activity.id = weight.id
Group by activity.id





