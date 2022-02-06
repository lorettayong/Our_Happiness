-- Exclude countries that were identified by WHR committee not to belong in any region
SELECT *
FROM Happiness..HappinessDataTransformed
WHERE Regional_indicator IS NOT NULL
ORDER BY Year DESC

-- 1A. What were the overall average for the evaluation of life quality (in terms of the Life Ladder analogy) in different regions over the years?
SELECT Regional_indicator, Year, AVG(Life_Ladder) AS Avg_life_ladder
FROM Happiness..HappinessDataTransformed
WHERE Regional_indicator IS NOT NULL
GROUP BY Regional_indicator, Year
ORDER BY Avg_life_ladder DESC
-- My suspicion on the high average values for 'North America and ANZ' is due to the small number of countries categorised under this region.
-- Let us see what the scores are on a country basis.

-- 1B. What were the overall average for the evaluation of life quality in different countries over the years?
SELECT Country_name, Regional_indicator, AVG(Life_Ladder) AS Avg_life_ladder
FROM Happiness..HappinessDataTransformed
GROUP BY Country_name, Regional_indicator
ORDER BY Avg_life_ladder DESC
-- It intrigued me that Denmark's average scoring surpasses other countries by nearly 0.1 points.

-- 1C. What was Denmark's life quality scoring through the years?
SELECT Country_name, Year, Life_Ladder
FROM Happiness..HappinessDataTransformed
WHERE Country_name = 'Denmark'
GROUP BY Country_name, Year, Life_Ladder
ORDER BY Year DESC
-- Amazing that Denmark continued to maintain a relatively high score during the difficult year of 2020. She is truly a nation of positive-thinking people!

-- 1D. How did countries evaluate their quality looks of life since the start of the pandemic in 2020?
SELECT Country_name, Regional_indicator, Year, Life_Ladder
FROM Happiness..HappinessDataTransformed
WHERE Year = '2020'
ORDER BY Life_Ladder DESC

-- 1E. I am interested in taking another look at countries classified in the various Asian regions.
SELECT Country_name, Regional_indicator, Year, Life_Ladder
FROM Happiness..HappinessDataTransformed
WHERE Regional_indicator LIKE '%Asia%' AND Year = '2020'
GROUP BY Country_name, Regional_indicator, Year, Life_Ladder
ORDER BY Life_Ladder DESC

-- 2A. On a regional basis, what were people's average ratings on social support rendered over the years?
SELECT Regional_indicator, Year, AVG(Social_support) AS Avg_social_support
FROM Happiness..HappinessDataTransformed
WHERE Regional_indicator IS NOT NULL
GROUP BY Regional_indicator, Year
ORDER BY Avg_social_support DESC
-- Again, my conjecture is that only a handful of countries fall under the region of North America and ANZ, hence the relatively high average point.
-- We will now take a closer look at each country.

-- 2B. And what were people's ratings on social support rendered in 2020 as compared to a year before?
SELECT Country_name, Regional_indicator, Year, Social_support
FROM Happiness..HappinessDataTransformed
WHERE Year IN ('2019', '2020')
GROUP BY Country_name, Regional_indicator, Year, Social_support
ORDER BY Social_support DESC

-- 2C. What about the Asians?
SELECT Country_name, Regional_indicator, Social_support
FROM Happiness..HappinessDataTransformed
WHERE Regional_indicator LIKE '%Asia%' AND Year = '2020'
GROUP BY Country_name, Regional_indicator, Social_support
ORDER BY Social_support DESC

-- 2D. Is it possible to conclude if there is a direct relationship between Asian people's outlook in life against their perceptions on social support received in 2020?
SELECT Country_name, Regional_indicator, Life_Ladder, Social_support
FROM Happiness..HappinessDataTransformed
WHERE Regional_indicator LIKE '%Asia%' AND Year = '2020'
GROUP BY Country_name, Regional_indicator, Life_Ladder, Social_support
ORDER BY Social_support DESC
-- Generally, there seems to be a positive correlation between both measurements.

