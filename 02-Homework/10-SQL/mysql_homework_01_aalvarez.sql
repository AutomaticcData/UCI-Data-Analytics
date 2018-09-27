/*change to the proper database*/
USE SAKILA;

/*1a. Display the first and last names of all actors from the table actor.*/
SELECT 
 UPPER(first_name)							AS					'First Name'
,UPPER(last_name)							AS					'Last Name'
,CONCAT_WS(' ', first_name, last_name)		AS					'Full Name'
FROM			sakila.actor;

/*1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.*/
SELECT 
 CONCAT_WS(' ', first_name, last_name)		AS					'Actor Name'
FROM			sakila.actor;

/* 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
	What is one query would you use to obtain this information?*/
SELECT 
 actor_id									AS					'ID number'
,UPPER(first_name)							AS					'First Name'
,UPPER(last_name)							AS					'Last Name'
FROM			sakila.actor 
WHERE			first_name='Joe';


/* 2b. Find all actors whose last name contain the letters GEN:*/
SELECT
 UPPER(first_name)							AS					'First Name'
,UPPER(last_name)							AS					'Last Name'
FROM			sakila.actor
WHERE			last_name LIKE '%GEN%';

/* 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:*/
SELECT
 UPPER(first_name)							AS					'First Name'
,UPPER(last_name)							AS					'Last Name'
FROM			sakila.actor
WHERE			last_name LIKE '%LI%'
ORDER BY		last_name, first_name;

/* 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:*/
SELECT
 country_id					AS					'ID'
,country					AS					'Country'
FROM			sakila.country;

/* 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description
	, so create a column in the table actor named description and use the data type BLOB 
    (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).*/
/*select * from sakila.actor;*/
ALTER TABLE sakila.actor ADD(description blob);

/* 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.*/
ALTER TABLE sakila.actor DROP description;

/* 4a. List the last names of actors, as well as how many actors have that last name.*/
SELECT DISTINCT
 last_name					AS					'Last Name'
,COUNT(last_name)			AS					'Name Count'
FROM			sakila.actor
GROUP BY 		last_name;


/* 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors*/
SELECT DISTINCT 
 last_name					AS					'Last Name'
,COUNT(last_name)			AS					'Name Count'
FROM			sakila.actor
GROUP BY		last_name
HAVING COUNT	(last_name)>=2;

/* 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
	Write a query to fix the record.*/
/*
SELECT 
 actor_id
,first_name					AS					'First Name'
,last_name					AS					'Last Name'
FROM			sakila.actor
WHERE			first_name='GROUCHO';
*/

/*get the actor id into a reusable variable*/
SET @actorid = (SELECT actor_id	FROM	sakila.actor WHERE	first_name='GROUCHO' and last_name='WILLIAMS');

UPDATE sakila.actor SET first_name='HARPO' WHERE actor_id=@actorid;

/*verify the update*/
SELECT * FROM sakila.actor WHERE actor_id=@actorid;

/* 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
	It turns out that GROUCHO was the correct name after all! 
    In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.*/
UPDATE sakila.actor SET first_name='GROUCHO' WHERE actor_id=@actorid;

/*verify the update*/
SELECT * FROM sakila.actor WHERE actor_id=@actorid;

 
/* 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
	Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html*/
	SHOW CREATE TABLE sakila.address;

/*    
CREATE TABLE address (
  address_id smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  address varchar(50) NOT NULL,
  address2 varchar(50) DEFAULT NULL,
  district varchar(20) NOT NULL,
  city_id smallint(5) unsigned NOT NULL,
  postal_code varchar(10) DEFAULT NULL,
  phone varchar(20) NOT NULL,
  location geometry NOT NULL,
  last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (address_id),
  KEY idx_fk_city_id (city_id),
  SPATIAL KEY idx_location (location),
  CONSTRAINT fk_address_city FOREIGN KEY (city_id) REFERENCES city (city_id) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8
*/

/* 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:*/
SELECT
 UPPER(first_name)							AS					'First Name'
,UPPER(last_name)							AS					'Last Name'
,ADDR.address								AS					'Address'
FROM				sakila.staff			AS					STAFF
INNER JOIN			sakila.address			AS					ADDR			ON		STAFF.address_id = ADDR.address_id
;


/* 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.*/
/*SHOW FIELDS FROM sakila.payment;*/
SELECT
STAFF.staff_id
,SUM(PAY.amount)							AS					'Total Amount'
,CONCAT_WS(' ', first_name, last_name)		AS					'Staff Name'
FROM			sakila.staff				AS					STAFF
INNER JOIN		sakila.payment				AS					PAY			ON		STAFF.staff_id = PAY.staff_id
WHERE			PAY.payment_date >= '2005-08-01' 
AND				PAY.payment_date < '2005-09-01'
GROUP BY		STAFF.staff_id;


