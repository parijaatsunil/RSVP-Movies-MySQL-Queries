USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

/*-------------------------------------------------------------------
Q1 Code
-------------------------------------------------------------------*/

-- Counting rows in Director Mapping table
SELECT Count(*) AS Row_Count
FROM   director_mapping;
-- 3867 rows in Director_Mapping table

-- Counting rows in Genre table
SELECT Count(*) AS Row_Count
FROM   genre;
-- 14662 rows in Genre table

-- Counting rows in Movie table
SELECT Count(*) AS Row_Count
FROM   movie;
-- 7997 rows in Movie table

-- Counting rows in Names table
SELECT Count(*) AS Row_Count
FROM   names;
-- 25735 rows in Names table

-- Counting rows in Ratings table
SELECT Count(*) AS Row_Count
FROM   ratings;
-- 7997 rows in Ratings table

-- Counting rows in Role Mapping table
SELECT Count(*) AS Row_Count
FROM   role_mapping;
-- 15615 rows in Role_Mapping table   

/*-------------------------------------------------------------------
Q1 Response:
There are
- 3867 rows in Director_Mapping table
- 14662 rows in Genre table
- 7997 rows in Movie table
- 25735 rows in Names table
- 7997 rows in Ratings table
- 15615 rows in Role_Mapping table
-------------------------------------------------------------------*/

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

/*-------------------------------------------------------------------
Q2 Code
-------------------------------------------------------------------*/

/*
We can count the number of null values in each column in the Movie table
using case and is null.
*/


SELECT 
	Sum(CASE 	WHEN id IS NULL 						THEN 1 ELSE 0 END) AS id, 
	Sum(CASE 	WHEN title IS NULL 						THEN 1 ELSE 0 END) AS title, 
	Sum(CASE 	WHEN year IS NULL 						THEN 1 ELSE 0 END) AS year, 
	Sum(CASE 	WHEN date_published IS NULL 			THEN 1 ELSE 0 END) AS date_published, 
	Sum(CASE 	WHEN duration IS NULL 					THEN 1 ELSE 0 END) AS duration, 
	Sum(CASE 	WHEN country IS NULL 					THEN 1 ELSE 0 END) AS country, 
	Sum(CASE 	WHEN worlwide_gross_income IS NULL 		THEN 1 ELSE 0 END) AS worlwide_gross_income, 
	Sum(CASE 	WHEN languages IS NULL 					THEN 1 ELSE 0 END) AS languages, 
	Sum(CASE 	WHEN production_company IS NULL 		THEN 1 ELSE 0 END) AS production_company 
FROM movie;

/*-------------------------------------------------------------------
Q2 Response:
The below four columns have null values in the Movies table
- Country - 20 null values
- Worldwide_Gross_Income - 3724 null values
- Languages - 194 null values
- Production_company - 528 null values
-------------------------------------------------------------------*/

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

/*-------------------------------------------------------------------
Q3 Code
-------------------------------------------------------------------*/

/* 
For the first part of the question, we can extract year from date_published column, 
group by the extracted year, and aggregate the counts of number of movies. 
*/

SELECT Year(date_published) AS year,
       Count(id)            AS number_of_movies
FROM   movie
GROUP  BY Year(date_published)
ORDER  BY Year(date_published); 

/* 
For the second part of the question, we can extract month from date_published column, 
group by the extracted month, and aggregate the counts of number of movies. 
*/

SELECT Month(date_published) AS month_num,
       Count(id)             AS number_of_movies
FROM   movie
GROUP  BY Month(date_published)
ORDER  BY Month(date_published); 

/*-------------------------------------------------------------------
Q3 Response:
The highest number of movies were released in 
- the year 2017 - 3052 movies
- the month of March - 824 movies
-------------------------------------------------------------------*/

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

/*-------------------------------------------------------------------
Q4 Code
-------------------------------------------------------------------*/

/*
We can use group by country and count the number of movies for the year 2019.
*/

SELECT Count(id) AS movie_count
FROM   movie
WHERE  Year(date_published) = 2019
       AND ( country LIKE '%USA%'
              OR country LIKE '%India%' ); 

/*-------------------------------------------------------------------
Q4 Response:
There were 1059 movies produced in USA or India.
-------------------------------------------------------------------*/

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

/*-------------------------------------------------------------------
Q5 Code
-------------------------------------------------------------------*/

/*
We can use distinct list of genre to display the required list.
*/

