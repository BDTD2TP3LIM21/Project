------ Partie sur les requêtes -----

-- 1 --

SELECT TITLE 
FROM DOCUMENTS
WHERE Theme LIKE '%informatique%' OR Theme LIKE '%mathématiques%'
GROUP BY TITLE;

-- 2 --
SELECT D.TITLE, D.THEME
FROM DOCUMENTS D, BORROWERS BE, BORROWS BS
WHERE BS.id_borrows = D.borrow_id
AND BE.id_borrower = BS.borrower
AND BS.begin_borrow > '15/11/2018'
AND BS.end_borrow < '15/11/2019';

-- 3 --

SELECT documents.title, autors.surname_autors 
FROM DOCUMENTS, AUTORS, BORROWS, BORROWERS
WHERE borrows.id_borrows = documents.id_documents AND borrowers.id_borrower = borrows.borrower;

-- 4 --

-- 5 --

SELECT COUNT (documents.id_documents) 
FROM DOCUMENTS, EDITORS
WHERE documents.editor_name = editors.name_editors AND name_editors = 'Eyrolles';

-- 6 --

SELECT editor_name, COUNT(*) as nb_doc
FROM DOCUMENTS 
group by editor_name;

-- 7 --

SELECT documents.id_documents, documents.title, COUNT (borrows.id_borrows) as nb_emprunt
FROM DOCUMENTS LEFT JOIN BORROWS ON documents.borrow_id = borrows.id_borrows
GROUP BY documents.id_documents, documents.title;

-- 8 --

SELECT editor_name 
FROM DOCUMENTS
WHERE Theme LIKE '%informatique' OR Theme LIKE '%mathématiques'
group by editor_name
HAVING COUNT(*) > 2;

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
SELECT editor
FROM DOCUMENTS
WHERE theme LIKE '%informatique'
group by editor
HAVING COUNT(*) < 1;

/*12-*/
SELECT D1.title
FROM DOCUMENTS D1
WHERE D1.id_documents NOT IN (
    SELECT D2.id_documents  
    FROM DOCUMENTS D2, BORROWS B
    WHERE D2.id_doccuments = B.documents
    );
    
/*14-*/
SELECT D1.title
FROM DOCUMENTS D1
WHERE D1.id_documents NOT IN (
    SELECT D2.id_documents  
    FROM DOCUMENTS D2, BORROWS B
    WHERE D2.borrow_id = B.id_borrows
    );
