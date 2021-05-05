------ Partie sur les requêtes -----

-- 1 --
SELECT TITLE 
FROM DOCUMENTS
WHERE Theme LIKE '%Informatique%' OR Theme LIKE '%Mathématiques%'
GROUP BY TITLE
ORDER BY title;

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
SELECT editor, sum(quantity) as nb_Examplar
FROM DOCUMENTS D, EDITORS E
WHERE D.editor = E.name_editors 
AND E.name_editors = 'Eyrolles'
GROUP BY EDITOR;

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
WHERE theme LIKE '%Informatique%' OR Theme LIKE '%Mathématiques%'
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

/*10-*/
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
    WHERE B2.name_borrower = BO.borrower
    );



/*12-*/
SELECT D1.title as never_been_borrowed
FROM DOCUMENTS D1
WHERE D1.id_documents NOT IN (
    SELECT D2.id_documents  
    FROM DOCUMENTS D2, BORROWS B
    WHERE D2.id_documents = B.documents
    );
    
/*13-*/
/*pasfini */
SELECT B2.name_borrower, B2.surname_borrower
FROM BORROWERS B2
WHERE B2.name_categorie = 'Professionnel';

/*14-*/

