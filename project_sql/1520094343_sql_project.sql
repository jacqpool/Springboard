/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

-- Only select facilities that charge members
SELECT NAME 
  FROM country_club.Facilities 
 WHERE membercost <> 0

/* Q2: How many facilities do not charge a fee to members? */

-- Count facalities by name that do not charge it's members
SELECT COUNT(NAME) 
  FROM country_club.Facilities 
 WHERE membercost = 0

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

-- Select stated columns where the membership cost is less than 20% of the monthly maintenance cost
SELECT facid,
       name,
       membercost,
       monthlymaintenance 
  FROM country_club.Facilities
 WHERE membercost < 0.2 * monthlymaintenance

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

-- Only select facilities 1 and 5
SELECT * 
  FROM country_club.Facilities 
 WHERE facid IN (1, 5)

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

-- Label the value of the facilities by the cost of it's maintenance
SELECT name,
       monthlymaintenance,
       CASE WHEN monthlymaintenance > 100 THEN 'expensive' 
            ELSE 'cheap' END AS value
  FROM country_club.Facilities 

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

/* The question is not clear if it wants the very last member, or the last 
few members (how many?), or otherwise just a list in descending order of 
when members joined. */

-- List of all members when they joined, in descening order.
SELECT firstname,
       surname
  FROM country_club.Members
 ORDER BY joindate DESC

/* Note: This person shares the same name as the first person that joined.
They have different addresses, zip codes and telephone numbers */

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

-- Show members that have used specific tennis courts
SELECT DISTINCT CONCAT(m.firstname, ' ', m.surname) AS member,
       f.name
  FROM country_club.Members AS m
  JOIN country_club.Bookings AS b 
    ON m.memid = b.memid
  JOIN country_club.Facilities AS f
    ON b.facid = f.facid
 WHERE f.name LIKE '%Tennis Court%'
 ORDER BY member

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

-- Answer to question 8.

SELECT f.name AS facility,
       CONCAT(m.firstname, ' ', m.surname) AS member,
       CASE WHEN m.memid = 0 THEN (b.slots * f.guestcost) 
            ELSE (b.slots * f.membercost) END AS cost
  FROM country_club.Members AS m
  JOIN country_club.Bookings AS b 
    ON m.memid = b.memid
  JOIN country_club.Facilities AS f
    ON b.facid = f.facid
 WHERE LEFT(starttime, 10) = '2012-09-14'
   AND CASE WHEN m.memid = 0 THEN (b.slots * f.guestcost) 
            ELSE (b.slots * f.membercost) END > 30
 ORDER BY cost DESC

-- Why can't I use 'cost' in the 'WHERE ... AND cost > 30' clause? 

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

-- Answer to question 9.

SELECT * 
FROM   (SELECT f.name AS facility,
               CONCAT(m.firstname, ' ', m.surname) AS member,
               CASE WHEN m.memid = 0 THEN (b.slots * f.guestcost) 
                    ELSE (b.slots * f.membercost) END AS cost
       FROM country_club.Members AS m
       JOIN country_club.Bookings AS b 
         ON m.memid = b.memid
       JOIN country_club.Facilities AS f
         ON b.facid = f.facid
 WHERE LEFT(starttime, 10) = '2012-09-14') AS sub
 WHERE sub.cost > 30
 ORDER BY sub.cost DESC

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

-- Answer to question 10.

SELECT *
  FROM (SELECT f.name AS facility,
        SUM(CASE WHEN m.memid = 0 THEN (b.slots * f.guestcost) 
            ELSE (b.slots * f.membercost) END) AS revenue
          FROM country_club.Members AS m
          JOIN country_club.Bookings AS b 
            ON m.memid = b.memid
          JOIN country_club.Facilities AS f
            ON b.facid = f.facid
         GROUP BY facility) AS sub
 WHERE sub.revenue < 1000
 ORDER BY sub.revenue


