USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT table_name, table_rows
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'imdb';
------OUTPUT
# TABLE_NAME, TABLE_ROWS
'director_mapping', '3867'
'genre', '14662'
'movie', '8068'
'names', '23942'
'ratings', '8230'
'role_mapping', '15195'

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
		SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS ID , 
		SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title, 
		SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year,
		SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published,
		SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration,
		SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country,
		SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worlwide_gross_income,
		SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages,
		SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company
FROM movie
--- Remarks :- country,worlwide_gross_income,languages,production_company
------OUTPUT
# ID, title, year, date_published, duration, country, worlwide_gross_income, languages, production_company
'0', '0', '0', '0', '0', '20', '3724', '194', '528'





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

----- Remarks "movies released each year "
SELECT year, COUNT(id) as number_of_movies
FROM movie
GROUP BY year
ORDER BY year;
----output
# year, number_of_movies
'2017', '3052'
'2018', '2944'
'2019', '2001'

----- Remarks" Number of movies released each month "
SELECT MONTH(date_published) AS month_num, COUNT(id) AS number_of_movies 
FROM movie
GROUP BY MONTH(date_published)
ORDER BY MONTH(date_published);
------Output
# month_num, number_of_movies
'1', '804'
'2', '640'
'3', '824'
'4', '680'
'5', '625'
'6', '580'
'7', '493'
'8', '678'
'9', '809'
'10', '801'
'11', '625'
'12', '438'


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT Count(DISTINCT id) AS number_of_movies, year
FROM   movie
WHERE  ( country LIKE '%INDIA%'
          OR country LIKE '%USA%' )
       AND year = 2019; 
-- We used like as some movies have multiple counries in country feild
-----output
# number_of_movies, year
'1059', '2019'



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre FROM   genre; 
-----output 
# genre
'Drama'
'Fantasy'
'Thriller'
'Comedy'
'Horror'
'Family'
'Romance'
'Adventure'
'Action'
'Sci-Fi'
'Crime'
'Mystery'
'Others'




/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT a.genre, COUNT(a.movie_id) AS number_of_movies
FROM genre a
INNER JOIN movie b ON b.id = a.movie_id 
GROUP BY genre
ORDER BY number_of_movies DESC
LIMIT 1;
----------OUTPUT
# genre, number_of_movies
'Drama', '4285'

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH Movie_genre AS
(
	SELECT a.movie_id, COUNT(a.genre) AS number_of_genre
	FROM genre a
	GROUP BY movie_id
	HAVING number_of_genre=1
)
SELECT count(movie_id) AS number_of_Movies
FROM Movie_genre;
------output 
# number_of_Movies
'3289'

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

SELECT a.genre, ROUND( AVG(b.duration) ) AS avg_duration
FROM genre a
INNER JOIN movie b ON  b.id = a.movie_id 
GROUP BY genre
ORDER BY AVG(duration) DESC;

----output
# genre, avg_duration
'Action', '113'
'Romance', '110'
'Crime', '107'
'Drama', '107'
'Fantasy', '105'
'Comedy', '103'
'Adventure', '102'
'Mystery', '102'
'Thriller', '102'
'Family', '101'
'Others', '100'
'Sci-Fi', '98'
'Horror', '93'


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


WITH rank_genre AS
(
	SELECT genre, COUNT(movie_id) AS No_of_movies,
			RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank
	FROM genre
	GROUP BY genre
)

SELECT *
FROM rank_genre
WHERE genre='thriller';

-----output
Thriller	1484	3
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

SELECT MIN(avg_rating) AS min_avg_rating, 
		MAX(avg_rating) AS max_avg_rating,
		MIN(total_votes) AS min_total_votes, 
        MAX(total_votes) AS max_total_votes,
		MIN(median_rating) AS min_median_rating, 
        MAX(median_rating) AS max_median_rating
        
FROM ratings;

-----------output
# min_avg_rating, max_avg_rating, min_total_votes, max_total_votes, min_median_rating, max_median_rating
'1.0', '10.0', '100', '725138', '1', '10'



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