/* 6c. List each film and the number of actors who are listed for that film. 
Use tables film_actor and film. Use inner join.*/
#SHOW FIELDS FROM sakila.film_actor;
#SHOW FIELDS FROM sakila.film;

SELECT
 FILM.title											AS					'Movie'
,COUNT(ACTOR.actor_id)								AS					'Actor Count'
FROM 					sakila.film					AS					FILM
INNER JOIN				sakila.film_actor			AS					ACTOR			ON			FILM.film_id = ACTOR.film_id
GROUP BY FILM.title;
#SELECT COUNT(*) FROM 	sakila.film_actor 5462
/*SHOW FIELDS FROM sakila.film;*/


/* 6d. How many copies of the film Hunchback Impossible exist in the inventory system?*/
SET @hunchbackid = (SELECT film_id FROM sakila.film WHERE title='Hunchback Impossible');

SELECT 
COUNT(film_id)										AS					'Hunchback Count'
FROM 					sakila.inventory 
WHERE	film_id=@hunchbackid;


/* 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
	List the customers alphabetically by last name:*/
SELECT
 CONCAT_WS(' ', CUST.first_name, CUST.last_name)	AS					'Staff Name'
,SUM(PAY.amount)									AS					'Total Paid'
FROM					sakila.payment				AS					PAY
INNER JOIN				sakila.customer				AS					CUST			ON		PAY.customer_id = CUST.customer_id
GROUP BY CUST.customer_id
ORDER BY CUST.last_name
;

 
/* 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.*/
#SHOW FIELDS FROM sakila.language;
#SHOW FIELDS FROM sakila.film;
SET @languageid = (SELECT language_id FROM language WHERE name='English');
#select @languageid

SELECT 
 FILM.title											AS					'Movie Title'
,LANG.name											AS					'Language'
FROM					sakila.film					AS					FILM
INNER JOIN				sakila.language				AS					LANG			ON		FILM.language_id = LANG.language_id
WHERE FILM.language_id=@languageid
AND (FILM.title LIKE 'K%' OR FILM.title LIKE 'Q%')
ORDER BY FILM.title;


/* 7b. Use subqueries to display all actors who appear in the film Alone Trip.*/
SELECT
CONCAT_WS(' ', MOVIESTAR.first_name, MOVIESTAR.last_name)		AS					'Actor Name'
FROM					sakila.film					AS					FILM
INNER JOIN				sakila.film_actor			AS					ACTOR			ON			FILM.film_id = ACTOR.film_id
INNER JOIN				sakila.actor				AS					MOVIESTAR		ON			ACTOR.actor_id = MOVIESTAR.actor_id
WHERE	FILM.title='Alone Trip'
ORDER BY MOVIESTAR.last_name;


/* 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
Use joins to retrieve this information.*/
SET @canadaid = (SELECT country_id FROM sakila.country WHERE country='Canada');

SELECT
 CONCAT_WS(' ', CUST.first_name, CUST.last_name)	AS					'Customer Name'
,CUST.email											AS					'Email Address'
,CUST.*
,ADDR.*
FROM					sakila.customer				AS					CUST
INNER JOIN				sakila.address				AS					ADDR			ON		CUST.address_id = ADDR.address_id
INNER JOIN				sakila.city					AS					CITY			ON		ADDR.city_id = CITY.city_id
INNER JOIN				sakila.country				AS					COUNTRY			ON		CITY.country_id = COUNTRY.country_id
WHERE COUNTRY.country_id=@canadaid;


/* 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
Identify all movies categorized as family films.*/
SET @familycategory = (SELECT category_id FROM sakila.category WHERE name='Family');
SELECT
 FILM.title															AS					'Movie Title'
,FAM.name															AS					'Category'
FROM					sakila.film									AS					FILM
INNER JOIN				sakila.film_category						AS					CAT			ON		FILM.film_id = CAT.film_id
INNER JOIN				sakila.category								AS					FAM			ON		CAT.category_id = FAM.category_id
WHERE FAM.category_id=@familycategory
ORDER BY FILM.title;

