

----------------------------
-- Week 5 - Thursday Questions
----------------------------

-------------------------------------------------------------------------------------------
--1. Create a Stored Procedure that will insert a new film into the film table with the
--following arguments: title, description, release_year, language_id, rental_duration,
--rental_rate, length, replace_cost, rating

select *
from film;

-- create Stored Procedure

-- Working
create or replace procedure add_new_film(
	title VARCHAR, 
	description TEXT, 
	release_year YEAR, 
	language_id INTEGER, 
	rental_duration INTEGER,
	rental_rate NUMERIC(4,2), 
	length INTEGER, 
	replacement_cost NUMERIC(5,2), 
	rating MPAA_RATING
)
language plpgsql
as $$
begin
	insert into film(title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, rating)
	values (title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, rating);
end;
$$;

-- ADD MOVIE
call add_new_film('Monti Was HERE!', 'Based on a true story about how Monti was here.', 2023, 1, 6, 6.99, 116, 25.99, 'R');

--view
select *
from film
where title = 'Monti Was HERE!';


--drop PROCEDURE add_new_film(
--	title VARCHAR, 
--	description TEXT, 
--	release_year YEAR, 
--	language_id INTEGER, 
--	rental_duration INTEGER,
--	rental_rate NUMERIC(4,2), 
--	length INTEGER, 
--	replacement_cost NUMERIC(5,2), 
--	rating MPAA_RATING
--); 


-------------------------------------------------------------------------------------------
--2. Create a Stored Function that will take in a category_id and return the number of
--films in that category

select * from film;
select * from film_category;

-- finds num of films in all categories
select category_id, count(*) as num_of_films
from category
join film_category using(category_id)
group by 1
order by num_of_films;

-- create stored function

--create or replace function num_of_films_in_cat(cat_id INTEGER)
--returns INTEGER
--language plpgsql
--as $$
--	declare num_of_films INTEGER;
--begin
--	select category_id, count(*) into num_of_films
--	from category
--	join film_category using(category_id)
--	group by category.category_id
--	order by num_of_films;
--end;
--$$;


-- Working Stored Function

create or replace function num_of_films_in_cat(cat_id INTEGER)
returns INTEGER
language plpgsql
as $$
	declare num_of_films INTEGER;
begin
	select count(category_id) into num_of_films
	from category
	join film_category using(category_id)
	where category.category_id = cat_id;
	return num_of_films;
end;
$$;

drop function if exists num_of_films_in_cat(integer);

-- CALL TO CHECK FUNC

select num_of_films_in_cat(14);

-----------------------------------------------------------
-- Subquery stored function


select count(*) as num_of_films
from film_category
where category_id in (
	select category_id 
	from category 
	where category_id  = 1
);

-- working 

create or replace function num_of_films_in_cat(cat_id INTEGER)
returns INTEGER
language plpgsql
as $$
	declare num_of_films INTEGER;
begin
	select count(*) into num_of_films
	from film_category
	where category_id in (
		select category_id 
		from category 
		where category_id  = cat_id
	);
	return num_of_films;
end;
$$;


-- call function
select num_of_films_in_cat(11);



