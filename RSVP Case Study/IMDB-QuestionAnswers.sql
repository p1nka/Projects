USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/


-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT COUNT(*) FROM movie;
SELECT COUNT(*) FROM genre;
SELECT COUNT(*) FROM director_mapping;
SELECT COUNT(*) FROM names;
SELECT COUNT(*) FROM ratings;
SELECT COUNT(*) FROM role_mapping;

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT SUM(IF(id IS NULL, 1, 0))                    AS id_nulls,
       SUM(IF(title IS NULL, 1, 0))                 AS title_nulls,
       SUM(IF(year IS NULL, 1, 0))                  AS year_nulls,
       SUM(IF(date_published IS NULL, 1, 0))        AS date_published_nulls,
       SUM(IF(duration IS NULL, 1, 0))              AS duration_nulls,
       SUM(IF(country IS NULL, 1, 0))               AS country_nulls,
       SUM(IF(worlwide_gross_income IS NULL, 1, 0)) AS worlwide_gross_income_nulls,
       SUM(IF(languages IS NULL, 1, 0))             AS languages_nulls,
       SUM(IF(production_company IS NULL, 1, 0))    AS production_company_nulls
FROM   movie; 

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
# Get the count of movies each year, ther is a downword trend from 2017 to 2019 based on the number of movies produced worldwide.
SELECT YEAR(date_published) AS Year,
       COUNT(*)             AS number_of_movies
FROM   movie
GROUP  BY YEAR(date_published)
ORDER  BY number_of_movies DESC;

# Get the count of movies each month
# Mar, Sep and Jan has highest number of movies released
SELECT MONTH(date_published) AS month_num,
       COUNT(*)              AS number_of_movies
FROM   movie
GROUP  BY MONTH(date_published)
ORDER  BY number_of_movies DESC; 



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
# In year 2019 number of movies released in USA and India are 1059
SELECT Count(*) as movie_count
FROM   movie
WHERE  ( country LIKE '%USA%'
          OR country LIKE '%India%' )
       AND year = 2019; 



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
# Get the unique list of genres
SELECT genre
FROM   genre
GROUP  BY genre
ORDER  BY genre; 


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
# Drama genre has highest number of movies: 4285, followed by comedy and thriller.
SELECT gn.genre,
       Count(*) AS count_movie
FROM   movie mv
       INNER JOIN genre gn
               ON mv.id = gn.movie_id
GROUP  BY gn.genre
ORDER  BY count_movie DESC; 


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
# Get the count movies with only 1 genre: 3289, more movies have multiple genres
WITH movie_genre_count
     AS (SELECT mv.id,
                mv.title,
                Count(*) AS genre_count
         FROM   movie mv
                INNER JOIN genre gn
                        ON mv.id = gn.movie_id
         GROUP  BY mv.id
         HAVING genre_count = 1)
SELECT Count(*) as movie_count
FROM   movie_genre_count; 



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
# Average duration is calculated by sum of duration and dividing by count of movies in each genre
# Action, romnce and crime has highest movie lengths
SELECT gn.genre,
       ROUND(AVG(duration), 2) AS avg_duration
FROM   movie mv
       INNER JOIN genre gn
               ON mv.id = gn.movie_id
GROUP  BY gn.genre
ORDER  BY avg_duration DESC; 



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
# genre 'Thriller' has rank 3
WITH movie_count_genre
     AS (SELECT gn.genre,
                Count(*) AS count_movie
         FROM   movie mv
                INNER JOIN genre gn
                        ON mv.id = gn.movie_id
         GROUP  BY gn.genre
         ORDER  BY count_movie DESC)
SELECT genre,
       count_movie,
       DENSE_RANK()
         OVER(
           ORDER BY count_movie DESC) AS genre_rank
FROM   movie_count_genre; 



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:


-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT Round(Min(avg_rating))    AS min_avg_rating,
       Round(Max(avg_rating))    AS max_avg_rating,
       Round(Min(total_votes))   AS min_total_votes,
       Round(Max(total_votes))   AS max_total_votes,
       Round(Min(median_rating)) AS min_median_rating,
       Round(Max(median_rating)) AS max_median_rating
