# Sakila Database
Welcome to the fascinating world of the Sakila database, where data takes center stage and tells a story that’s part drama, part comedy, and a little touch of luck. Sakila, our star database, hosts a collection of tables that capture the life and times of fictional characters and their adventures. Just like a theater with various acts, Sakila’s tables offer a stage where we can explore and perform data queries.

In this data-driven spectacle, we’ll journey through various scenes and unveil intriguing insights, all while adding a dash of humor to make it engaging. So, grab your popcorn (or SQL prompt) and get ready for an entertaining performance of SQL queries that will tickle your data-craving taste buds.

## Sakila sample database architecture
There are 16 tables, 7 views, 3 stored procedures, 3 stored functions and 6 triggers in The Sakila database.

Tables in the Sakila database:

### actor:
The actor table lists information for all the actors, includes first name and last name of actors.
### address: 
The address table contains address information for customers, staff, and stores.
### category:
The category table lists the categories that can be assigned to films.
### city: 
The city table contains a list of cities.
### country: 
The country table contains a list of countries or regions.
### customer: 
The customer table contains a list of all customers.
### film: 
The film table lists all the films that may be in stock in the store.
### film_text: 
The content of film_text table is kept in synchrony with the film table by means of triggers on the film table INSERT, UPDATE and DELETE operations。
### film_actor: 
The film_actor table is used to support many-to-many relationships between films and actors.
### film_category: 
The film_category table is used to support many-to-many relationships between films and categories.
### inventory: 
A row in the inventory table represents a copy of a given film in a given store.
### language: 
The language table lists all possible values ​​for the film language and original language.
### payment: 
The payment table records every payment made by the customer, includes information such as the amount and rent paid.
### rental: 
The rental table contains a row for each rental of each inventory item, which contains information about who rented what, when it rented it, and when it was returned.
### staff: 
The staff table lists all staff information, including email addresses, login information, and pictures.
### store: 
The store table lists all stores in the system.

<img align="centre" alt="Coding" src="https://www.sqliz.com/sakila/structure/sakila.png">

## Conclusion
### Production:
Movie production dipped globally between 2017 and 2019. March sees the most 
releases. The USA and India combined released over 1,000 movies in 2019. 
Genre: Drama reigns supreme with 4,285 films, followed by Comedy and Thriller. While 
3,289 movies belong to a single genre, most encompass multiple. Action, Romance, and 
Crime boast the longest durations. 
### Rating: 
"Love in Kilnerry," "Kirket," lead in ratings. Movies from the USA, Canada, India, 
and HongKong garner the most votes. Interestingly, German movies receive significantly 
more votes than Italian ones. 
### Production: 
Dream Warrior Pictures and National Theatre Live lead based on movie count, 
with 3 movies each. Globally, Marvel Studios, Twentieth Century Fox, and Warner Bros are 
top earners based on total votes. 
### Directors: 
James Mangold, Anthony Russo, and Joe Russo are leading directors in the top 
three genres. A.L. Vijay, Andrew Jones, and Steven Soderbergh stand out for total movies, 
ratings, and votes. 
### Star Power: 
Mammootty and Mohanlal have the most top-rated films. Vijay Sethupathi 
(India) and Taapsee Pannu (Hindi) lead in average ratings. In drama super hits, Susan Brown, 
Amanda Lawrence, and Denise Gough are the top actresses. 
### Box Office:
"Avengers: Endgame" and "The Lion King" are among the top five highest
grossing movies in the top three genres. "Star Cinema" and "Twentieth Century Fox" excel in 
multilingual movies with high ratings. 
### Recommendations:
By focusing on Drama, Action, and Thriller genres, partnering with top 
production houses, and engaging highly-rated talent, RSVP Movies can maximize success in 
local and global markets.
