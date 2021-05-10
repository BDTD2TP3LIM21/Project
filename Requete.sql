---- Partie sur les transactions ----

-- Ajout manuel de données dans la base : 

SET AUTOCOMMIT OFF;

INSERT INTO BORROWERS(ID_BORROWER, NAME_BORROWER, SURNAME_BORROWER, ADRESSE, PHONE_NUMBER, NAME_CATEGORIE)
    VALUES (0, 'Charles', 'Jean', '84 rue du Moulin', '06 52 54 12 95', 'Public');
    
commit;

INSERT INTO EXEMPLAR(ID_EXEMPLAR, SHELF, DOCUMENTS)
    VALUES(0, 102, 3);
commit;

INSERT INTO BORROWS(BORROWER, EXEMPLAR, BEGIN_BORROW, END_BORROW)
    VALUES(15, 29, '05/05/2021', '20/05/2021');
    
commit;

SET AUTOCOMMIT ON;

-- Transaction sur les documents : ne peuvent pas avoir le même nom (arbitraire)
BEGIN
    LOCK TABLE DOCUMENTS IN EXCLUSIVE MODE;
    DECLARE DOCCOUNT number;
    BEGIN 
        savepoint AddDocuments;
        INSERT INTO DOCUMENTS(ID_DOCUMENTS, TITLE, THEME, EDITOR)
        VALUES (30, 'LE TIGRE', 'Nouvelle', 'Edition de Fallois');
        
        SELECT COUNT(*) into DOCCOUNT from DOCUMENTS WHERE title = 'LE TIGRE';
        if (DOCCOUNT > 1) then
            BEGIN
                ROLLBACK TO AddDocuments;
            END;
            else 
            BEGIN
                COMMIT;
            END;
        end if;   
    END;
END;


-- Transactions sur les emprunteurs, emprunteur ne peut pas avoir le même nom et prénom qu'un autre (arbitraire)
BEGIN
LOCK TABLE BORROWERS IN EXCLUSIVE MODE;
DECLARE BorrowersCOUNT number;
    BEGIN 
    savepoint AddBorrowers;
    INSERT INTO BORROWERS(ID_BORROWER, NAME_BORROWER, SURNAME_BORROWER, ADRESSE, PHONE_NUMBER, NAME_CATEGORIE)
        VALUES (0, 'Dupont', 'Dupont', '77 rue du pont St Marc', '06 52 95 62 45', 'Public');
    
    SELECT COUNT(*) into BorrowersCOUNT from BORROWERS WHERE name_borrower = 'Dupont' and surname_borrower = 'Dupont';
    if (BorrowersCOUNT > 1) then
        BEGIN
            ROLLBACK TO AddBorrowers;
        END;
        else 
        BEGIN
            COMMIT;
        END;
    end if;
    END;
END;

------ Partie sur les requêtes -----

-- 1 --
CREATE OR REPLACE VIEW question_1 AS
SELECT TITLE 
FROM DOCUMENTS
WHERE Theme LIKE '%Informatique%' OR Theme LIKE '%Mathématiques%'
ORDER BY title;

-- 2 --
CREATE OR REPLACE VIEW question_2 AS
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

CREATE OR REPLACE VIEW question_3 AS
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
CREATE OR REPLACE VIEW question_4 AS
SELECT A.name_authors
FROM AUTHORS A, WROTE W, DOCUMENTS D, EDITORS E
WHERE A.id_authors = W.author
AND W.documents = D.id_documents
AND D.editor = E.name_editors
AND E.name_editors = 'DUNOD';

-- 5 --
CREATE OR REPLACE VIEW question_5 AS
SELECT editor, COUNT(*)
FROM DOCUMENTS D, EXEMPLAR E
WHERE D.id_documents = E.documents
AND D.editor = 'Eyrolles'
GROUP BY EDITOR;

-- 6 --
CREATE OR REPLACE VIEW question_6 AS
SELECT editor, COUNT(*) as nb_doc
FROM DOCUMENTS 
group by editor;

-- 7 --
CREATE OR REPLACE VIEW question_7 AS
SELECT D.id_documents, D.title, COUNT (B.exemplar) as nb_emprunt
FROM DOCUMENTS D, EXEMPLAR E LEFT JOIN BORROWS B ON E.id_exemplar = B.exemplar
WHERE D.id_documents = E.documents
GROUP BY D.id_documents, D.title
ORDER BY D.id_documents;

-- 8 --
CREATE OR REPLACE VIEW question_8 AS
SELECT editor
FROM DOCUMENTS 
WHERE theme LIKE '%Informatique%' OR Theme LIKE '%Mathématiques%'
GROUP BY editor
HAVING COUNT(editor) > 1;