FROM   ratings; 

    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
# Get movies with highest 10 ratings
# "Love in Kilnerry", "Kirket" and "Gini Helida Kathe" are having highest ratings
WITH movie_by_rank
     AS (SELECT mv.title,
                Round(Avg(avg_rating),2)           AS avg_rating,
                Dense_rank()
                  OVER(
                    ORDER BY Avg(avg_rating) DESC) AS movie_rank
         FROM   movie mv
                INNER JOIN ratings rt
                        ON rt.movie_id = mv.id
         GROUP  BY mv.title)
SELECT *
FROM   movie_by_rank
WHERE  movie_rank <= 10; 



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
# Get the count of movies based on median rating
# Median rating 7, 6, 8 are given for highest number of movies, in that order
SELECT rt.median_rating,
       Count(*) AS movie_count
FROM   movie mv
       INNER JOIN ratings rt
               ON rt.movie_id = mv.id
GROUP  BY median_rating
ORDER  BY movie_count DESC; 




/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
# Get count of movies grouped by production company
# "Dream Warrior Pictures" and "National Theatre Live" made highest number of movies, 3 each
WITH movie_count_rank
     AS (SELECT mv.production_company,
                Count(*) AS movie_count
         FROM   movie mv
                INNER JOIN ratings rt
                        ON mv.id = rt.movie_id
         WHERE  production_company IS NOT NULL
                AND rt.avg_rating > 8
         GROUP  BY production_company
         ORDER  BY movie_count DESC)
SELECT production_company,
       movie_count,
       DENSE_RANK()
         OVER (
           ORDER BY movie_count DESC) AS prod_company_rank
FROM   movie_count_rank; 




-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
# Drama has the highest number of movies 24, followed by Comedy 9 and action 8, thriller 8, in USA in March wit 1000+ votes.
# Overall higthest movie count by genre are Drama, Comedy and Thriller, with Drama with significant lead.
SELECT gn.genre,
       Count(*) AS movie_count
FROM   movie mv
       INNER JOIN genre gn
               ON gn.movie_id = mv.id
       INNER JOIN ratings rt
               ON rt.movie_id = mv.id
#WHERE  mv.year = 2017
       AND Month(date_published) = 3
       AND mv.country LIKE '%USA%'
       AND rt.total_votes > 1000
GROUP  BY gn.genre
ORDER  BY movie_count DESC; 



-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
# movies of each genre that start with the word ‘The’ and which have an average rating > 8
SELECT mv.title,
       rt.avg_rating,
       gn.genre
FROM   movie mv
       INNER JOIN genre gn
               ON gn.movie_id = mv.id
       INNER JOIN ratings rt
               ON rt.movie_id = mv.id
WHERE  mv.title LIKE 'The%'
       AND rt.avg_rating > 8
ORDER  BY gn.genre,
          mv.title; 



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
# Get the count of movies with given conditions
# In the given year 381 movie got median rating of 8
SELECT Count(*) as movie_count
FROM   movie mv
       INNER JOIN ratings rt
               ON rt.movie_id = mv.id
WHERE  mv.date_published BETWEEN '2018-04-01' AND '2019-04-01'
       AND rt.median_rating = 8; 




-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
# Get the sum votes by country, some moves are releases in multiple countries
# German movies get significantly more votes than italian movies
# In general USA, Canada, India, Hong Kong movies get maximum votes
WITH vote_by_country
     AS (SELECT CASE
                  WHEN mv.country LIKE '%Germany%' THEN 'Germany'
                  WHEN mv.country LIKE '%Italy%' THEN 'Italy'
                  ELSE ''
                END                 AS country,
                Sum(rt.total_votes) AS total_votes
         FROM   movie mv
                INNER JOIN ratings rt
                        ON rt.movie_id = mv.id
         WHERE  mv.country LIKE '%Germany%'
                 OR mv.country LIKE '%Italy%'
         GROUP  BY mv.country)