SELECT a.title, b.avg_rating,
		 RANK() OVER(ORDER BY b.avg_rating DESC) AS movie_rank
FROM movie AS a
INNER JOIN ratings AS b
ON b.movie_id = a.id
LIMIT 10;

-------------output
# title, avg_rating, movie_rank
'Kirket', '10.0', '1'
'Love in Kilnerry', '10.0', '1'
'Gini Helida Kathe', '9.8', '3'
'Runam', '9.7', '4'
'Fan', '9.6', '5'
'Android Kunjappan Version 5.25', '9.6', '5'
'Yeh Suhaagraat Impossible', '9.5', '7'
'Safe', '9.5', '7'
'The Brighton Miracle', '9.5', '7'
'Shibu', '9.4', '10'


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

SELECT a.median_rating, COUNT(a.movie_id) AS movie_count
FROM ratings a
GROUP BY median_rating
ORDER BY median_rating;

----output
# median_rating, movie_count
'1', '94'
'2', '119'
'3', '283'
'4', '479'
'5', '985'
'6', '1975'
'7', '2257'
'8', '1030'
'9', '429'
'10', '346'


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

WITH rank_production_house AS
(
SELECT a.production_company, COUNT(a.id) AS movie_count,
		DENSE_RANK() OVER(ORDER BY COUNT(a.id) DESC) AS rank_prod_company
FROM movie AS a
INNER JOIN ratings AS b
ON b.movie_id = a.id 
WHERE b.avg_rating > 8 AND a.production_company IS NOT NULL
GROUP BY production_company
ORDER BY movie_count DESC
)
select * from rank_production_house
where rank_prod_company =1

-------output
# production_company, movie_count, rank_prod_company
'Dream Warrior Pictures', '3', '1'
'National Theatre Live', '3', '1'

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

SELECT a.genre, COUNT(a.movie_id) AS movie_count
FROM genre  a 
INNER JOIN ratings b ON  b.movie_id = a.movie_id 
INNER JOIN movie  c ON c.id = b.movie_id

WHERE c.country like 'USA' AND b.total_votes>1000 
AND MONTH(c.date_published)=3 AND year=2017
GROUP BY a.genre
ORDER BY movie_count DESC;

 --output
 # genre, movie_count
'Drama', '16'
'Comedy', '8'
'Crime', '5'
'Horror', '5'
'Action', '4'
'Sci-Fi', '4'
'Thriller', '4'
'Romance', '3'
'Fantasy', '2'
'Mystery', '2'
'Family', '1'


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

SELECT c.title, b.avg_rating,a.genre
FROM genre  a 
INNER JOIN ratings b ON b.movie_id = a.movie_id
INNER JOIN movie AS c ON c.id = b.movie_id
WHERE c.title LIKE 'The%' AND b.avg_rating > 8
ORDER BY b.avg_rating DESC;


----output
# title, avg_rating, genre
'The Brighton Miracle', '9.5', 'Drama'
'The Colour of Darkness', '9.1', 'Drama'
'The Blue Elephant 2', '8.8', 'Drama'
'The Blue Elephant 2', '8.8', 'Horror'
'The Blue Elephant 2', '8.8', 'Mystery'
'The Irishman', '8.7', 'Crime'
'The Irishman', '8.7', 'Drama'
'The Mystery of Godliness: The Sequel', '8.5', 'Drama'
'The Gambinos', '8.4', 'Crime'
'The Gambinos', '8.4', 'Drama'
'Theeran Adhigaaram Ondru', '8.3', 'Action'
'Theeran Adhigaaram Ondru', '8.3', 'Crime'
'Theeran Adhigaaram Ondru', '8.3', 'Thriller'
'The King and I', '8.2', 'Drama'
'The King and I', '8.2', 'Romance'


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


 
SELECT b.median_rating, COUNT(b.movie_id) AS no_of_movie
FROM movie  a
INNER JOIN ratings  b ON b.movie_id = a.id
WHERE b.median_rating = 8 AND a.date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY b.median_rating
 
--output
# median_rating, no_of_movie
'8', '361'



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


