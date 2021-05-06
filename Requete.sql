------ Partie sur les requêtes -----

-- 1 --
SELECT TITLE 
FROM DOCUMENTS
WHERE Theme LIKE '%Informatique%' OR Theme LIKE '%Mathématiques%'
ORDER BY title;

-- 2 --
SELECT D.TITLE, D.THEME
FROM DOCUMENTS D
WHERE  D.id_documents IN (
    SELECT E.documents
    FROM EXEMPLAR E
    WHERE E.id_exemplar IN (
        SELECT BS.exemplar
        FROM BORROWERS BE, BORROWS BS
        WHERE BE.id_borrower = BS.borrower
        AND BS.begin_borrow > to_date('15/11/2018','DD-MM-YYYY')
        AND BS.end_borrow < to_date('15/11/2019','DD-MM-YYYY')
        AND BE.name_borrower = 'Dupont'
    )
);

-- 3 --
SELECT BR.id_borrower, BR.name_borrower, BR.surname_borrower, D.title, A.surname_authors 
FROM DOCUMENTS D, AUTHORS A, WROTE W, BORROWS BO, BORROWERS BR, EXEMPLAR E
WHERE A.id_authors = W.author
AND W.documents = D.id_documents
AND D.id_documents = E.documents
AND E.id_exemplar = BO.exemplar
AND BO.borrower = BR.id_borrower
GROUP BY BR.id_borrower, BR.name_borrower, BR.surname_borrower, D.title, A.surname_authors
ORDER BY BR.id_borrower;

-- 4 --
SELECT A.name_authors
FROM AUTHORS A, WROTE W, DOCUMENTS D, EDITORS E
WHERE A.id_authors = W.author
AND W.documents = D.id_documents
AND D.editor = E.name_editors
AND E.name_editors = 'DUNOD';

-- 5 --
SELECT editor, COUNT(*)
FROM DOCUMENTS D, EXEMPLAR E
WHERE D.id_documents = E.documents
AND D.editor = 'Eyrolles'
GROUP BY EDITOR;

-- 6 --
SELECT editor, COUNT(*) as nb_doc
FROM DOCUMENTS 
group by editor;

-- 7 --
SELECT D.id_documents, D.title, COUNT (B.exemplar) as nb_emprunt
FROM DOCUMENTS D, EXEMPLAR E LEFT JOIN BORROWS B ON E.id_exemplar = B.exemplar
WHERE D.id_documents = E.documents
GROUP BY D.id_documents, D.title
ORDER BY D.id_documents;

-- 8 --
SELECT editor
FROM DOCUMENTS 
WHERE theme LIKE '%Informatique%' OR Theme LIKE '%Mathématiques%'
GROUP BY editor
HAVING COUNT(editor) > 1;

-- 9 --
SELECT B1.name_borrower
FROM BORROWERS B1
WHERE B1.adresse IN (
    SELECT B2.adresse
    FROM BORROWERS B2
    WHERE B2.name_borrower = 'Dupont'
    )
AND B1.name_borrower != 'Dupont';

-- 10 --
SELECT D1.editor
FROM DOCUMENTS D1
WHERE D1.editor NOT IN (
    SELECT D2.editor  
    FROM DOCUMENTS D2
    WHERE D2.theme LIKE '%Informatique%'
    )
GROUP BY editor;

-- 11 --
SELECT B1.name_borrower as never_borrowed
FROM BORROWERS B1
WHERE B1.name_borrower NOT IN (
    SELECT B2.name_borrower
    FROM BORROWERS B2, BORROWS BO
    WHERE B2.id_borrower = BO.borrower
);

-- 12 --
SELECT D.title as never_been_borrowed
FROM DOCUMENTS D
WHERE D.id_documents NOT IN (
    SELECT E.documents  
    FROM EXEMPLAR E, BORROWS B
    WHERE E.id_exemplar = B.exemplar
);
    
-- 13 -- 
SELECT B.name_borrower, B.surname_borrower
FROM BORROWERS B
WHERE B.name_categorie = 'Professionnel'
AND B.id_borrower IN (
    SELECT BO.borrower
    FROM BORROWS BO   
    WHERE bo.end_borrow <= trunc(SYSDATE)
    AND bo.end_borrow >= trunc(SYSDATE - 182.5)
    AND BO.exemplar IN (
        SELECT E.id_exemplar
        FROM EXEMPLAR E
        WHERE E.documents IN (
            SELECT DO2.id_documents
            FROM DOCUMENTS DO2, DVD D 
            WHERE DO2.id_documents = D.documents
         )
     )
);

