------ Partie sur les requêtes -----

-- 1 --

SELECT TITLE FROM DOCUMENTS
WHERE Theme LIKE '%informatique' OR Theme LIKE '%mathématiques'
GROUP BY TITLE;

-- 3 --

SELECT documents.title, autors.surname_autors FROM DOCUMENTS, AUTORS, BORROWS
WHERE borrows.id_borrows = documents.id_documents AND borrows.borrower = borrowers.id_borrower;

