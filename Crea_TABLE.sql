DROP TABLE Autors CASCADE CONSTRAINTS;
CREATE TABLE Autors (
  Id_autors INT, 
  Name_autors VARCHAR2(100), 
  Surname_autors VARCHAR2(100), 
  Birthday DATE,
  CONSTRAINT PK_Autors PRIMARY KEY (Id_autors));
  
DROP TABLE Key_words CASCADE CONSTRAINTS;
CREATE TABLE Key_words (
  Name_key_words VARCHAR2(100));
  
DROP TABLE Described CASCADE CONSTRAINTS;
CREATE TABLE Described (
  Documents INT,
  Key_Word VARCHAR2(100),
  CONSTRAINT PK_Described PRIMARY KEY (Documents, Key_Word),
  CONSTRAINT FK_Described_Documents FOREIGN KEY (Documents) REFERENCES Documents(Id_documents),
  CONSTRAINT FK_Described_Key_words FOREIGN KEY (Key_words) REFERENCES Documents(Name_key_words));
  
DROP TABLE Wrote CASCADE CONSTRAINTS;
CREATE TABLE Wrote (
  Documents INT,
  Author INT,
  CONSTRAINT PK_Wrote PRIMARY KEY (Documents, Authors),
  CONSTRAINT FK_Wrote_Documents FOREIGN KEY (Documents) REFERENCES Documents(Id_documents),
  CONSTRAINT FK_Wrote_Authors FOREIGN KEY (Author) REFERENCES Autors(Id_autors));

DROP TABLE Editors CASCADE CONSTRAINTS;
CREATE TABLE Editors (
  Name_editors VARCHAR2(100), 
  Adresse VARCHAR2(255), 
  Phone_number VARCHAR2(50), 
  CONSTRAINT PK_Editors PRIMARY KEY (Name_editors));

DROP TABLE Categories CASCADE CONSTRAINTS;
CREATE TABLE Categories (
  Name_categories VARCHAR2(255),
  Nb_doc_max INT,
  Time_book INT,
  Time_CD INT,
  Time_DVD INT,
  Time_Video INT,
  CONSTRAINT PK_Categories PRIMARY KEY (Name_categories));

DROP TABLE Borrowers CASCADE CONSTRAINTS;
CREATE TABLE Borrowers (
  Id_borrower INT, 
  Name_borrower VARCHAR2(255),
  Surname_borrower VARCHAR2(255),
  Adresse VARCHAR2(255), 
  Phone_number VARCHAR2(255),
  Name_categorie VARCHAR2(255),
  CONSTRAINT PK_Borrowers PRIMARY KEY (Id_borrower),
  CONSTRAINT FK_Borrowers_Categories FOREIGN KEY(Name_categorie) REFERENCES Categories(Name_categories));
  
DROP TABLE Borrows CASCADE CONSTRAINTS;
CREATE TABLE Borrows (
  Id_Borrows INT,
  Begin_borrow DATE,
  End_borrow DATE,
  Borrower INT,
  CONSTRAINT PK_Borrows PRIMARY KEY (Id_Borrows),
  CONSTRAINT FK_Borrows_Borrower FOREIGN KEY (Borrower) REFERENCES Borrowers(Id_borrower));
  
DROP TABLE Documents CASCADE CONSTRAINTS;
CREATE TABLE Documents (
  Id_documents INT, 
  Title VARCHAR2(255),
  Theme VARCHAR2(255),
  Shelf VARCHAR2(255),
  Editor VARCHAR2(255),
  Borrow_Id INT,
  CONSTRAINT PK_Documents PRIMARY KEY (Id_documents),
  CONSTRAINT FK_Documents_Editor FOREIGN KEY(Editor) REFERENCES Editors(Name_Editors),
  CONSTRAINT FK_Documents_Borrow FOREIGN KEY(Borrow_Id) REFERENCES Borrows(Id_Borrows));
  
DROP TABLE Books CASCADE CONSTRAINTS;
CREATE TABLE Books (
  Id_books INT, 
  Nb_pages INT,
  Document_Id INT,
  CONSTRAINT PK_Books PRIMARY KEY (Id_books),
  CONSTRAINT FK_Books_Documents FOREIGN KEY(Document_Id) REFERENCES Documents(Id_Documents));

