-- 1 tabela z raportu

SELECT director reżyser, ROUND(avg(imdb_rating),2) Średnia_ocena_IMDB, COUNT(*) No_filmów FROM movie
GROUP BY director
HAVING COUNT(*)>=5
ORDER BY avg(imdb_rating) DESC;

-- 2 tabela  z raportu

SELECT genre gatunek, ROUND(avg(imdb_rating),2) Średnia_ocena_IMDB, COUNT(*) No_filmów FROM movie
GROUP BY genre
HAVING COUNT(*)>=5
ORDER BY avg(imdb_rating)  DESC;

-- 3 Tabela z raportu

SELECT director reżyser,genre gatunek, ROUND(avg(imdb_rating),2) Średnia_ocena_IMDB, COUNT(*) No_filmów FROM movie
GROUP BY director,genre
HAVING director ILIKE 'Francis Ford Coppola' OR director ILIKE 'Peter Jackson'  OR director ILIKE 'Sergio Leone'


-- cte do tabel 4,5
WITH actors AS
(SELECT star1,imdb_rating,genre,series_title,director  FROM movie
UNION 
SELECT star3,imdb_rating,genre,series_title,director    FROM movie
UNION
SELECT star2,imdb_rating,genre,series_title,director    FROM movie
UNION
SELECT star4,imdb_rating,genre,series_title,director    FROM movie)

SELECT star1 aktor, ROUND(avg(imdb_rating),2) Średnia_ocena_IMDB, COUNT(*) No_filmów FROM actors
GROUP BY aktor
HAVING COUNT(*)>=5
ORDER BY avg(imdb_rating) DESC


--tabela 4
SELECT star1 aktor,genre gatunek, ROUND(avg(imdb_rating),2) Średnia_ocena_IMDB, COUNT(*) No_filmów FROM actors
GROUP BY aktor, genre
HAVING  star1 ILIKE 'Viggo%' OR star1 ILIKE 'Ian Mc%'  OR star1 ILIKE 'Diane Keaton'
ORDER BY aktor, Średnia_ocena_IMDB DESC
-- tabela 5

SELECT star1 aktor,director reżyser, ROUND(avg(imdb_rating),2) Średnia_ocena_IMDB, COUNT(*) No_filmów FROM actors
GROUP BY aktor, director
HAVING  star1 ILIKE 'Al Pacino' OR star1 ILIKE 'Brad Pitt'  OR star1 ILIKE 'Leonardo DiCaprio'
ORDER BY aktor, Średnia_ocena_IMDB DESC


select * from movie
WHERE director ILIKE 'David Fincher'