-- 9 --
CREATE OR REPLACE VIEW question_9 AS
SELECT B1.name_borrower
FROM BORROWERS B1
WHERE B1.adresse IN (
    SELECT B2.adresse
    FROM BORROWERS B2
    WHERE B2.name_borrower = 'Dupont'
    )
AND B1.name_borrower != 'Dupont';

-- 10 --
CREATE OR REPLACE VIEW question_10 AS
SELECT D1.editor
FROM DOCUMENTS D1
WHERE D1.editor NOT IN (
    SELECT D2.editor  
    FROM DOCUMENTS D2
    WHERE D2.theme LIKE '%Informatique%'
    )
GROUP BY editor;

-- 11 --
CREATE OR REPLACE VIEW question_11 AS
SELECT B1.name_borrower as never_borrowed
FROM BORROWERS B1
WHERE B1.name_borrower NOT IN (
    SELECT B2.name_borrower
    FROM BORROWERS B2, BORROWS BO
    WHERE B2.id_borrower = BO.borrower
);

-- 12 --
CREATE OR REPLACE VIEW question_12 AS
SELECT D.title as never_been_borrowed
FROM DOCUMENTS D
WHERE D.id_documents NOT IN (
    SELECT E.documents  
    FROM EXEMPLAR E, BORROWS B
    WHERE E.id_exemplar = B.exemplar
);
    
-- 13 -- 
CREATE OR REPLACE VIEW question_13 AS
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
CREATE OR REPLACE VIEW question_14 AS
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
CREATE OR REPLACE VIEW question_15 AS
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
CREATE OR REPLACE VIEW question_16 AS
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
CREATE OR REPLACE VIEW question_17 AS
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
CREATE OR REPLACE VIEW question_18 AS
SELECT DO1.title
FROM DOCUMENTS DO1, DESCRIBED DE1
WHERE DO1.id_documents = DE1.documents
AND DE1.key_word IN (
    SELECT DE2.key_word  
    FROM DOCUMENTS DO2, DESCRIBED DE2
    WHERE DO2.id_documents = DE2.documents
    AND DO2.title = 'SQL pour les nuls'
)
AND DO1.title != 'SQL pour les nuls'
GROUP BY DO1.title;

 -- 19 --
CREATE OR REPLACE VIEW question_19 AS
SELECT DO1.title
FROM DOCUMENTS DO1, DESCRIBED DE1
WHERE DO1.id_documents = DE1.documents
AND DE1.key_word IN (
    SELECT DE2.key_word  
    FROM DOCUMENTS DO2, DESCRIBED DE2
    WHERE DO2.id_documents = DE2.documents
    AND DO2.title = 'SQL pour les nuls'
)
AND DO1.title != 'SQL pour les nuls'
GROUP BY DO1.title
HAVING COUNT(DE1.key_word) >= (
    SELECT COUNT(DE5.key_word)
    FROM DOCUMENTS DO5, DESCRIBED DE5
    WHERE DO5.id_documents = DE5.documents
    AND DO5.title = 'SQL pour les nuls'
);

 -- 20 --
CREATE OR REPLACE VIEW question_20 AS
SELECT DO1.title
FROM DOCUMENTS DO1, DESCRIBED DE1
WHERE DO1.id_documents = DE1.documents
AND DE1.key_word IN ( -- a au moins un mot clef qui est dans SQL pour les nuls --
    SELECT DE2.key_word  
    FROM DOCUMENTS DO2, DESCRIBED DE2
    WHERE DO2.id_documents = DE2.documents
    AND DO2.title = 'SQL pour les nuls'
)
AND do1.id_documents NOT IN ( -- n a pas un mot clef qui n est pas dans SQL pour les nuls --
    SELECT DO3.id_documents
    FROM DOCUMENTS DO3, DESCRIBED DE3
    WHERE DO3.id_documents = DE3.documents
    AND DE3.key_word NOT IN (
        SELECT DE4.key_word  
        FROM DOCUMENTS DO4, DESCRIBED DE4
        WHERE DO4.id_documents = DE4.documents
        AND DO4.title = 'SQL pour les nuls'
    )
    GROUP BY DO3.id_documents
)
AND DO1.title != 'SQL pour les nuls' -- n'est pas SQL pour les nuls --
GROUP BY DO1.title
HAVING COUNT(DE1.key_word) = ( --a un compte de mot = a SQL pour les nuls--
    SELECT COUNT(DE5.key_word)
    FROM DOCUMENTS DO5, DESCRIBED DE5
    WHERE DO5.id_documents = DE5.documents
    AND DO5.title = 'SQL pour les nuls'
);