DROP TABLE DVD CASCADE CONSTRAINTS;
CREATE TABLE DVD (
  Id_DVD INT, 
  Duration_DVD NUMBER(10,2),
  Document_Id INT,
  CONSTRAINT PK_DVD PRIMARY KEY (Id_DVD),
  CONSTRAINT FK_DVD_Documents FOREIGN KEY(Document_Id) REFERENCES Documents(Id_Documents));
  
DROP TABLE CD CASCADE CONSTRAINTS;
CREATE TABLE CD (
  Id_CD INT, 
  Duration_CD NUMBER(10,2),
  Nb_subtitles INT,
  Document_Id INT,
  CONSTRAINT PK_CD PRIMARY KEY (Id_CD),
  CONSTRAINT FK_CD_Documents FOREIGN KEY(Document_Id) REFERENCES Documents(Id_Documents));
  
DROP TABLE Videos CASCADE CONSTRAINTS;
CREATE TABLE Videos (
  Id_Videos INT, 
  Duration_Videos NUMBER(10,2),
  Extension VARCHAR2(5),
  Document_Id INT,
  CONSTRAINT PK_Videos PRIMARY KEY (Id_videos),
  CONSTRAINT FK_Videos_Documents FOREIGN KEY(Document_Id) REFERENCES Documents(Id_Documents));

  
-- =-=-=-=-=-=-=-=-=-=-=-= Partie 4. Vï¿½rification de la cohï¿½rence de la base =-=-=-=-=-=-=-=-=-=-=-=

-- =-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-= Triggers =-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-
DROP SEQUENCE id_autor;
CREATE SEQUENCE id_autor;

create or replace trigger trig_autors_id
before insert or update on autors
for each row
begin
select id_autor.NEXTVAL INTO :new.id_autors FROM DUAL;
END;
/

DROP SEQUENCE id_book;
CREATE SEQUENCE id_book;

create or replace trigger trig_books_id
before insert or update on books
for each row
begin
select id_book.NEXTVAL INTO :new.id_books FROM DUAL;
END;
/

DROP SEQUENCE id_borrowers;
CREATE SEQUENCE id_borrowers;

create or replace trigger trig_borrower_id
before insert or update on borrowers
for each row
begin
select id_borrowers.NEXTVAL INTO :new.id_borrower FROM DUAL;
END;
/

DROP SEQUENCE id_borrow;
CREATE SEQUENCE id_borrow;

create or replace trigger trig_borrows_id
before insert or update on borrows
for each row
begin
select id_borrow.NEXTVAL INTO :new.id_borrows FROM DUAL;
END;
/

DROP SEQUENCE CD_id;
CREATE SEQUENCE CD_id;

create or replace trigger trig_CD_id
before insert or update on CD
for each row
begin
select CD_id.NEXTVAL INTO :new.id_CD FROM DUAL;
END;
/

DROP SEQUENCE id_document;
CREATE SEQUENCE id_document;

create or replace trigger trig_document_id
before insert or update on documents
for each row
begin
select id_document.NEXTVAL INTO :new.id_documents FROM DUAL;
END;
/

DROP SEQUENCE DVD_id;
CREATE SEQUENCE DVD_id;

create or replace trigger trig_DVD_id
before insert or update on DVD
for each row
begin
select DVD_id.NEXTVAL INTO :new.id_DVD FROM DUAL;
END;
/

DROP SEQUENCE id_video;
CREATE SEQUENCE id_video;

create or replace trigger trig_videos_id
before insert or update on videos
for each row
begin
select id_video.NEXTVAL INTO :new.id_videos FROM DUAL;
END;
/


create or replace trigger trig_autors_birthday
before insert or update on autors
for each row
begin
if ((sysdate - :new.birthday)/365.25) < 0 then
raise_application_error('-20001', 'Birthday cannot be in the future');
end if;
end;
/

create or replace trigger trig_books_pages
before insert or update on books
for each row
begin 
if (:new.nb_pages <= 0) then
raise_application_error('-20001', 'The number of pages cannot be negative');
end if;
end;
/

ALTER TABLE Books
ADD CONSTRAINT CK_Books_Pages CHECK (nb_pages > 0 );

ALTER TABLE CD
ADD CONSTRAINT CK_CD_Subtitles CHECK (nb_subtitles > 0 );

ALTER TABLE DVD
ADD CONSTRAINT CK_DVD_Duration CHECK (duration_dvd > 0 );