/* 7e. Display the most frequently rented movies in descending order.*/
/*SELECT * FROM sakila.payment;		#--rental_id
SELECT * FROM sakila.rental;		#--inventory_id
SELECT * FROM sakila.inventory;		#--film_id
*/
SELECT #COUNT(*)
FILM.title															AS					'Movie Title'
,COUNT(FILM.film_id)												AS					'Rented'
FROM					sakila.rental								AS					RENTAL
INNER JOIN				sakila.inventory							AS					INV			ON		RENTAL.inventory_id = INV.inventory_id
INNER JOIN				sakila.film									AS					FILM		ON		INV.film_id = FILM.film_id
GROUP BY FILM.title
ORDER BY COUNT(FILM.film_id) DESC;


/* 7f. Write a query to display how much business, in dollars, each store brought in.*/
/*
select * from sakila.store			#--store_id, manager_staff_id
select * from sakila.payment		#staff_id
select * from sakila.staff			#--store_id, staff_id
*/
SELECT
 STORE.store_id														AS					'Store ID'
,SUM(PAY.amount)													AS					'Revenue'
FROM					sakila.payment								AS					PAY	
INNER JOIN				sakila.staff								AS					STAFF		ON		PAY.staff_id = STAFF.staff_id
INNER JOIN				sakila.store								AS					STORE		ON		STAFF.store_id = STORE.store_id
GROUP BY STORE.store_id;




/* 7g. Write a query to display for each store its store ID, city, and country.*/
/*
select * from sakila.store		#--address_id
select * from sakila.address	#--address_id
*/

SELECT 
 STORE.store_id										AS					'Store ID'
,CITY.city											AS					'City'
,COUNTRY.country									AS					'Country'
FROM					sakila.store				AS					STORE
INNER JOIN				sakila.address				AS					ADDR			ON		STORE.address_id = ADDR.address_id
INNER JOIN				sakila.city					AS					CITY			ON		ADDR.city_id = CITY.city_id
INNER JOIN				sakila.country				AS					COUNTRY			ON		CITY.country_id = COUNTRY.country_id
;

/* 7h. List the top five genres in gross revenue in descending order. 
(Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)*/
/*SELECT
COUNT(*)
FROM					sakila.film									AS					FILM
INNER JOIN				sakila.film_category						AS					CAT			ON		FILM.film_id = CAT.film_id
INNER JOIN				sakila.category								AS					FAM			ON		CAT.category_id = FAM.category_id
INNER JOIN				sakila.inventory							AS					INV			ON		FILM.film_id = INV.film_id
*/
#select count(*) from sakila.inventory --4581
#select * from sakila.payment

SELECT #COUNT(*)
#FILM.title															AS					'Movie Title'
#,COUNT(FILM.film_id)												AS					'Rented'
#COUNT(*)
 FAM.name															AS					'Movie Genre'
,COUNT(FILM.film_id)												AS					'Rented'
,SUM(PAY.amount)													AS					'Revenue'
FROM					sakila.rental								AS					RENTAL
INNER JOIN				sakila.inventory							AS					INV			ON		RENTAL.inventory_id = INV.inventory_id
INNER JOIN				sakila.film									AS					FILM		ON		INV.film_id = FILM.film_id
INNER JOIN				sakila.film_category						AS					CAT			ON		FILM.film_id = CAT.film_id
INNER JOIN				sakila.category								AS					FAM			ON		CAT.category_id = FAM.category_id
INNER JOIN				sakila.payment								AS					PAY			ON		RENTAL.rental_id = PAY.rental_id
GROUP BY FAM.name
ORDER BY COUNT(FILM.film_id) DESC, SUM(PAY.amount) DESC
LIMIT 5;




/* 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.*/
CREATE VIEW Top5GenresByRevenue AS
SELECT
 FAM.name															AS					'Movie Genre'
,COUNT(FILM.film_id)												AS					'Rented'
,SUM(PAY.amount)													AS					'Revenue'
FROM					sakila.rental								AS					RENTAL
INNER JOIN				sakila.inventory							AS					INV			ON		RENTAL.inventory_id = INV.inventory_id
INNER JOIN				sakila.film									AS					FILM		ON		INV.film_id = FILM.film_id
INNER JOIN				sakila.film_category						AS					CAT			ON		FILM.film_id = CAT.film_id
INNER JOIN				sakila.category								AS					FAM			ON		CAT.category_id = FAM.category_id
INNER JOIN				sakila.payment								AS					PAY			ON		RENTAL.rental_id = PAY.rental_id
GROUP BY FAM.name
ORDER BY COUNT(FILM.film_id) DESC, SUM(PAY.amount) DESC
LIMIT 5;

/* 8b. How would you display the view that you created in 8a?*/
SELECT * FROM Top5GenresByRevenue;


/* 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.*/
DROP VIEW Top5GenresByRevenue;