WITH movie_lang AS
(
SELECT b.total_votes, a.languages
FROM movie AS a
INNER JOIN ratings AS b ON b.movie_id = a.id 
WHERE a.languages LIKE 'German' OR a.languages LIKE 'Italian'
GROUP BY languages
ORDER BY total_votes DESC
)
select 
CASE WHEN languages = 'German' THEN 'YES' ELSE 'NO' END as 'Do German movies get more votes than Italian movies' 
from movie_lang
where total_votes = ( select max(total_votes) from movie_lang)

---output
# total_votes, languages
'4695', 'German'
'1684', 'Italian'

# Do German movies get more votes than Italian movies
'YES'

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


	SELECT 
		SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls, 
		SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
		SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
		SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
		
FROM names;

---output
# name_nulls, height_nulls, date_of_birth_nulls, known_for_movies_nulls
'0', '17335', '13431', '15226'



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


WITH  TOPgenre AS
(
	SELECT a.genre, COUNT(a.movie_id) AS movie_count
	FROM genre a
	INNER JOIN ratings b ON b.movie_id = a.movie_id
	WHERE b.avg_rating > 8
    GROUP BY genre
    ORDER BY movie_count
    LIMIT 3
),

TOPdirector AS
(
SELECT aa.name AS director_name,
		COUNT(bb.movie_id) AS movie_count,
        ROW_NUMBER() OVER(ORDER BY COUNT(bb.movie_id) DESC) AS director_row_rank
FROM names AS aa 
INNER JOIN director_mapping bb ON  bb.name_id = aa.id 
INNER JOIN genre cc  ON cc.movie_id = bb.movie_id 
INNER JOIN ratings dd ON dd.movie_id = cc.movie_id
WHERE cc.genre in (select genre from TOPgenre  ) AND dd.avg_rating>8
GROUP BY director_name
ORDER BY movie_count DESC
)

SELECT  director_name, movie_count
FROM TOPdirector
WHERE director_row_rank <= 3
LIMIT 3;

----output for "top 3 director for top 3 genre"

# genre, movie_count
'Sci-Fi', '3'
'Fantasy', '3'
'Others', '10'


# director_name, movie_count
'Michael Powell', '1'
'Emeric Pressburger', '1'
'James Mangold', '1'




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

SELECT DISTINCT c.name AS actor_name, COUNT(a.movie_id) AS movie_count
FROM ratings a
INNER JOIN role_mapping b ON b.movie_id = a.movie_id
INNER JOIN names c ON c.id=b.name_id 
WHERE a.median_rating >= 8 AND b.category = 'actor'
GROUP BY name
ORDER BY movie_count DESC
LIMIT 2;

---output "top two actors whose movies have a median rating >= 8"
# actor_name, movie_count
'Mammootty', '8'
'Mohanlal', '5'





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

	
SELECT a.production_company, SUM(b.total_votes) AS vote_count,
		DENSE_RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie a
INNER JOIN ratings b ON b.movie_id = a.id  
GROUP BY a.production_company
LIMIT 3;

---output "top three production houses based on the number of votes received by their movies"
# production_company, vote_count, prod_comp_rank
'Marvel Studios', '2656967', '1'
'Twentieth Century Fox', '2411163', '2'
'Warner Bros.', '2396057', '3'




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

SELECT name AS actor_name, total_votes,
                COUNT(a.id) as movie_count,
                ROUND(SUM(b.avg_rating*total_votes)/SUM(b.total_votes),2) AS actor_avg_rating,
                RANK() OVER(ORDER BY b.avg_rating DESC) AS actor_rank
		
FROM movie a
INNER JOIN ratings b  ON  b.movie_id = a.id
INNER JOIN role_mapping c ON c.movie_id = b.movie_id
INNER JOIN names d ON d.id = c.name_id 
WHERE c.category='actor' AND a.country like 'india'
GROUP BY name
HAVING COUNT(a.id)>=5
LIMIT 1;

--output 
# actor_name, total_votes, movie_count, actor_avg_rating, actor_rank
'Vijay Sethupathi', '20364', '5', '8.42', '1'


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