ALTER TABLE CD
ADD CONSTRAINT CK_CD_Duration CHECK (duration_cd > 0 );

ALTER TABLE Videos
ADD CONSTRAINT CK_Videos_Duration CHECK (duration_videos > 0 );

ALTER TABLE Videos
ADD CONSTRAINT CK_Videos_Extension CHECK (extension ='FLV' OR extension ='AVI' OR extension = 'MOV' OR extension ='MP4' OR extension = 'WMV');


-- =-=-=-=-=-=-=-=-=-=-=-= Partie 5. Remplissage de la table =-=-=-=-=-=-=-=-=-=-=-=

-- Authors 

INSERT INTO AUTORS(ID_AUTORS ,NAME_AUTORS , SURNAME_AUTORS,  BIRTHDAY)
    VALUES (0 , 'Joël', 'DICKER',  '16/06/1985') ;
	
INSERT INTO AUTORS(ID_AUTORS ,NAME_AUTORS , SURNAME_AUTORS,  BIRTHDAY)
    VALUES (0 , 'Chu', 'GONG',  '23/10/1988') ;
	
INSERT INTO AUTORS(ID_AUTORS ,NAME_AUTORS , SURNAME_AUTORS,  BIRTHDAY)
    VALUES (0 , 'Adam', 'WOODWORTH',  '06/01/1976') ;
	
INSERT INTO AUTORS(ID_AUTORS ,NAME_AUTORS , SURNAME_AUTORS,  BIRTHDAY)
    VALUES (0 , 'Immanuel', 'KANT',  '22/04/1724') ;
	
INSERT INTO AUTORS(ID_AUTORS ,NAME_AUTORS , SURNAME_AUTORS,  BIRTHDAY)
    VALUES (0 , 'Pierre', 'BOUTRON',  '11/11/1947') ;
	
INSERT INTO AUTORS(ID_AUTORS ,NAME_AUTORS , SURNAME_AUTORS,  BIRTHDAY)
    VALUES (0 , 'Jean-Claude', 'NACHON',  '25/05/1963') ;
	
INSERT INTO AUTORS(ID_AUTORS ,NAME_AUTORS , SURNAME_AUTORS,  BIRTHDAY)
    VALUES (0 , 'Angélique', 'NACHON',  '09/04/1975') ;
	
INSERT INTO AUTORS(ID_AUTORS ,NAME_AUTORS , SURNAME_AUTORS,  BIRTHDAY)
    VALUES (0 , 'Arnaud', 'VIARD',  '22/08/1965') ;
	
INSERT INTO AUTORS(ID_AUTORS ,NAME_AUTORS , SURNAME_AUTORS,  BIRTHDAY)
    VALUES (0 , 'Benjamin', 'BIOLAY',  '24/01/1973') ;
	
INSERT INTO AUTORS(ID_AUTORS ,NAME_AUTORS , SURNAME_AUTORS,  BIRTHDAY)
    VALUES (0 , 'Georges', 'LAUTNER',  '24/01/1926') ;
	
INSERT INTO AUTORS(ID_AUTORS ,NAME_AUTORS , SURNAME_AUTORS,  BIRTHDAY)
    VALUES (0 , 'Richard', 'CARON',  '30/12/1933') ;

INSERT INTO AUTORS(ID_AUTORS ,NAME_AUTORS , SURNAME_AUTORS,  BIRTHDAY)
    VALUES (0 , 'P.J', 'HOGAN',  '30/11/1962') ;
	
INSERT INTO AUTORS(ID_AUTORS ,NAME_AUTORS , SURNAME_AUTORS,  BIRTHDAY)
    VALUES (0 , 'Jarvis', 'TAVERNIER',  '01/01/1963') ;
	
INSERT INTO AUTORS(ID_AUTORS ,NAME_AUTORS , SURNAME_AUTORS,  BIRTHDAY)
    VALUES (0 , 'Kevin', 'MORBY',  '01/06/1958') ;
	
INSERT INTO AUTORS(ID_AUTORS ,NAME_AUTORS , SURNAME_AUTORS,  BIRTHDAY)
    VALUES (0 , 'Timothé', 'MERCADAL',  '29/12/1997') ;
	
INSERT INTO AUTORS(ID_AUTORS ,NAME_AUTORS , SURNAME_AUTORS,  BIRTHDAY)
    VALUES (0 , 'Katheryn', 'HUDSON',  '25/10/1984') ;
	