SELECT country,
       Sum(total_votes) as total_votes
FROM   vote_by_country
GROUP  BY country; 




-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/



-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT SUM(IF(name IS NULL, 1, 0))             AS name_nulls,
       SUM(IF(height IS NULL, 1, 0))           AS height_nulls,
       SUM(IF(date_of_birth IS NULL, 1, 0))    AS date_of_birth_nulls,
       SUM(IF(known_for_movies IS NULL, 1, 0)) AS known_for_movies_nulls
FROM   names;



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
# Get the movie count by director and genre in CTE
# Then get top 3 director name by total movie count without genre, from top 3 genre based count.James Mangold is one of the 3.
# Then get top 3 director in top 3 genres are James Mangold, Anthony Russo, Joe Russo
WITH movie_director_rank AS
(
   SELECT     gn.genre,
			  nm.name                                   AS director_name,
			  Count(*)                                  AS movie_count,
			  DENSE_RANK() OVER(ORDER BY Count(*) DESC) AS movie_count_genre_rank
   FROM       movie mv
   INNER JOIN genre gn
   ON         gn.movie_id = mv.id
   INNER JOIN ratings rt
   ON         rt.movie_id = mv.id
   INNER JOIN director_mapping dm
   ON         dm.movie_id = mv.id
   INNER JOIN names nm
   ON         dm.name_id = nm.id
   WHERE      rt.avg_rating > 8
   GROUP BY   gn.genre,
			  nm.name 
)
SELECT   director_name,
         Sum(movie_count) AS movie_count
FROM     movie_director_rank
WHERE    movie_count_genre_rank<=3
GROUP BY director_name limit 3;



/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
# Get the actors rank by movie count
# Mammootty and Mohanlal done highest number of top rated movies
WITH actor_rank AS 
(
	SELECT nm.name,
			Count(*)                    AS movie_count,
			DENSE_RANK()
			  OVER(
				ORDER BY Count(*) DESC) AS movie_count_rank
	 FROM   movie mv
			INNER JOIN ratings rt
					ON mv.id = rt.movie_id
			INNER JOIN role_mapping rm
					ON rm.movie_id = mv.id
			INNER JOIN names nm
					ON nm.id = rm.name_id
	 WHERE  rt.median_rating >= 8
			AND rm.category = 'actor'
	 GROUP  BY nm.name
)
SELECT *
FROM   actor_rank
WHERE  movie_count_rank <= 2; 



/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
# Get production company by total votes for movies.
# Marvel Studios, Twentieth Century Fox and Warner Bros are the top 3.
WITH poduction_company_ranking AS 
(
	SELECT mv.production_company,
			Sum(rt.total_votes)                    AS vote_count,
			DENSE_RANK()
			  OVER(
				ORDER BY Sum(rt.total_votes) DESC) AS prod_comp_rank
	 FROM   movie mv
			INNER JOIN ratings rt
					ON rt.movie_id = mv.id
	 GROUP  BY mv.production_company
 )
SELECT *
FROM   poduction_company_ranking
WHERE  prod_comp_rank <= 3; 



/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
# Weighted average is: ∑(rating×votes) / ∑votes
# Get the weighted average and vote count by actor for Indian movies. Vijay Sethupathi has highest rank.
SELECT     nm.name                                                                                    AS actor_name,
           Sum(rt.total_votes)                                                                        AS total_votes,
           Count(*)                                                                                   AS movie_count,
           Round(Sum(rt.avg_rating * rt.total_votes) / Sum(rt.total_votes),2) 						  AS actor_avg_rating,
           DENSE_RANK() OVER(ORDER BY Sum(rt.avg_rating * rt.total_votes) / Sum(rt.total_votes) DESC) AS actor_rank
FROM       movie mv
INNER JOIN ratings rt
ON         mv.id = rt.movie_id
INNER JOIN role_mapping rm
ON         rm.movie_id = mv.id
INNER JOIN names nm
ON         nm.id = rm.name_id
WHERE      mv.country LIKE '%India%' and rm.category = 'actor'
GROUP BY   nm.name
HAVING     movie_count >= 5;