SELECT name AS actress_name, total_votes,
                COUNT(a.id) as movie_count,
                ROUND(SUM(b.avg_rating*total_votes)/SUM(b.total_votes),2)  AS actress_avg_rating,
                RANK() OVER(ORDER BY b.avg_rating DESC) AS actress_rank
		
FROM movie a
INNER JOIN ratings b  ON  b.movie_id = a.id
INNER JOIN role_mapping c ON c.movie_id = b.movie_id
INNER JOIN names d ON d.id = c.name_id 
WHERE c.category='actress' 
AND country like '%india%' AND languages like '%hindi%'
GROUP BY name
HAVING COUNT(a.id)>=3
order by actress_avg_rating DESC
LIMIT 5;

---output
# actress_name, total_votes, movie_count, actress_avg_rating, actress_rank
'Taapsee Pannu', '2269', '3', '7.74', '2'
'Kriti Sanon', '14978', '3', '7.05', '1'
'Divya Dutta', '345', '3', '6.88', '3'
'Shraddha Kapoor', '3349', '3', '6.63', '5'
'Kriti Kharbanda', '1280', '3', '4.80', '4'



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT Title,
		CASE WHEN avg_rating > 8 THEN 'Superhit movies'
			 WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
             WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
			 WHEN avg_rating < 5 THEN 'Flop movies'
		END AS Category
FROM movie a
INNER JOIN genre b ON b.movie_id = a.id
INNER JOIN ratings c ON c.movie_id = b.movie_id
WHERE genre='Thriller';






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

SELECT b.genre,
		ROUND(AVG(a.duration) ) AS avg_duration,
        SUM(ROUND(AVG(a.duration) )) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
        AVG(ROUND(AVG(a.duration) )) OVER(ORDER BY genre ROWS 10 PRECEDING) AS moving_avg_duration
FROM movie a 
INNER JOIN genre b  ON  b.movie_id = a.id 
GROUP BY genre
ORDER BY genre;

---output
# genre, avg_duration, running_total_duration, moving_avg_duration
'Action', '113', '113', '113.0000'
'Adventure', '102', '215', '107.5000'
'Comedy', '103', '318', '106.0000'
'Crime', '107', '425', '106.2500'
'Drama', '107', '532', '106.4000'
'Family', '101', '633', '105.5000'
'Fantasy', '105', '738', '105.4286'
'Horror', '93', '831', '103.8750'
'Mystery', '102', '933', '103.6667'
'Others', '100', '1033', '103.3000'
'Romance', '110', '1143', '103.9091'
'Sci-Fi', '98', '1241', '102.5455'
'Thriller', '102', '1343', '102.5455'


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


	WITH Topgenre AS
( 	
	SELECT a.genre, COUNT(a.movie_id) AS number_of_movies
    FROM genre a
    INNER JOIN movie b ON  b.id = a.movie_id 
    GROUP BY genre
    ORDER BY COUNT(movie_id) DESC
    LIMIT 3
),

Topmovies AS
(
	SELECT genre,
			year,
			aa.title AS movie_name,
			aa.worlwide_gross_income,
			DENSE_RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
        
	FROM movie aa
    INNER JOIN genre bb  ON bb.movie_id = aa.id 
	WHERE genre IN (SELECT genre FROM Topgenre)
)

SELECT * FROM Topmovies WHERE movie_rank<=5;


----output
# genre, year, movie_name, worlwide_gross_income, movie_rank
'Drama', '2017', 'Shatamanam Bhavati', 'INR 530500000', '1'
'Drama', '2017', 'Winner', 'INR 250000000', '2'
'Drama', '2017', 'Thank You for Your Service', '$ 9995692', '3'
'Comedy', '2017', 'The Healer', '$ 9979800', '4'
'Drama', '2017', 'The Healer', '$ 9979800', '4'
'Thriller', '2017', 'Gi-eok-ui bam', '$ 9968972', '5'
'Thriller', '2018', 'The Villain', 'INR 1300000000', '1'
'Drama', '2018', 'Antony & Cleopatra', '$ 998079', '2'
'Comedy', '2018', 'La fuitina sbagliata', '$ 992070', '3'
'Drama', '2018', 'Zaba', '$ 991', '4'
'Comedy', '2018', 'Gung-hab', '$ 9899017', '5'
'Thriller', '2019', 'Prescience', '$ 9956', '1'
'Thriller', '2019', 'Joker', '$ 995064593', '2'
'Drama', '2019', 'Joker', '$ 995064593', '2'
'Comedy', '2019', 'Eaten by Lions', '$ 99276', '3'
'Comedy', '2019', 'Friend Zone', '$ 9894885', '4'
'Drama', '2019', 'Nur eine Frau', '$ 9884', '5'





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