SELECT DISTINCT genre
FROM   genre; 

/*-------------------------------------------------------------------
Q5 Response:
The available genres are
- Drama
- Fantasy
- Thriller
- Comedy
- Horror
- Family
- Romance
- Adventure
- Action
- Sci-Fi
- Crime
- Mystery
- Others
-------------------------------------------------------------------*/

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

/*-------------------------------------------------------------------
Q6 Code
-------------------------------------------------------------------*/

/*
We can get the count of movies grouped by genre using left join based on movie_id 
column in genre table and id column in movie table.
We can further order the output based on descending order of the count of movies.
*/

SELECT gen.genre,
       Count(mov.id) AS movie_count
FROM   genre AS gen
       LEFT JOIN movie AS mov
               ON gen.movie_id = mov.id
GROUP  BY gen.genre
ORDER  BY Count(mov.id) DESC; 

/*-------------------------------------------------------------------
Q6 Response:
Most movies were produced from the below genres
- Drama - 4285 movies
- Comedy - 2412 movies
- Thriller - 1484 movies
-------------------------------------------------------------------*/


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

/*-------------------------------------------------------------------
Q7 Code
-------------------------------------------------------------------*/

/*
We can use a nested query to first generate a list of all movies with 1 genre
by grouping by movie_id and using the having function.
We can then count the number of movie_id which is in this generated list.
*/

SELECT Count(movie_id)
FROM   genre
WHERE  movie_id IN (SELECT movie_id
                    FROM   genre
                    GROUP  BY movie_id
                    HAVING Count(movie_id) = 1); 

/*-------------------------------------------------------------------
Q7 Response:
There are 3289 movies having a single genre.
-------------------------------------------------------------------*/


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

/*-------------------------------------------------------------------
Q8 Code
-------------------------------------------------------------------*/

/*
We can get the average duration of movies grouped by genre using left join based on movie_id column in
genre table and id column in movie table. We wull round the averate duration to 2 decimal places and 
order the output based on descending order of the average duration.
*/

SELECT gen.genre,
       Round(Avg(mov.duration), 2) AS avg_duration
FROM   genre AS gen
       LEFT JOIN movie AS mov
              ON gen.movie_id = mov.id
GROUP  BY gen.genre
ORDER  BY Avg(mov.duration) DESC; 

/*-------------------------------------------------------------------
Q8 Response:
The genres with the highest average duration are
- Action - 112.88 minutes
- Romance - 109.53 minutes
- Crime - 107.05 minutes
-------------------------------------------------------------------*/


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

/*-------------------------------------------------------------------
Q9 Code
-------------------------------------------------------------------*/

/*
We can use the rank over function to get the ranks of all genres by
count to answer this question.
*/

SELECT gen.genre,
       Count(mov.id)                    		AS movie_count,
       Rank() OVER(ORDER BY Count(mov.id) DESC) AS genre_rank
FROM   genre AS gen
       LEFT JOIN movie AS mov
              ON gen.movie_id = mov.id
GROUP  BY gen.genre
ORDER  BY Count(mov.id) DESC;  

/*-------------------------------------------------------------------
Q9 Response:
Thriller is ranked third in the list of genres by movie count.
-------------------------------------------------------------------*/

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

/*-------------------------------------------------------------------
Q10 Code
-------------------------------------------------------------------*/

/*
We can use the max and min functions over the avg ratings, votes
and median ratings columns to get the required output
*/

SELECT Round(Min(avg_rating))    AS min_avg_rating,
       Round(Max(avg_rating))    AS max_avg_rating,
       Min(total_votes)          AS min_total_votes,
       Max(total_votes)          AS max_total_votes,
       Round(Min(median_rating)) AS min_median_rating,
       Round(Max(median_rating)) AS max_median_rating
FROM   ratings; 

/*-------------------------------------------------------------------
Q10 Response:
The table is created as below:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|max_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		1		|			10		|	       100		  |	   725138    		 |		1	       |	10			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
-------------------------------------------------------------------*/

 

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

/*-------------------------------------------------------------------
Q11 Code
-------------------------------------------------------------------*/

/*
We can use the row number function to get the list of movies ranked by
avg rating after using inner join on movie and ratings tables. We can
use where function to get the top 10 ranked movies.
Further we will attempt to use the where function with nested query
to ensure that we follow the best practices of coding

Note: Using rank <= 10 gives us a list of 14 movies, and using 
dense_rank gives us a list of 40 movies! Hence, using the row number
function is the way forward here.
*/