-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
# Weighted average is: ∑(rating×votes) / ∑votes
# Get the weighted average and vote count by actress. Taapsee Pannu is at top for hindi movies, with 7.74 as average rating.
SELECT     nm.name                                                                                    AS actress_name,
           Sum(rt.total_votes)                                                                        AS total_votes,
           Count(*)                                                                                   AS movie_count,
           Round(Sum(rt.avg_rating * rt.total_votes) / Sum(rt.total_votes),2) 						  AS actress_avg_rating,
           DENSE_RANK() OVER(ORDER BY Sum(rt.avg_rating * rt.total_votes) / Sum(rt.total_votes) DESC) AS actress_rank
FROM       movie mv
INNER JOIN ratings rt
ON         mv.id = rt.movie_id
INNER JOIN role_mapping rm
ON         rm.movie_id = mv.id
INNER JOIN names nm
ON         nm.id = rm.name_id
WHERE      mv.country LIKE '%India%' and rm.category = 'actress' and mv.languages like '%Hindi%'
GROUP BY   nm.name
HAVING     movie_count >= 3;




/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
# group by movie title and get average rating and classify based on that
# Movie "Der müde Tod" is highest rated thriller movie
WITH thriller_average
     AS (SELECT mv.title,
                Round(Avg(rt.avg_rating), 2) AS average_rating
         FROM   movie mv
                INNER JOIN ratings rt
                        ON rt.movie_id = mv.id
                INNER JOIN genre gn
                        ON gn.movie_id = mv.id
         WHERE  gn.genre like '%Thriller%'
         GROUP  BY mv.title)
SELECT title,
       average_rating,
       CASE
         WHEN average_rating > 8 THEN 'Superhit movies'
         WHEN average_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN average_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         ELSE 'Flop movies'
       END AS movie_classification
FROM   thriller_average; 



/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
# Get genre wise average duration, then create use frames to calculate running total and moving average
WITH genre_agv_duration
     AS (SELECT gn.genre,
                ROUND(AVG(mv.duration), 2) AS avg_duration
         FROM   movie mv
                INNER JOIN genre gn
                        ON gn.movie_id = mv.id
         GROUP  BY gn.genre)
SELECT genre,
       avg_duration,
       ROUND(SUM(avg_duration)
               OVER (
                 ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
               ), 2)
       AS running_total_duration,
       ROUND(AVG(avg_duration)
               OVER (
                 ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
               ), 2)
       AS moving_avg_duration
FROM   genre_agv_duration; 




-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
# Get the top genres and filter the final result by those genres
# Rank the data by gross income, some outliers and null values to be removed from ranking. Note some of the movies are in multiple genre, hence received same ranking
# Overall, Five highest-grossing movies that belong to the top three genres are "Avengers: Endgame" and "The Lion King"
WITH movie_rank
     AS (SELECT gn.genre,
                Count(*)                    AS movie_count,
                DENSE_RANK()
                  OVER(
                    ORDER BY Count(*) DESC) movie_count_rank
         FROM   movie mv
                INNER JOIN genre gn
                        ON gn.movie_id = mv.id
         GROUP  BY gn.genre
         order by movie_count_rank
         limit 3),
     gross_rank
     AS (SELECT gn.genre,
                mv.title,
                mv.year,
                Cast(Substring(worlwide_gross_income, 2) AS DECIMAL(30, 2)) AS
                worldwide_gross_income,
                DENSE_RANK()
                  OVER(PARTITION BY year
                    ORDER BY Cast(Substring(worlwide_gross_income, 2) AS DECIMAL
                  (30,
                  2))
                  DESC) AS
                  movie_gross_rank
         FROM   movie mv
                INNER JOIN genre gn
                        ON gn.movie_id = mv.id
				INNER JOIN movie_rank mvr ON mvr.genre = gn.genre
         WHERE  worlwide_gross_income IS NOT NULL
                AND Substring(worlwide_gross_income, 1, 1) = '$'
)
SELECT gr.genre,
       gr.year,
       gr.title            AS movie_name,
       gr.worldwide_gross_income,
       gr.movie_gross_rank AS movie_rank