SELECT production_company,
		COUNT(a.id) AS movie_count,
        ROW_NUMBER() OVER(ORDER BY count(a.id) DESC) AS prod_comp_rank
FROM movie a 
INNER JOIN ratings b  ON b.movie_id =a.id
WHERE b.median_rating>=8 AND a.production_company IS NOT NULL AND POSITION(',' IN languages)>0
GROUP BY production_company
LIMIT 2;

----output
# production_company, movie_count, prod_comp_rank
'Star Cinema', '7', '1'
'Twentieth Century Fox', '4', '2'






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

	SELECT name, SUM(c.total_votes) AS total_votes,
		COUNT(b.movie_id) AS movie_count,
		c.avg_rating,
        DENSE_RANK() OVER(ORDER BY avg_rating DESC) AS actress_rank
FROM names a
INNER JOIN role_mapping b ON  b.name_id = a.id
INNER JOIN ratings c ON c.movie_id = b.movie_id
INNER JOIN genre d ON d.movie_id = c.movie_id
WHERE b.category = 'actress' AND c.avg_rating > 8 AND d.genre = 'Drama'
GROUP BY name
LIMIT 3;

-----output
# name, total_votes, movie_count, avg_rating, actress_rank
'Sangeetha Bhat', '1010', '1', '9.6', '1'
'Fatmire Sahiti', '3932', '1', '9.4', '2'
'Adriana Matoshi', '3932', '1', '9.4', '2'





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


WITH Directors AS
 (
	 SELECT aa.name_id AS director_id,
		 name AS director_name, COUNT(aa.movie_id) AS number_of_movies,
		 null AS inter_movie_days,
		 ROUND(AVG(avg_rating)) AS avg_rating,  
         SUM(total_votes) AS total_votes,
		 MIN(avg_rating) AS min_rating,  MAX(avg_rating) AS max_rating,
		 SUM(duration) AS total_duration, 
         ROW_NUMBER() OVER(ORDER BY COUNT(aa.movie_id) DESC) AS director_row_rank
	 FROM
		 names xx 
         JOIN director_mapping  aa ON aa.name_id = xx.id
		 JOIN ratings AS bb ON bb.movie_id = aa.movie_id
		 JOIN movie AS cc ON cc.id = bb.movie_id
		 GROUP BY director_id
 )
 SELECT * FROM Directors  LIMIT 9;
----output
# director_id, director_name, number_of_movies, inter_movie_days, avg_rating, total_votes, min_rating, max_rating, total_duration, director_row_rank
'nm2096009', 'Andrew Jones', '5', ?, '3', '1989', '2.7', '3.2', '432', '1'
'nm1777967', 'A.L. Vijay', '5', ?, '5', '1754', '3.7', '6.9', '613', '2'
'nm6356309', 'Özgür Bakar', '4', ?, '4', '1092', '3.1', '4.9', '374', '3'
'nm2691863', 'Justin Price', '4', ?, '5', '5343', '3.0', '5.8', '346', '4'
'nm0814469', 'Sion Sono', '4', ?, '6', '2972', '5.4', '6.4', '502', '5'
'nm0831321', 'Chris Stokes', '4', ?, '4', '3664', '4.0', '4.6', '352', '6'
'nm0425364', 'Jesse V. Johnson', '4', ?, '5', '14778', '4.2', '6.5', '383', '7'
'nm0001752', 'Steven Soderbergh', '4', ?, '6', '171684', '6.2', '7.0', '401', '8'
'nm0515005', 'Sam Liu', '4', ?, '6', '28557', '5.8', '6.7', '312', '9'





