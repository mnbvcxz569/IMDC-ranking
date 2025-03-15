select director,Count(*) from movie
group by director
order by count desc
LIMIT 12;


select director,ROUND((imdb_rating),2) from movie
WHERE director='Christopher Nolan';


select max(meta_score) FROM MOVIE;

select series_title, imdb_rating, meta_score from movie
where meta_score=30;

WITH actors AS(
SELECT star1,imdb_rating,genre,series_title,director  FROM movie
UNION 
SELECT star3,imdb_rating,genre,series_title,director    FROM movie
UNION
SELECT star2,imdb_rating,genre,series_title,director    FROM movie
UNION
SELECT star4,imdb_rating,genre,series_title,director    FROM movie)
,
występy AS 
(SELECT star1, COUNT(*) no_występy  FROM actors 
GROUP BY star1
ORDER BY COUNT(*) DESC)

SELECT a.star1,
	AVG(imdb_rating) imdb_rating,
	AVG(meta_score),
	no_występy 
FROM actors a
JOIN występy w ON w.star1=a.star1
GROUP BY a.star1,no_występy 
ORDER BY no_występy DESC;

-- tabela imdb_aktorzy.csv
SELECT * FROM actors 

-- tabela imdb_gatunki.csv
SELECT genre FROM movie