SELECT title,
       avg_rating,
       movie_rank
FROM   (SELECT mov.title                     					AS title,
               rat.avg_rating                					AS avg_rating,
               Row_number() OVER( ORDER BY avg_rating DESC) 	AS movie_rank
        FROM   ratings AS rat
               INNER JOIN movie AS mov
                       ON rat.movie_id = mov.id) 				AS movie_ratings
WHERE  movie_rank <= 10; 

/*-------------------------------------------------------------------
Q11 Response:
The top 10 ranked movies by avg rating are:
- Kirket
- Love in Kilnerry
- Gini Helida Kathe
- Runam
- Fan
- Android Kunjappan Version 5.25
- Yeh Suhaagraat Impossible
- Safe
- The Brighton Miracle
- Shibu
-------------------------------------------------------------------*/

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

/*-------------------------------------------------------------------
Q12 Code
-------------------------------------------------------------------*/

/*
We can use the group by function over median rating aggregating
the count of movie ids to get the required output. We can order
by median rating to get the output in increasing order of rating.
*/

SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY median_rating; 

/*-------------------------------------------------------------------
Q12 Response:
Most movies have a median rating of 7.
-------------------------------------------------------------------*/


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

/*-------------------------------------------------------------------
Q13 Code
-------------------------------------------------------------------*/

/*
Starting with a inner join between the movie and ratings tables, we 
can use the where function to restrict the avg rating higher than 8
and display the movie count by grouping by production house. Further
we can use dense rank to get a ranked list of production houses.
*/

SELECT mov.production_company             						AS production_company,
               count(mov.id)                					AS movie_count,
               dense_rank() OVER( ORDER BY count(mov.id) DESC) 	AS movie_rank
        FROM   ratings AS rat
               INNER JOIN movie AS mov
                       ON rat.movie_id = mov.id
		where avg_rating >= 8
        group by production_company;

/*-------------------------------------------------------------------
Q13 Response:
The production companies with the most number of hit movies are
Dream Warrior Pictures and National Theatre Live.

However, most hit movies do not have a production company listed in the
database.
-------------------------------------------------------------------*/


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

/*-------------------------------------------------------------------
Q14 Code
-------------------------------------------------------------------*/

/*
Starting with a inner join between the movie, genre and ratings tables, 
we can use the where function to apply the required filters of month,
year, country and number of votes. Further we can then display the movie 
count by grouping by genre.
*/

SELECT gen.genre,
       Count(mov.id) AS movie_count
FROM   ratings AS rat
       INNER JOIN movie AS mov
               ON rat.movie_id = mov.id
       INNER JOIN genre AS gen
               ON mov.id = gen.movie_id
WHERE  ( Month(mov.date_published) = 3
         AND Year(mov.date_published) = 2017
         AND mov.country = 'USA'
         AND rat.total_votes > 1000)
GROUP  BY gen.genre; 
 
/*-------------------------------------------------------------------
Q14 Response:
The number of movies released in March 2017 from USA with more than
1000 votes for each genre are:
- Action		4
- Comedy		8
- Crime			5
- Drama			16
- Fantasy		2
- Mystery		2
- Romance		3
- Sci-Fi		4
- Thriller		4
- Horror		5
- Family		1
-------------------------------------------------------------------*/


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


/*-------------------------------------------------------------------
Q15 Code
-------------------------------------------------------------------*/

/*
Starting with a inner join between the movie, genre and ratings tables, 
we can use the where function to apply the required filters of title 
starting with the letters "the" using regular expressions and avg 
rating greater than 8.
*/

SELECT mov.title,
       rat.avg_rating,
       gen.genre
FROM   ratings AS rat
       INNER JOIN movie AS mov
               ON rat.movie_id = mov.id
       INNER JOIN genre AS gen
               ON mov.id = gen.movie_id
WHERE  mov.title REGEXP '^the'
       AND rat.avg_rating > 8;
 
/*-------------------------------------------------------------------
Q15 Response:
The movies with names starting with the word "the" and having avg
rating greater than 8 are:
- The Blue Elephant 2
- The Brighton Miracle
- The Irishman
- The Colour of Darkness
- Theeran Adhigaaram Ondru
- The Mystery of Godliness: The Sequel
- The Gambinos
- The King and I
-------------------------------------------------------------------*/

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

/*-------------------------------------------------------------------
Q16 Code
-------------------------------------------------------------------*/