-- 3. Does happiness in life correlate directly to a longer life expectancy?
SELECT Country_name, Regional_indicator, Year, Life_Ladder, Healthy_life_expectancy_at_birth
FROM Happiness..HappinessDataTransformed
GROUP BY Country_name, Regional_indicator, Year, Life_Ladder, Healthy_life_expectancy_at_birth
ORDER BY Year DESC, Healthy_life_expectancy_at_birth DESC
-- There does not seem to be a direct correlation between people's outlook in life and life expectancy.
-- For instance, Japan's score on the Life Ladder scale is relatively low as compared to Denmark's score; however, their life expectancy is the highest at 75.2 years old.
-- Other underlying factors, which are not available in this dataset, could possibly explain this phenomena.

-- 4. Did people view their freedom to make life choices as being affected by the pandemic in 2020?
-- The country with NULL value under 'Freedom_to_make_life_choices' is removed as the finding is not available in the dataset (no assumptions made that the score is 0)
SELECT Country_name, Regional_indicator, Year, Life_Ladder, Freedom_to_make_life_choices
FROM Happiness..HappinessDataTransformed
WHERE Year = '2020' AND Freedom_to_make_life_choices IS NOT NULL
GROUP BY Country_name, Regional_indicator, Year, Life_Ladder, Freedom_to_make_life_choices
ORDER BY Freedom_to_make_life_choices

-- 5A. Did the factor of generosity play a part in influencing people's evaluation of life, especially during these difficult times?
-- Countries with NULL value under 'Generosity' are removed as the findings are not available in the dataset (no assumptions made that the score was 0)
SELECT Country_name, Regional_indicator, Year, Life_Ladder, Generosity
FROM Happiness..HappinessDataTransformed
WHERE Year IN ('2019', '2020') AND Generosity IS NOT NULL
GROUP BY Country_name, Regional_indicator, Year, Life_Ladder, Generosity
ORDER BY Life_Ladder DESC
-- The numbers do not look encouraging, unfortunately...

-- 5B. Is there any correlation between people's perceived generosity and their perception on social support in 2020?
-- Countries with NULL value under 'Generosity' are removed as the findings are not available in the dataset (no assumptions made that the score was 0)
SELECT Country_name, Regional_indicator, Social_support, Generosity
FROM Happiness..HappinessDataTransformed
WHERE Year = '2020' AND Generosity IS NOT NULL
GROUP BY Country_name, Regional_indicator, Year, Social_support, Generosity
ORDER BY Generosity DESC
-- There does not seem to be any clear relationship between these two factors. People's perception of social support must likely came in the form of government aids
-- provided to tide over the tough times. It is nevertheless regrettable that people in general did not feel that others were generous to one another.

-- 6. What was the maximum scoring given for people's perception of corruptions?
SELECT Country_name, Regional_indicator, MAX(Perceptions_of_corruption) AS Max_corruption_perceptions
FROM Happiness..HappinessDataTransformed
GROUP BY Country_name, Regional_indicator
ORDER BY Max_corruption_perceptions DESC
-- Shocking to see that top 8 countries with the highest scoring for this measurement are from the same region!
-- And not surprising that Indonesia made it to the Top 10 list!

-- 7A. When did people feel the most positive affect and least negative affect (i.e. overall greater well-being)?
-- Countries with NULL value under either measurements are removed as the findings are not available in the dataset (no assumptions made that the score was 0)
SELECT Country_name, Regional_indicator, Year, MAX(Positive_affect) AS Max_positive, MIN(Negative_affect) AS Min_negative
FROM Happiness..HappinessDataTransformed
WHERE Regional_indicator IS NOT NULL AND Positive_affect IS NOT NULL AND Negative_affect IS NOT NULL
GROUP BY Country_name, Regional_indicator, Year
ORDER BY Max_positive DESC, Min_negative DESC
--Impressive that Paraguay and Thailand appeared repeatedly several times...
-- Let us take a closer look at how both countries were affected during the pandamic.

-- 7B. Zooming in on Thailand
-- Paraguay was omited from this query as there is no data for 2020.
SELECT Country_name, Year, MAX(Positive_affect) AS Max_positive, MIN(Negative_affect) AS Min_negative
FROM Happiness..HappinessDataTransformed
WHERE Country_name = 'Thailand'
GROUP BY Country_name, Year
ORDER BY Country_name

-- 7C. Although there is no 2020 data for Singapore, I am curious to see how her people's perceptions changed over time.
SELECT Country_name, Year, MAX(Positive_affect) AS Max_positive, MIN(Negative_affect) AS Min_negative
FROM Happiness..HappinessDataTransformed
WHERE Country_name = 'Singapore'
GROUP BY Country_name, Year
ORDER BY Country_name