## Q1
## a. Display the first and last names of all actors from the table actor.
use sakila;

select first_name, last_name
from actor
order by last_name;

## b. Display the first and last name of each actor in a single column in upper case letters.
## Name the column Actor Name.
select concat(first_name, ' ', last_name) as 'Actor Name'
from actor

## Q2
## a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name
from actor
where first_name = 'Joe'

## b. Find all actors whose last name contain the letters GEN:
select actor_id, first_name, last_name
from actor
where last_name like '%gen%'

## c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select actor_id, first_name, last_name
from actor
where last_name like '%li%'
order by last_name, first_name

##d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country 
from country
where country in (
'Afghanistan', 
'Bangladesh', 
'China');

## Q3
/* a. You want to keep a description of each actor. You don't think you will be performing queries on a description,
so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, 
as the difference between it and VARCHAR are significant). */
alter table actor
add description BLOB;

## b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
alter table actor
drop description

## Q4
## a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) as namecount 
FROM actor 
GROUP BY last_name 
ORDER BY namecount;

## b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(*) as namecount 
FROM actor
where namecount != 1
GROUP BY last_name 
ORDER BY count DESC;

## c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
Update actor 
set first_name = 'harpo'
where actor_id in (
select actor_id
where first_name = 'groucho'
and last_name = 'williams'
);

## d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
Update actor 
set first_name = 'harpo'
where actor_id in (
select actor_id
where first_name = 'harpo'
and last_name = 'williams'
);

## Q5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
describe sakila.address

## Q6
## a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select s.first_name, s.last_name, a.address
from staff as s
left join address as a
on s.address_id = a.address_id;

## b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select s.first_name, s.last_name, sum(p.amount) as 'Aug 05 spend'
from staff as s
left join payment as p
on s.staff_id = p.staff_id
where year(p.payment_date) = 2005 and month(p.payment_date) = 8
group by s.first_name, s.last_name;

## 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT f.title, COUNT(a.actor_id) AS 'Actors Count'
FROM film f JOIN film_actor  a ON f.film_id = a.film_id
GROUP BY f.title;

## 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT f.title , f.film_id, count(i.inventory_id) as 'Appears in inventory'
FROM film f join inventory i on f.film_id = i.film_id
where f.title = 'Hunchback Impossible' ;

## 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT c.first_name, c.last_name, sum(p.amount) 
FROM customer c join payment p on c.customer_id = p.customer_id
group by c.first_name, c.last_name
order by c.last_name ;

## 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select title 
from film
WHERE (title LIKE 'K%' OR title LIKE 'Q%') 
AND language_id=(SELECT language_id FROM language where name='English');

## 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
    SELECT actor_id 
    FROM film_actor 
    WHERE film_id IN (
    SELECT film_id 
    from film 
    where title='ALONE TRIP')
    );
## 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT first_name, last_name, email , cn.country
FROM customer cu
JOIN address a ON (cu.address_id = a.address_id)
JOIN city ON (a.city_id=city.city_id)
JOIN country cn ON (city.country_id=cn.country_id)
where cn.country = 'Canada';

## 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT f.title, c.name
from film f
JOIN film_category fcat on (f.film_id=fcat.film_id)
JOIN category c on (fcat.category_id=c.category_id)
where c.name = 'family';

# 7e. Display the most frequently rented movies in descending order.
SELECT title, COUNT(f.film_id) AS 'Rented_Movies_Count'
FROM  film f
JOIN inventory i ON (f.film_id= i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
GROUP BY title ORDER BY Rented_Movies_Count DESC;

# 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, city, SUM(p.amount) as "business_dollars" 
FROM payment p
JOIN staff s ON (p.staff_id=s.staff_id)
JOIN address a ON (s.address_id=a.address_id)
JOIN city c ON (a.city_id=c.city_id)
GROUP BY store_id;

# 7g. Write a query to display for each store its store ID, city, and country.
SELECT store_id, city, country 
FROM store s
JOIN address a ON (s.address_id=a.address_id)
JOIN city c ON (a.city_id=c.city_id)
JOIN country cn ON (c.country_id=cn.country_id);

# 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT c.name AS "Top Five", SUM(p.amount) AS "Gross" 
FROM category c
JOIN film_category fc ON (c.category_id=fc.category_id)
JOIN inventory i ON (fc.film_id=i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
JOIN payment p ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;

# 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
create view top_five_genres as
SELECT c.name AS "Top Five", SUM(p.amount) AS "Gross" 
FROM category c
JOIN film_category fc ON (c.category_id=fc.category_id)
JOIN inventory i ON (fc.film_id=i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
JOIN payment p ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;

# 8b. How would you display the view that you created in 8a?
SELECT* FROM top_five_genres;

# 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_five_genres;

