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
SELECT br.id_borrower, D.title, A.surname_authors 
FROM DOCUMENTS D, AUTHORS A, WROTE W, BORROWS BO, BORROWERS BR, EXEMPLAR E
WHERE A.id_authors = W.author
AND W.documents = D.id_documents
AND D.id_documents = E.documents
AND E.id_exemplar = BO.exemplar
AND BO.borrower = BR.id_borrower;

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
SELECT D.id_documents, D.title, COUNT (E.documents) as nb_emprunt
FROM DOCUMENTS D LEFT JOIN EXEMPLAR E ON D.id_documents = E.documents
GROUP BY D.id_documents, D.title;

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
SELECT B1.name_borrower, B1.surname_borrower
FROM BORROWERS B1
WHERE B1.name_categorie = 'Professionnel'
AND B1.id_borrower IN (
    SELECT BO.borrower
    FROM DOCUMENTS DO1, BORROWS BO   
    WHERE bo.end_borrow >= trunc(SYSDATE)
    AND bo.end_borrow >= trunc(SYSDATE - 182.5)
    AND DO1.id_documents IN(
        SELECT DO2.id_documents
        FROM DOCUMENTS DO2, DVD D 
        WHERE DO2.id_documents = D.documents
     )
);

/*14-*/
SELECT DO1.title, DO1.quantity
FROM DOCUMENTS  DO1
WHERE DO1.quantity > (
    SELECT avg(DO2.quantity)
    FROM DOCUMENTS DO2
)
ORDER BY DO1.quantity DESC;

/*15-*/
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