INSERT INTO AUTORS(ID_AUTORS ,NAME_AUTORS , SURNAME_AUTORS,  BIRTHDAY)
    VALUES (0 , 'David', 'CASTELLO-LOPES',  '16/09/1981') ;
	
INSERT INTO AUTORS(ID_AUTORS ,NAME_AUTORS , SURNAME_AUTORS,  BIRTHDAY)
    VALUES (0 , 'Kyan', 'JHOJANDI',  '29/10/1979') ;
	
INSERT INTO AUTORS(ID_AUTORS ,NAME_AUTORS , SURNAME_AUTORS,  BIRTHDAY)
    VALUES (0 , 'Cyprien', 'IOV',  '26/03/1983') ;
	
INSERT INTO AUTORS(ID_AUTORS ,NAME_AUTORS , SURNAME_AUTORS,  BIRTHDAY)
    VALUES (0 , 'Butters', 'PARKSOUTH',  '25/08/1991') ;
	
INSERT INTO AUTORS(ID_AUTORS ,NAME_AUTORS , SURNAME_AUTORS,  BIRTHDAY)
    VALUES (0 , 'Thibaut', 'GIRAUD',  '30/04/1987') ;

-- Editors

INSERT INTO EDITORS(NAME_EDITORS , ADRESSE , PHONE_NUMBER)
    VALUES ('Edition de Fallois', '22 Rue la Boétie, 75008 Paris' ,  '01 42 66 91 95');
    
INSERT INTO EDITORS(NAME_EDITORS , ADRESSE , PHONE_NUMBER)
    VALUES ('DUNOD', '11 Rue Paul Bert, 92247 Malakoff' ,  '01 41 23 66 00');

INSERT INTO EDITORS(NAME_EDITORS , ADRESSE , PHONE_NUMBER)
    VALUES ('EYROLLES', '55-57-61 Boulevard Saint-Germain, 75005 Paris' ,  '03 21 79 56 75');

INSERT INTO EDITORS(NAME_EDITORS , ADRESSE , PHONE_NUMBER)
    VALUES ('DNC media', '93-2 Myeong Dong SEOUL' ,  '02 333 2514');

INSERT INTO EDITORS(NAME_EDITORS , ADRESSE , PHONE_NUMBER)
    VALUES ('Hachette', '58 Rue Jean Bleuzen, 92170 Vanves' ,  '01 43 25 36 85');

INSERT INTO EDITORS(NAME_EDITORS , ADRESSE , PHONE_NUMBER)
    VALUES ('Expand Drama', '65 Rue de la gare, 93200 SAINT-DENIS' ,  '04 85 84 14 01');

INSERT INTO EDITORS(NAME_EDITORS , ADRESSE , PHONE_NUMBER)
    VALUES ('Gloria films', '26 Rue de la Mairie, 75014 Paris' ,  '09 44 48 15 26');

INSERT INTO EDITORS(NAME_EDITORS , ADRESSE , PHONE_NUMBER)
    VALUES ('Les productions de la Lanterne', '8 AV LA PORTE DE MONTROUGE, 75014 PARIS' ,  '06 36 30 36 30');

INSERT INTO EDITORS(NAME_EDITORS , ADRESSE , PHONE_NUMBER)
    VALUES ('Gaumont Adresse', '30 avenue Charles de Gaulle Nantes 44300' ,  '05 83 12 32 55');

INSERT INTO EDITORS(NAME_EDITORS , ADRESSE , PHONE_NUMBER)
    VALUES ('Columbia pictures', 'Thalberg Building, 10202 West Washington Boulevard, Culver City, California , United States' ,  '08 98 48 16 67');

INSERT INTO EDITORS(NAME_EDITORS , ADRESSE , PHONE_NUMBER)
    VALUES ('Differ Ant', '4 rue du haut des sables, 86000 Poitiers' ,  '05 49 48 47 46');

INSERT INTO EDITORS(NAME_EDITORS , ADRESSE , PHONE_NUMBER)
    VALUES ('Poney Gris', '10 rue de l étang , 12634 Plessis-Robinssons' ,  '04 06 93 94 51');

INSERT INTO EDITORS(NAME_EDITORS , ADRESSE , PHONE_NUMBER)
    VALUES ('Virgin Records', '15 rue de l Hôtel Dieu, 86000 Poitiers' ,  '05 49 45 30 00');