FROM   gross_rank gr
WHERE gr.movie_gross_rank<=5
order by gr.year, gr.movie_gross_rank, gr.genre;



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
# Get the multilingual movies and with >8 rating with ranking by movie count in CTE
# Then take 2 highest rank production houses with mulltilinaual movies are "Star Cinema", "Twentieth Century Fox"
WITH prod_company_rank
     AS (SELECT production_company,
                Count(*)                    AS movie_count,
                DENSE_RANK()
                  OVER(
                    ORDER BY Count(*) DESC) AS prod_comp_rank
         FROM   movie mv
                INNER JOIN ratings rt
                        ON rt.movie_id = mv.id
         WHERE  median_rating >= 8
                AND languages LIKE '%,%'
                AND production_company IS NOT NULL
         GROUP  BY production_company)
SELECT *
FROM   prod_company_rank
WHERE  prod_comp_rank <= 2; 




-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
# For Drama super hit movies top 3 actress are Susan Brown, Amanda Lawrence, Denise Gough
WITH actress_rank AS
(
           SELECT     nm.name                                   AS actress_name,
                      Sum(rt.total_votes)                       						 	AS total_votes,
                      Count(*)                                  						 	AS movie_count,
                      Round(Sum(rt.avg_rating * rt.total_votes) / Sum(rt.total_votes),2)    AS actress_avg_rating,
                      DENSE_RANK() OVER(ORDER BY Count(*) DESC) 						 	AS actress_rank
           FROM       movie mv
           INNER JOIN ratings rt
           ON         rt.movie_id = mv.id
           INNER JOIN genre gn
           ON         gn.movie_id = mv.id
           INNER JOIN role_mapping rm
           ON         rm.movie_id = mv.id
           INNER JOIN names nm
           ON         rm.name_id = nm.id
           WHERE      gn.genre = 'Drama'
           AND        rm.category = 'actress'
           AND 		  rt.avg_rating > 8
           GROUP BY   nm.name 
)
SELECT   *
FROM     actress_rank
ORDER BY actress_rank ASC,
         actress_avg_rating DESC,
         total_votes DESC 
LIMIT 3;



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
# Group by movie count and generate rank on that, calculate max and min date fifference and devive by movie count to get interval
# Get other required fields and create a CTE
# The top 3 diretor based on total number of movies, rating, vote etc are A.L. Vijay, Andrew Jones, Steven Soderbergh
WITH dir_rank AS
(
   SELECT     nm.id                                                                        AS director_id,
			  nm.name                                                                      AS director_name,
			  Count(*)                                                                     AS number_of_movies,
			  Round(Datediff(Max(mv.date_published), Min(mv.date_published)) / Count(*),2) AS avg_inter_movie_days,
			  Round(Avg(rt.avg_rating),2)                                                  AS avg_rating,
			  Sum(rt.total_votes)                                                          AS total_votes,
			  Min(rt.avg_rating)                                                           AS min_rating,
			  Max(rt.avg_rating)                                                           AS max_rating,
			  Sum(mv.duration)                                                             AS total_duration,
			  DENSE_RANK() OVER(ORDER BY Count(*) DESC)                                    AS dir_rank
   FROM       movie mv
   INNER JOIN ratings rt
   ON         rt.movie_id = mv.id
   INNER JOIN director_mapping dm
   ON         dm.movie_id = mv.id
   INNER JOIN names nm
   ON         dm.name_id = nm.id
   GROUP BY   nm.id,
			  nm.name )
SELECT   director_id,
         director_name,
         number_of_movies,
         avg_inter_movie_days,
         avg_rating,
         total_votes,
         min_rating,
         max_rating,
         total_duration
FROM     dir_rank
WHERE    dir_rank <= 9
ORDER BY dir_rank ASC,
         avg_rating DESC,
         total_votes DESC,
         max_rating DESC,
         min_rating DESC 
LIMIT 9;





