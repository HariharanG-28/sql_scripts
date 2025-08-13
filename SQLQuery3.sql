SELECT 
   a.ID, 
   a.NAME, 
   MAX(a.Maths) AS Maths, 
   MAX(a.Physics) AS Physics, 
   MAX(a.Chemistry) AS Chemistry 
FROM(
   SELECT 
      ID, 
      NAME,
      CASE WHEN Subject = 'Maths' THEN Score ELSE null END AS Maths,
      CASE WHEN Subject = 'Physics' THEN Score Else null END AS Physics,
      CASE WHEN Subject = 'Chemistry' THEN Score Else null END AS Chemistry
   FROM Students) a 
GROUP BY ID, NAME;
