CREATE TABLE movie (
  Poster_Link VARCHAR(200) DEFAULT NULL,
  Series_Title VARCHAR(100) DEFAULT NULL,
  Released_Year INT DEFAULT NULL,
  Certificate VARCHAR(10) DEFAULT NULL,
  Runtime INT DEFAULT NULL,
  Genre VARCHAR(30) DEFAULT NULL,
  IMDB_Rating decimal(2,1) DEFAULT NULL,
  Overview text,
  Meta_score VARCHAR(5) DEFAULT NULL,
  Director VARCHAR(40) DEFAULT NULL,
 Star1 VARCHAR(30) DEFAULT NULL,
  Star2 VARCHAR(30) DEFAULT NULL,
  Star3 VARCHAR(30) DEFAULT NULL,
  Star4 VARCHAR(30) DEFAULT NULL,
  No_of_Votes INT DEFAULT NULL,
  Gross VARCHAR(30) DEFAULT NULL);
  
  --przypisuje niektórym kkolumnom typ varchar po to aby wszystkie dane zostały zaimportowane, aby nie było błedu miedzy wartościa w kolumnie a typem kolumny (jeśli byłby bład dane nie były by zaimportowane)
  
SELECT COUNT(*) FROM movie --sprawdzam czy dane zostały poprawnie zimportowane przez sprawdzenie czy zgadza sie ilosc pustych miejsc w niektórych kolumnach--
WHERE gross = '';
  
SELECT COUNT(*) FROM movie 
WHERE certificate = '';
  
SELECT * FROM movie;
  
-- zmieniam typ danych w niektóych kolumnach aby można było przeprowadzać na nich działania -- 
  
  
SELECT gross FROM movie;

ALTER TABLE movie 
ALTER COLUMN gross DROP DEFAULT;
  
UPDATE movie 
SET gross=NULL
WHERE gross=''; -- 169 WYNIKÓW DOKŁADNIE TYLE ILE BYŁO PUSTYCH WARTOŚCI-


ALTER TABLE movie 
ALTER COLUMN gross TYPE NUMERIC
USING gross::NUMERIC;

ALTER TABLE movie 
ALTER COLUMN gross TYPE INT
USING gross::INT; -- po przeprowadzonych zmianach mogłem zmienić typ danych na bigint

SELECT * FROM movie
 
 -- przeprowadzam zmiane na pozostałej kolumnie 'meta_score';
 
 
ALTER TABLE movie 
ALTER COLUMN meta_score DROP DEFAULT;
  
UPDATE movie
SET meta_score=NULL
WHERE meta_score=''; -- 169 WYNIKÓW DOKŁADNIE TYLE ILE BYŁO PUSTYCH WARTOŚCI-


ALTER TABLE movie 
ALTER COLUMN meta_score TYPE NUMERIC
USING meta_score::NUMERIC;

ALTER TABLE movie 
ALTER COLUMN meta_score TYPE INT
USING meta_score::INT;

-- Teraz wszystkie kolumny mają poprawne formatowanie.

SELECT * FROM movie;

-- Teraz mogę sie zająć pustymi wartościami niektórych kolumn.

SELECT * FROM movie 
WHERE gross IS NULL;

-- Pozbycie się tych danych było spowodowałoby przerwanie ciągłosci rankingu 
-- z tego względu uważam imputowanie w tych miejscach gdzie jest null wartość srednią dla zarobków w całym rankingu
-- pozwoli to na zachowanie spójności danych, wszystkie filmy bedą miały wtedy swoją wartość zarobków oraz całkowita średnia się nie zmieni 
 
 
SELECT ROUND(AVG(gross),0) avg_gross FROM movie;

-- średnie zarobi w top 1000 wynosi ona 68025381

UPDATE movie
SET gross=(SELECT ROUND(AVG(gross),0) avg_gross FROM movie)
WHERE gross IS NULL;

SELECT * FROM movie
WHERE gross IS NULL; -- brak

-- teraz puste wartości w meta_score

SELECT * FROM movie
WHERE meta_score IS NULL;

-- dla wartości meta score uważam że najbardziej odpowiednia bedzie dominanta z 
-- dominanta będzie odzwierciedlać najbardziej typową ocenę filmów w całym zbiorze, dlatego uzupełnienie brakujących danych tą wartością może wprowadzać mniejsze zniekształcenia niż inne statystyki

SELECT meta_score, COUNT(meta_score) AS występowanie
FROM movie
GROUP BY meta_score
ORDER BY występowanie DESC
LIMIT 1;
-- dominanta jest równa 76 i występuje 32 razy

UPDATE movie
SET meta_score=76
WHERE meta_score IS NULL;

-- pozostała jedynie kolumna kategoria w któej są puste wartości.
-- uzupełnie je na podstawie 2 wspólnych gatunków to znaczy
-- jeśli film nie ma kategorii a ma gartunki np. drama,crime to przypisze mu kategorie najczęściej występującą dla innych filmów które mają w gatunkach drama crime.
SELECT * FROM movie
WHERE genre ILIKE '%Crime%Drama%' AND certificate ='';

SELECT certificate, COUNT(certificate) AS występowanie
FROM movie
GROUP BY certificate,genre
HAVING genre ILIKE '%Crime%Drama%'
ORDER BY występowanie DESC
LIMIT 1;

-- kategoria A występuje najczęsciej dla tych gatunków

UPDATE movie 
SET certificate='A'
WHERE genre ILIKE '%Crime%Drama%' AND certificate ='';

-- POWTARZAMY TO DLA KOLEJNYCH 

SELECT * FROM movie
WHERE certificate ='';


SELECT COUNT(*) FROM movie
WHERE certificate ='' AND genre='Drama';

SELECT COUNT(*) FROM movie
WHERE genre='Drama'; 

SELECT certificate, COUNT(certificate) AS występowanie
FROM movie
GROUP BY certificate,genre
HAVING genre='Drama'
ORDER BY występowanie DESC
LIMIT 1;
-- R najczęstsze dla gatunku drama 

UPDATE movie 
SET certificate='R'
WHERE genre='Drama' AND certificate ='';

-- comedy, drama teraz
SELECT certificate, COUNT(certificate) AS występowanie
FROM movie
GROUP BY certificate,genre
HAVING genre ILIKE '%Comedy%Drama%'
ORDER BY występowanie DESC
LIMIT 2;
 --U DLA comedy dramat
UPDATE movie 
SET certificate='U'
WHERE genre ILIKE '%Comedy%Drama%' AND certificate ='';

-- zrobię to dla reszty powtarzając na jednym zapytaniu


SELECT certificate, COUNT(certificate) AS występowanie
FROM movie
GROUP BY certificate,genre
HAVING genre ILIKE '%Film-Noir%'
ORDER BY występowanie DESC
LIMIT 1;

UPDATE movie 
SET certificate='A'
WHERE genre ILIKE '%Film-Noir%' AND certificate ='';


SELECT * FROM movie 
WHERE certificate =''
-- brak pustych wartości 
-- wszystkie blank values zostały imputowane 


-- NA KONIEC PRZYGOTOWANIA DANYCH SPRAWDZAM CZY WYSTĘPUJĄ DUPLIKATY
WITH dupli AS (
	SELECT *,
			DENSE_RANK() OVER(PARTITION BY poster_link, series_title,runtime) duplikaty
	FROM movie)
	
SELECT * FROM dupli 
WHERE duplikaty!=1

-- brak wyników co oznacza że tabela nie zawiera duplikatów
-- tak przygotowane dane można zacząc analizować i wizualizować





 
 
  