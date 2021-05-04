------ Partie sur les requêtes -----

-- 1 --

SELECT TITLE 
FROM DOCUMENTS
WHERE Theme LIKE '%Informatique%' OR Theme LIKE '%Mathématiques%'
GROUP BY TITLE;

-- 2 --
SELECT D.TITLE, D.THEME
FROM DOCUMENTS D, BORROWERS BE, BORROWS BS
WHERE BS.documents = D.id_documents
AND BE.id_borrower = BS.borrower
AND BS.begin_borrow > '15/11/2018'
AND BS.end_borrow < '15/11/2019';

-- 3 --

SELECT documents.title, autors.surname_autors 
FROM DOCUMENTS, AUTORS, BORROWS, BORROWERS
WHERE borrows.documents = documents.id_documents AND borrowers.id_borrower = borrows.borrower;

-- 4 --

-- 5 --

SELECT COUNT (documents.id_documents) 
FROM DOCUMENTS, EDITORS
WHERE documents.editor = editors.name_editors AND editors.name_editors = 'Eyrolles';

-- 6 --

SELECT editor, COUNT(*) as nb_doc
FROM DOCUMENTS 
group by editor;

-- 7 --

SELECT documents.id_documents, documents.title, COUNT (borrows.documents) as nb_emprunt
FROM DOCUMENTS LEFT JOIN BORROWS ON documents.id_documents = borrows.documents
GROUP BY documents.id_documents, documents.title;

-- 8 --
SELECT editor
FROM DOCUMENTS 
WHERE Theme LIKE '%Informatique%' OR Theme LIKE '%Mathématiques%'
GROUP BY editor
HAVING COUNT(editor) > 1;

-- 9 --

SELECT borrowers.name_borrower
FROM BORROWERS
WHERE borrowers.adresse IN (
    SELECT borrowers.name_borrower
    FROM BORROWERS
    WHERE borrowers.name_borrower = 'Dupont'
    );
    
-- 11 --

SELECT documents.

/*10-*/
SELECT D1.editor
FROM DOCUMENTS D1
WHERE D1.editor NOT IN (
    SELECT D2.editor  
    FROM DOCUMENTS D2
    WHERE Theme LIKE '%Informatique%'
    )
GROUP BY editor;

/*12-*/
SELECT D1.title
FROM DOCUMENTS D1
WHERE D1.id_documents NOT IN (
    SELECT D2.id_documents  
    FROM DOCUMENTS D2, BORROWS B
    WHERE D2.id_documents = B.documents
    );
    
/*14-*/