-- 14 -- 
SELECT D1.title, quantityExemplar.nb_Exemplar_test
FROM DOCUMENTS D1, ( 
            SELECT D2.id_documents, COUNT(*) as nb_Exemplar_test
            FROM DOCUMENTS D2, EXEMPLAR E2
            WHERE D2.id_documents = E2.documents
            GROUP BY D2.id_documents
        ) quantityExemplar, (
        SELECT AVG(nb_Exemplar) AS avg_Nb_Exemplar
        FROM ( 
            SELECT D3.id_documents, COUNT(*) as nb_Exemplar
            FROM DOCUMENTS D3, EXEMPLAR E3
            WHERE D3.id_documents = E3.documents
            GROUP BY D3.id_documents
            )
        ) averageQuantity
WHERE D1.id_documents = quantityexemplar.id_documents
AND quantityexemplar.nb_Exemplar_test > averageQuantity.avg_Nb_Exemplar;

-- 15 --
SELECT name_authors
FROM AUTHORS A
WHERE A.id_authors IN (
    SELECT W.author
    FROM WROTE W
    WHERE W.documents IN (
        SELECT D.id_documents
        FROM DOCUMENTS D
        WHERE D.theme LIKE '%Mathématiques%'
    )
)
AND A.id_authors IN (
    SELECT W.author
    FROM WROTE W
    WHERE W.documents IN (
        SELECT D.id_documents
        FROM DOCUMENTS D
        WHERE D.theme LIKE '%Informatique%'
    )
);

-- 16 --
SELECT quantityBorrow.editor, quantityBorrow.nb_Borrow
FROM  ( 
            SELECT D.editor, COUNT(*) as nb_Borrow
            FROM DOCUMENTS D, EXEMPLAR E2, BORROWS BO
            WHERE D.id_documents = E2.documents
            AND E2.id_exemplar = BO.exemplar
            GROUP BY D.editor
        ) quantityBorrow, (
        SELECT MAX(nb_Borrow) as max_nb_Borrow
        FROM  ( 
            SELECT D.editor, COUNT(*) as nb_Borrow
            FROM DOCUMENTS D, EXEMPLAR E2, BORROWS BO
            WHERE D.id_documents = E2.documents
            AND E2.id_exemplar = BO.exemplar
            GROUP BY D.editor
            )
        ) quantityMaxBorrow
WHERE quantityBorrow.nb_Borrow = quantityMaxBorrow.max_nb_Borrow;

----------------------------------17/18/19/20-----------------------------
-- JAVA pour les nuls = exactement les mêmes mot clé : algorithmique, programation
-- Analyse du son au travers des maths = un mot clé en commun : algorithmique
-- Théorie de la géométrie iréel = un mot clé en commun : algorithmique
-- Théorie du réseaux quantiques = un mot clé en plus : algorithmique, programation et quantique

-- 17 --
SELECT DO1.title
FROM DOCUMENTS DO1
WHERE DO1.id_documents NOT IN (
    SELECT DO2.id_documents
    FROM DOCUMENTS DO2, DESCRIBED DE1
    WHERE DO2.id_documents = DE1.documents
    AND DE1.key_word IN (
        SELECT DE2.key_word  
        FROM DOCUMENTS DO3, DESCRIBED DE2
        WHERE DO3.id_documents = DE2.documents
        AND DO3.title = 'SQL pour les nuls'
    )
    GROUP BY DO2.id_documents
);
    
 -- 18 --
SELECT DO1.title
FROM DOCUMENTS DO1, DESCRIBED DE1
WHERE DO1.id_documents = DE1.documents
AND DE1.key_word IN (
    SELECT DE2.key_word  
    FROM DOCUMENTS DO2, DESCRIBED DE2
    WHERE DO2.id_documents = DE2.documents
    AND DO2.title = 'SQL pour les nuls'
)
GROUP BY DO1.title;

 -- 19 --
 /*
SELECT D1.id_documents, COUNT (K.name_key_words) AS nb_keyword
FROM Documents D1, Described D, Key_Words K
WHERE D1.id_documents = D.documents
AND D.key_word = K.name_key_words
AND D1.id_documents IN (
    SELECT D2.id_documents
    FROM Documents D2
    WHERE D2.id_documents = D.documents
    AND D.key_word = K.name_key_words
    GROUP BY D1.id_documents
    HAVING COUNT (K.name_key_words) > 1 
);
*/