------ Partie sur les requêtes -----

-- 1 --

SELECT TITLE 
FROM DOCUMENTS
WHERE Theme LIKE '%informatique%' OR Theme LIKE '%mathématiques%'
GROUP BY TITLE;

-- 3 --

SELECT documents.title, autors.surname_autors 
FROM DOCUMENTS, AUTORS, BORROWS, BORROWERS
WHERE borrows.id_borrows = documents.id_documents AND borrowers.id_borrower = borrows.borrower;

-- 5 --

SELECT COUNT (documents.id_documents) FROM DOCUMENTS, EDITORS
WHERE documents.editor_name = editors.name_editors AND name_editors = 'Eyrolles';

-- 7 --

SELECT documents.title ,COUNT (documents.borrow_id)
FROM DOCUMENTS;