INSERT INTO EDITORS(NAME_EDITORS , ADRESSE , PHONE_NUMBER)
    VALUES ('CANAL+ France', '35 Rue de la Clairière, 45000 Orléans' ,  '07 15 36 55 89 ');

INSERT INTO EDITORS(NAME_EDITORS , ADRESSE , PHONE_NUMBER)
    VALUES ('Youtube', '65 Rue du Moulin, 75000 Paris' ,  '08 09 44 26 14 ');

INSERT INTO EDITORS(NAME_EDITORS , ADRESSE , PHONE_NUMBER)
    VALUES ('Tev and Louis', '901 Cherry Ave – San Bruno, CA 94066' ,  '1 650-253-0000');

INSERT INTO EDITORS(NAME_EDITORS , ADRESSE , PHONE_NUMBER)
    VALUES ('Vortex', 'Arte 8 r Marceau, 92130 Issy les Moulineaux' ,  '01 55 00 77 77');
    
    
-- Categories

INSERT INTO CATEGORIES(NAME_CATEGORIES , NB_DOC_MAX, TIME_BOOK, TIME_CD, TIME_DVD, TIME_VIDEO)
    VALUES ('Personnel', 10, 9, 5, 4, 3);
    
INSERT INTO CATEGORIES(NAME_CATEGORIES , NB_DOC_MAX, TIME_BOOK, TIME_CD, TIME_DVD, TIME_VIDEO)
    VALUES ('Professionnel', 5, 11, 4, 3, 2);
    
INSERT INTO CATEGORIES(NAME_CATEGORIES , NB_DOC_MAX, TIME_BOOK, TIME_CD, TIME_DVD, TIME_VIDEO)
    VALUES ('Public', 3, 3, 3, 2, 1);


-- Borrowers

INSERT INTO BORROWERS(ID_BORROWER, NAME_BORROWER, SURNAME_BORROWER, ADRESSE, PHONE_NUMBER, NAME_CATEGORIE)
    VALUES (0, 'Dupont', 'Dupont', '77 rue du pont St Marc', '06 52 95 62 45', 'Public');

INSERT INTO BORROWERS(ID_BORROWER, NAME_BORROWER, SURNAME_BORROWER, ADRESSE, PHONE_NUMBER, NAME_CATEGORIE)
    VALUES (0, 'Richard', 'Arbani', '119 rue du chapeau', '07 52 17 58 40', 'Personnel');

INSERT INTO BORROWERS(ID_BORROWER, NAME_BORROWER, SURNAME_BORROWER, ADRESSE, PHONE_NUMBER, NAME_CATEGORIE)
    VALUES (0, 'Grosse', 'Bertha', '27 boulevard Allemand', '06 06 06 06 06', 'Public');

INSERT INTO BORROWERS(ID_BORROWER, NAME_BORROWER, SURNAME_BORROWER, ADRESSE, PHONE_NUMBER, NAME_CATEGORIE)
    VALUES (0, 'Gille', 'centzes', '231 boulevard de l`obellisque', '07 60 99 48 26', 'Professionnel');

INSERT INTO BORROWERS(ID_BORROWER, NAME_BORROWER, SURNAME_BORROWER, ADRESSE, PHONE_NUMBER, NAME_CATEGORIE)
    VALUES (0, 'Marcel', 'Pontans', '77 rue du pont St Marc', '07 50 06 35 86', 'Public');

INSERT INTO BORROWERS(ID_BORROWER, NAME_BORROWER, SURNAME_BORROWER, ADRESSE, PHONE_NUMBER, NAME_CATEGORIE)
    VALUES (0, 'David', 'Newell', '789 avenue de l`hôtel Aurore', '04 12 68 29 48', 'Personnel');

INSERT INTO BORROWERS(ID_BORROWER, NAME_BORROWER, SURNAME_BORROWER, ADRESSE, PHONE_NUMBER, NAME_CATEGORIE)
    VALUES (0, 'Léa', 'Lanau', '231 boulevard de l`obellisque', '07 52 21 23 55', 'Public');

INSERT INTO BORROWERS(ID_BORROWER, NAME_BORROWER, SURNAME_BORROWER, ADRESSE, PHONE_NUMBER, NAME_CATEGORIE)
    VALUES (0, 'Marine', 'Picon', '14 rue Jean-Charles Vaint', '06 30 51 45 26', 'Public');