/*
Starting with a inner join between the movie and ratings tables, 
we can use the where function to apply the required filters of release
dates and median rating equal to 8.
*/

SELECT Count(mov.title)
FROM   ratings AS rat
       INNER JOIN movie AS mov
               ON rat.movie_id = mov.id
WHERE  mov.date_published BETWEEN '2018-04-01' AND '2019-04-01'
       AND rat.median_rating = 8; 

/*-------------------------------------------------------------------
Q16 Response:
There were 361 movies released between 1 April 2018 and 1 April 2019
with a median rating of 8.
-------------------------------------------------------------------*/

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

/*-------------------------------------------------------------------
Q17 Code
-------------------------------------------------------------------*/

/*
Note: To answer this question, we are considering that the German and 
Italian movies are considered from the languages column.

We can find the union of 2 queries:
1st query to find the sum of total votes by finding movies having the 
language German using the where and like functions.
2nd query, we can use a similar method as above to find sum of total
votes by finding movies having the language as Italian.
*/


(SELECT "german"         AS movie_language,
        Sum(total_votes) AS Total_votes
 FROM   ratings AS rat
        INNER JOIN movie AS mov
                ON rat.movie_id = mov.id
 WHERE  languages LIKE '%German%')
UNION
(SELECT "italian"        AS movie_language,
        Sum(total_votes) AS italian_votes
 FROM   ratings AS rat
        INNER JOIN movie AS mov
                ON rat.movie_id = mov.id
 WHERE  languages LIKE '%Italian%'); 




/*-------------------------------------------------------------------
Q17 Response:
Considering the languages column, German movies received 4421525 votes,
whereas Italian movies received 2559540 votes. Hence, yes, German movies
get more votes than Italian movies
-------------------------------------------------------------------*/






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

/*-------------------------------------------------------------------
Q18 Code
-------------------------------------------------------------------*/

/*
We can use case and is null to find the number of null values in each
column in the names table. We can skip the id column as it is the primary
key.
*/


SELECT 
	Sum(CASE 	WHEN name IS NULL 				THEN 1 ELSE 0 END) AS name_nulls, 
	Sum(CASE 	WHEN height IS NULL 			THEN 1 ELSE 0 END) AS height_nulls, 
	Sum(CASE 	WHEN date_of_birth IS NULL 		THEN 1 ELSE 0 END) AS date_of_birth_nulls, 
	Sum(CASE 	WHEN known_for_movies IS NULL 	THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;




/*-------------------------------------------------------------------
Q18 Response:
The number of null values in each of the columns in the names table
are as per the below table
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|		17335		|	      13431		  |	   15226	    	 |
+---------------+-------------------+---------------------+----------------------+
-------------------------------------------------------------------*/






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

/*-------------------------------------------------------------------
Q19 Code
-------------------------------------------------------------------*/

/*
We can solve this in 3 steps:
Step 1: Using a CTE, create a ranked list of genre based on the count of movies where
avg rating is over 8, after using inner join on ratings and genre table.
Step 2: Using a CTE, create a ranked list of directors based on the count of movies
including filters for avg rating over 8 and genre belonging in the top 3 ranks of the
table from the previous CTE. For this we will have to inner join ratings, genre and 
director mapping and names tables.
Step 3: List the director names where the rank is lesser or equal to 3.
*/

WITH top_genre
     AS (SELECT gen.genre,
                Row_number() OVER(ORDER BY Count(gen.movie_id) DESC) 	AS genre_rank
         FROM   ratings AS rat
                INNER JOIN genre AS gen
                        ON gen.movie_id = rat.movie_id
         WHERE  rat.avg_rating > 8
         GROUP  BY gen.genre),
     full_dir_list
     AS (SELECT nam.name as director_name,
                Count(gen.movie_id)                    					AS movie_count,
                Row_number() OVER(ORDER BY Count(gen.movie_id) DESC) 	AS dir_rank
         FROM   ratings AS rat
                INNER JOIN genre AS gen
                        ON gen.movie_id = rat.movie_id
                INNER JOIN director_mapping AS dir
                        ON gen.movie_id = dir.movie_id
                INNER JOIN names AS nam
                        ON dir.name_id = nam.id
         WHERE  rat.avg_rating > 8
                AND gen.genre IN (SELECT genre
                                  FROM   top_genre
                                  WHERE  genre_rank <= 3)
         GROUP  BY nam.NAME)
SELECT director_name,
       movie_count
FROM   full_dir_list
WHERE  dir_rank <= 3; 



/*-------------------------------------------------------------------
Q19 Response:
The top 3 directors in the top 3 genres with avg rating greater than 8
are
1. James Mangold - 4 movies
2. Anthony Russo - 3 movies
3. Joe Russo - 3 movies

Note- The director Soubin Shahir also has 3 movies in the above list,
but the name was omitted as we used row_number and not rank or dense_rank.
-------------------------------------------------------------------*/

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

/*-------------------------------------------------------------------
Q20 Code
-------------------------------------------------------------------*/

/*
We can use a CTE to create a ranked list of actors by movie counts
with median rating greater than or equal to 8 and the category as actor.
Using this CTE, we can list the top 2 actors and the movie counts
*/

WITH full_act_list
     AS (SELECT nam.NAME                         				AS actor_name,
                Count(mov.id)                    				AS movie_count,
                Row_number() OVER(ORDER BY Count(mov.id) DESC) 	AS actor_rank
         FROM   movie AS mov
                INNER JOIN ratings AS rat
                        ON mov.id = rat.movie_id
                INNER JOIN role_mapping AS rol
                        ON mov.id = rol.movie_id
                INNER JOIN names AS nam
                        ON rol.name_id = nam.id
         WHERE  rat.median_rating >= 8
                AND rol.category = 'actor'
         GROUP  BY nam.NAME)
SELECT actor_name,
       movie_count
FROM   full_act_list
WHERE  actor_rank <= 2; 


/*-------------------------------------------------------------------
Q20 Response:
The top 2 actors with the highest count of movies with median rating
greater than or equal to 8 are:
1. Mammootty - 8 movies
2. Mohanlal - 5 movies
-------------------------------------------------------------------*/


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

/*-------------------------------------------------------------------
Q21 Code
-------------------------------------------------------------------*/

/*
We can use a CTE to create a ranked list of production companies sorted
by total votes. To find the top 3 we can run a query on the created CTE
using a where statement.
*/

WITH prod_rank
     AS (SELECT mov.production_company,
                Sum(rat.total_votes)                    			AS vote_count,
                Rank() OVER(ORDER BY Sum(rat.total_votes) DESC) 	AS prod_comp_rank
         FROM   movie AS mov
                INNER JOIN ratings AS rat
                        ON mov.id = rat.movie_id
         GROUP  BY mov.production_company)
SELECT production_company,
       vote_count,
       prod_comp_rank
FROM   prod_rank
WHERE  prod_comp_rank <= 3; 


/*-------------------------------------------------------------------
Q21 Response:
The top 3 production companies with movies havinng the highest vote count 
are:
+------------------------+------------------+---------------------+
|production_company		 |vote_count		|		prod_comp_rank|
+------------------------+------------------+---------------------+
|Marvel Studios			 |		2656967		|		1	  		  |
|Twentieth Century Fox	 |		2411163		|		2			  |
|Warner Bros.			 |		2396057		|		3			  |
+------------------------+------------------+---------------------+
-------------------------------------------------------------------*/








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

/*-------------------------------------------------------------------
Q22 Code
-------------------------------------------------------------------*/

/*
After joining the movie, ratings, role_mapping and names tables, we can
display the required information including name of actor, sum of total votes,
count of movies and the weighted average rounded to 2 decimal places, and the
rank of the actors. The query can be filtered with country containing India and
category as actor, and grouped by the actor name having number of movies greater
than or equal to 5.
*/

SELECT nam.NAME 																													AS actor_name,
       Sum(rat.total_votes) 																										AS total_votes,
       Count(mov.id) 																												AS movie_count,
       Round(Sum(rat.avg_rating * rat.total_votes) / Sum(rat.total_votes), 2)       												AS actor_avg_rating,
       Rank() OVER(ORDER BY Round(Sum(rat.avg_rating * rat.total_votes)/Sum(rat.total_votes), 2) DESC, Sum(rat.total_votes) DESC)	AS actor_rank
FROM   movie AS mov
       INNER JOIN ratings AS rat
               ON mov.id = rat.movie_id
       INNER JOIN role_mapping AS rol
               ON mov.id = rol.movie_id
       INNER JOIN names AS nam
               ON rol.name_id = nam.id
WHERE  mov.country LIKE '%India%'
       AND rol.category = 'actor'
GROUP  BY nam.NAME
HAVING movie_count >= 5; 

/*-------------------------------------------------------------------
Q22 Response:
Vijay Sethupathi is the highest ranked actor.
The top 3 actors by weighted average with count of movies greater than or equal to 5 are:
+-------------------+-------------------+---------------------+----------------------+-----------------+
| actor_name		|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+-------------------+-------------------+---------------------+----------------------+-----------------+
|Vijay Sethupathi	|			23114	|	       5		  |	   8.42	    		 |		1	       |
|Fahadh Faasil		|			13557	|	       5		  |	   7.99	    		 |		2	       |
|Yogi Babu			|			8500	|	       11		  |	   7.83	    		 |		3	       |
+-------------------+-------------------+---------------------+----------------------+-----------------+
-------------------------------------------------------------------*/

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

/*-------------------------------------------------------------------
Q23 Code
-------------------------------------------------------------------*/

/*
We can create a CTE where after joining the movie, ratings, role_mapping and names
tables, we can display the required information including name of actress, sum of 
total votes, count of movies and the weighted average rounded to 2 decimal places,
and the rank of the actresses. The query can be filtered with Hindi language and
category as actresses, and grouped by the actor name having number of movies greater
than or equal to 3. Finally we can call the required columns with rank lesser than
or equal to 5 to find the top 5 actresses
*/

WITH actress_details
     AS (SELECT nam.NAME 																													AS actress_name,
                Sum(rat.total_votes)																										AS total_votes,
                Count(mov.id) 																												AS movie_count,
                Round(Sum(rat.avg_rating * rat.total_votes) / Sum(rat.total_votes), 2) 														AS actress_avg_rating,
                Rank() OVER(ORDER BY Round(Sum(rat.avg_rating * rat.total_votes)/Sum(rat.total_votes), 2) DESC, Sum(rat.total_votes) DESC) 	AS actress_rank
         FROM   movie AS mov
                INNER JOIN ratings AS rat
                        ON mov.id = rat.movie_id
                INNER JOIN role_mapping AS rol
                        ON mov.id = rol.movie_id
                INNER JOIN names AS nam
                        ON rol.name_id = nam.id
         WHERE  mov.languages LIKE '%Hindi%'
                AND rol.category = 'actress'
         GROUP  BY nam.NAME
         HAVING movie_count >= 3)
SELECT actress_name,
       total_votes,
       movie_count,
       actress_avg_rating,
       actress_rank
FROM   actress_details
WHERE  actress_rank <= 5; 

/*-------------------------------------------------------------------
Q23 Response:
Taapsee Pannu is the top actress by weighted average.
The top 5 actresses by weighted average with count of movies greater than or equal to 3 are
+-------------------+-------------------+---------------------+----------------------+-----------------+
| actress_name		|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+-------------------+-------------------+---------------------+----------------------+-----------------+
|Taapsee Pannu 		|			18061	|	       3		  |	   7.74	    		 |		1	       |
|Kriti Sanon		|			21967	|	       3		  |	   7.05	    		 |		2	       |
|Divya Dutta		|			8579	|	       3		  |	   6.88	    		 |		3	       |
|Shraddha Kapoor	|			26779	|	       3		  |	   6.63	    		 |		4	       |
|Kriti Kharbanda	|			2549	|	       3		  |	   4.80	    		 |		5	       |
+-------------------+-------------------+---------------------+----------------------+-----------------+
-------------------------------------------------------------------*/


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

/*-------------------------------------------------------------------
Q24 Code
-------------------------------------------------------------------*/

/*
After using inner join on movie, ratings and genre tables, we can create
the above classifications for all movies by using case functions. The 
query can then be filtered by the Thriller genre
*/

SELECT gen.genre,
       mov.id         AS movie_id,
       mov.title      AS movie_title,
       rat.avg_rating AS average_rating,
       CASE
         WHEN rat.avg_rating > 8 THEN 'Superhit movies'
         WHEN rat.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN rat.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         ELSE 'Flop movies'
       end            AS movie_classification
FROM   movie AS mov
       INNER JOIN ratings AS rat
               ON mov.id = rat.movie_id
       INNER JOIN genre AS gen
               ON mov.id = gen.movie_id
WHERE  gen.genre = 'Thriller'; 

/*-------------------------------------------------------------------
Q24 Response:
All movies in the Thriller genre have been classified based on their
average rating as per the specified categories.
-------------------------------------------------------------------*/

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

/*-------------------------------------------------------------------
Q25 Code
-------------------------------------------------------------------*/

/*
After using inner join on movie and genre tables, we can display the 
average of movie duration, running total of duration using sum over 
function and moving average using average over function. The query can
be grouped by the genre column to get the required output.
*/

SELECT gen.genre,
       Round(Avg(mov.duration), 0)   							AS avg_duration,
       Round(Sum(Avg(mov.duration)) OVER(ORDER BY genre), 1) 	AS running_total_duration,
       Round(Avg(Avg(mov.duration)) OVER(ORDER BY genre), 2) 	AS moving_avg_duration
FROM   movie AS mov
       INNER JOIN genre AS gen
               ON mov.id = gen.movie_id
GROUP  BY gen.genre
order by gen.genre; 

/*-------------------------------------------------------------------
Q25 Response:
The average duration, running total duration and moving average of duration
for each genre is as below:
Genre		avg_duration	running_total_duration	moving_avg_duration
Action			113					112.9					112.88
Adventure		102					214.8					107.38
Comedy			103					317.4					105.79
Crime			107					424.4					106.11
Drama			107					531.2					106.24
Family			101					632.2					105.36
Fantasy			105					737.3					105.33
Horror			93					830.0					103.75
Mystery			102					931.8					103.54
Others			100					1032.0					103.20
Romance			110					1141.5					103.78
Sci-Fi			98					1239.5					103.29
Thriller		102					1341.0					103.16

Note: The values have been rounded as per the output format.
-------------------------------------------------------------------*/

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

/*-------------------------------------------------------------------
Q26 Code
-------------------------------------------------------------------*/

/*
We will have to use three CTEs to store tables containing genre by rank,
corrected gross income and movie rank. We have used currency conversion
of 1 USD = 83 INR for the response to this question.
*/


WITH genre_rank
     AS (SELECT gen.genre,
                Row_number()
                  OVER(
                    ORDER BY Count(mov.id) DESC) AS gen_rank
         FROM   genre AS gen
                LEFT JOIN movie AS mov
                       ON gen.movie_id = mov.id
         GROUP  BY gen.genre
         ORDER  BY Count(mov.id) DESC),
     movie_income_correct
     AS (SELECT gen.genre,
                mov.year,
                mov. title AS movie_name,
                CASE
                  WHEN mov.worlwide_gross_income LIKE 'INR%' THEN
                  Concat('$ ', Round(
                  Substring(mov.worlwide_gross_income, 5) / 83))
                  ELSE mov.worlwide_gross_income
                END        AS worldwide_gross_income
         FROM   movie AS mov
                INNER JOIN genre AS gen
                        ON mov.id = gen.movie_id
         WHERE  gen.genre IN (SELECT genre
                              FROM   genre_rank
                              WHERE  gen_rank <= 3)),
     movie_income_rank
     AS (SELECT genre,
                movie_name,
                worldwide_gross_income,
                Row_number()
                  OVER(
                    partition BY year
                    ORDER BY worldwide_gross_income DESC) AS movie_rank
         FROM   movie_income_correct)
SELECT genre,
       movie_name,
       worldwide_gross_income,
       movie_rank
FROM   movie_income_rank
WHERE  movie_rank <= 5; 



/*-------------------------------------------------------------------
Q26 Response:
The top 5 movies by worldwide gross income from the top 3 genres are
as per the output of the above query.
-------------------------------------------------------------------*/








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

/*-------------------------------------------------------------------
Q27 Code
-------------------------------------------------------------------*/

/*
Using a CTE which ranks the production companies by count of movies and
filters the query with median rating >= 8, has the character "," to show
multilingual movies, and where the production house is not null, we can 
query the top 2 production houses by movie_count.
*/


WITH prod_house_rank
     AS (SELECT mov.production_company,
                Count(mov.id)                    AS movie_count,
                Row_number()
                  OVER (
                    ORDER BY Count(mov.id) DESC) AS prod_comp_rank
         FROM   movie AS mov
                INNER JOIN ratings AS rat
                        ON mov.id = rat.movie_id
         WHERE  rat.median_rating >= 8
                AND POSITION(',' IN languages)>0
                AND production_company IS NOT NULL
         GROUP  BY mov.production_company)
SELECT production_company,
       movie_count,
       prod_comp_rank
FROM   prod_house_rank
WHERE  prod_comp_rank <= 2; 

/*-------------------------------------------------------------------
Q27 Response:
The top two production houses that have produced the highest number of
hits in multilingual movies are Star Cinema with 7 movies and Twentieth
Century Fox with 4 movies.
-------------------------------------------------------------------*/






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


/*-------------------------------------------------------------------
Q28 Code
-------------------------------------------------------------------*/

/*
Using a CTE which ranks the actresses by count of movies and filters the
query with average rating > 8, role category as actress and genre as drama
from joining the movie, ratings, genre, role_mapping and names tables
we can query the top 3 actresses by movie_count.
*/


WITH actress_rank_details
     AS (SELECT nam.NAME 																													AS actress_name,
                Sum(rat.total_votes)																										AS total_votes,
                Count(mov.id) 																												AS movie_count,
                Round(avg(rat.avg_rating), 2) 																								AS actress_avg_rating,
                ROW_NUMBER() OVER(ORDER BY count(mov.id) DESC)				 																AS actress_rank
         FROM   movie AS mov
                INNER JOIN ratings AS rat
                        ON mov.id = rat.movie_id
				INNER JOIN genre AS gen
						ON mov.id = gen.movie_id
                INNER JOIN role_mapping AS rol
                        ON mov.id = rol.movie_id
                INNER JOIN names AS nam
                        ON rol.name_id = nam.id
         WHERE  avg_rating > 8
                AND rol.category = 'actress'
                AND gen.genre = 'Drama'
         GROUP  BY nam.NAME)
SELECT actress_name,
       total_votes,
       movie_count,
       actress_avg_rating,
       actress_rank
FROM   actress_rank_details
WHERE  actress_rank <= 3; 



/*-------------------------------------------------------------------
Q28 Response:
The top three actresses with the highest movie counts with average rating
higher than 8 are Parvathy Thiruvothu, Susan Brown. and Amanda Lawrence with
2 movies each.
-------------------------------------------------------------------*/





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


/*-------------------------------------------------------------------
Q29 Code
-------------------------------------------------------------------*/

/*
Creating 3 CTEs to place the date of the next movie partitioned by director,
finding the date difference between the 2 dates and ranking the directors 
based on number of movies, we can then display the required information using
a query calling the CTEs as required.
*/


WITH movie_date_calc AS (
    SELECT
        nam.id AS director_id,
        nam.name AS director_name,
        mov.id AS movie_id,
        mov.date_published AS movie_date,
        LEAD(mov.date_published, 1) OVER (PARTITION BY nam.name ORDER BY mov.date_published) AS next_movie_date
    FROM
    movie as mov
    INNER JOIN
        director_mapping as dir ON mov.id = dir.movie_id
    INNER JOIN
        names as nam ON dir.name_id = nam.id
), 
avg_date_diff as(
SELECT
    director_id,
    director_name,
    AVG(DATEDIFF(next_movie_date, movie_date)) AS avg_inter_movie_days
FROM
    movie_date_calc
GROUP BY
    director_id, director_name),
director_ranking as(
SELECT
        nam.id AS director_id,
        nam.name AS director_name,
        COUNT(DISTINCT dir.movie_id) AS number_of_movies,
        ROUND(AVG(rat.avg_rating), 2) AS avg_rating,
        SUM(rat.total_votes) AS total_votes,
        MIN(rat.avg_rating) AS min_rating,
        MAX(rat.avg_rating) AS max_rating,
        SUM(mov.duration) AS total_duration,
        ROW_NUMBER() OVER (ORDER BY COUNT(dir.movie_id) DESC) AS director_rank
    FROM
        names as nam
    INNER JOIN
        director_mapping as dir ON nam.id = dir.name_id
    INNER JOIN
        movie as mov ON dir.movie_id = mov.id
    INNER JOIN
        ratings as rat ON mov.id = rat.movie_id
    GROUP BY
        director_id, director_name
)
SELECT
    dirnk.director_id,
    dirnk.director_name,
    dirnk.number_of_movies,
    addif.avg_inter_movie_days AS avg_inter_movie_days,
    dirnk.avg_rating,
    dirnk.total_votes,
    dirnk.min_rating,
    dirnk.max_rating,
    dirnk.total_duration
FROM
    director_ranking as dirnk
LEFT JOIN
    avg_date_diff as addif ON dirnk.director_id = addif.director_id
WHERE
    dirnk.director_rank <= 9;



/*-------------------------------------------------------------------
Q29 Response:
The details of the top nine directors are available as output of the
above query.
-------------------------------------------------------------------*/