INSERT INTO BORROWERS(ID_BORROWER, NAME_BORROWER, SURNAME_BORROWER, ADRESSE, PHONE_NUMBER, NAME_CATEGORIE)
    VALUES (0, 'Aria', 'Maldin', '8 chemin de l`olivier', '08 09 77 15 26', 'Professionnel');

INSERT INTO BORROWERS(ID_BORROWER, NAME_BORROWER, SURNAME_BORROWER, ADRESSE, PHONE_NUMBER, NAME_CATEGORIE)
    VALUES (0, 'Martin', 'Avok', '16 avenue point de croix', '04 44 59 28 17', 'Personnel');

INSERT INTO BORROWERS(ID_BORROWER, NAME_BORROWER, SURNAME_BORROWER, ADRESSE, PHONE_NUMBER, NAME_CATEGORIE)
    VALUES (0, 'Arthur', 'Chevallais', '78 boulevard du vieux port', '08 09 75 15 29', 'Public');

INSERT INTO BORROWERS(ID_BORROWER, NAME_BORROWER, SURNAME_BORROWER, ADRESSE, PHONE_NUMBER, NAME_CATEGORIE)
    VALUES (0, 'Elène', 'Francine', '11 chemin de l`ancien moulin', '05 22 64 18 22', 'Public');

INSERT INTO BORROWERS(ID_BORROWER, NAME_BORROWER, SURNAME_BORROWER, ADRESSE, PHONE_NUMBER, NAME_CATEGORIE)
    VALUES (0, 'Esteban', 'Lovreau', '16 avenue point de croix', '07 09 88 51 88', 'Public');
 
INSERT INTO BORROWERS(ID_BORROWER, NAME_BORROWER, SURNAME_BORROWER, ADRESSE, PHONE_NUMBER, NAME_CATEGORIE)
    VALUES (0, 'Anaïs', 'Sarone', '77 rue du pont St Marc', '07 88 09 77 48', 'Personnel');

INSERT INTO BORROWERS(ID_BORROWER, NAME_BORROWER, SURNAME_BORROWER, ADRESSE, PHONE_NUMBER, NAME_CATEGORIE)
    VALUES (0, 'Alain', 'Tarn', '142 rue du petit pont', '02 52 68 54 25', 'Professionnel');
    
-- Parties Documents --

-- CD

INSERT INTO CD(ID_CD, DURATION_CD, NB_SUBTITLES, DOCUMENT_ID)
    VALUES (0, 43.24 , 10, 11);

INSERT INTO CD(ID_CD, DURATION_CD, NB_SUBTITLES, DOCUMENT_ID)
    VALUES (0, 33.56, 8, 12);
    
INSERT INTO CD(ID_CD, DURATION_CD, NB_SUBTITLES, DOCUMENT_ID)
    VALUES (0, 12.21, 8, 13);
    
INSERT INTO CD(ID_CD, DURATION_CD, NB_SUBTITLES, DOCUMENT_ID)
    VALUES (0, 77, 13, 14);
    
INSERT INTO CD(ID_CD, DURATION_CD, NB_SUBTITLES, DOCUMENT_ID)
    VALUES (0, 1.32, 1, 15);

-- Vidéo

INSERT INTO VIDEOS(ID_VIDEOS, DURATION_VIDEO, EXTENSION, DOCUMENT_ID)
    VALUES (0, 1.42, 'mov', 16);

INSERT INTO VIDEOS(ID_VIDEOS, DURATION_VIDEO, EXTENSION, DOCUMENT_ID)
    VALUES (0, 5.54, 'mp4', 17);
    
INSERT INTO VIDEOS(ID_VIDEOS, DURATION_VIDEO, EXTENSION, DOCUMENT_ID)
    VALUES (0, 8.03, 'mp4', 18);
    
INSERT INTO VIDEOS(ID_VIDEOS, DURATION_VIDEO, EXTENSION, DOCUMENT_ID)
    VALUES (0, 12.55, 'avi', 19);
    
INSERT INTO VIDEOS(ID_VIDEOS, DURATION_VIDEO, EXTENSION, DOCUMENT_ID)
    VALUES (0, 21.12, 'wmv', 20);
    
-- Documents

INSERT INTO DOCUMENTS(ID_DOCUMENTS, TITLE, THEME, SHELF, EDITOR_NAME, BORROW_ID)
    
commit;


  