DROP TABLE Autors CASCADE CONSTRAINTS;
CREATE TABLE Autors (
  Id_autors INT, 
  Name_autors VARCHAR2(100), 
  Surname_autors VARCHAR2(100), 
  Birthday DATE,
  CONSTRAINT PK_Autors PRIMARY KEY (Id_autors));
  
DROP TABLE Editors CASCADE CONSTRAINTS;
CREATE TABLE Editors (
  Name_editors VARCHAR2(100), 
  Adresse VARCHAR2(255), 
  Phone_number VARCHAR2(50), 
  CONSTRAINT PK_Editors PRIMARY KEY (Name_editors)); 
  
DROP TABLE Key_words CASCADE CONSTRAINTS;
CREATE TABLE Key_words (
  Name_key_words VARCHAR2(100), 
  CONSTRAINT PK_Key_Words PRIMARY KEY (Name_key_words));
  
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
  Phone_number INT,
  Name_categorie VARCHAR2(255),
  CONSTRAINT PK_Borrowers PRIMARY KEY (Id_borrower),
  CONSTRAINT FK_Borrowers_Categories FOREIGN KEY(Name_categorie) REFERENCES Categories(Name_categories));
  
DROP TABLE Borrows CASCADE CONSTRAINTS;
CREATE TABLE Borrows (
    Id_Borrows INT,
    Begin_borrow DATE,
    End_borrow DATE,
    Borrower,
    CONSTRAINT PK_Borrows PRIMARY KEY (Id_Borrows),
    CONSTRAINT FK_Borrows_Borrower FOREIGN KEY(Borrower) REFERENCES Borrowers(Id_borrower));
  
DROP TABLE Documents CASCADE CONSTRAINTS;
CREATE TABLE Documents (
  Id_documents INT, 
  Title VARCHAR2(255),
  Theme VARCHAR2(255),
  Shelf VARCHAR2(255), 
  Phone_number INT,
  Autor_Id INT,
  Editor_Name VARCHAR2(255),
  Borrow_Id INT,
  Key_word_name VARCHAR2(100),
  CONSTRAINT PK_Documents PRIMARY KEY (Id_documents),
  CONSTRAINT FK_Documents_Autor FOREIGN KEY(Autor_Id) REFERENCES Autors(Id_autors),
  CONSTRAINT FK_Documents_Editor FOREIGN KEY(Editor_Name) REFERENCES Editors(Name_Editors),
  CONSTRAINT FK_Documents_Borrow FOREIGN KEY(Borrow_Id) REFERENCES Borrows(Id_Borrows),
  CONSTRAINT FK_Documents_Key_word FOREIGN KEY(Key_word_name) REFERENCES Key_words(Name_key_words));
  
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
  
-- =-=-=-=-=-=-=-=-=-=-=-= Partie 4. Vérification de la cohérence de la base =-=-=-=-=-=-=-=-=-=-=-=

-- =-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-= Triggers =-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-

CREATE SEQUENCE id_autor;

create or replace trigger trig_autors_id
before insert or update on autors
for each row
begin
select id_autor.NEXTVAL INTO :new.id_autors FROM DUAL;
END;
/

CREATE SEQUENCE id_book;

create or replace trigger trig_books_id
before insert or update on books
for each row
begin
select id_book.NEXTVAL INTO :new.id_books FROM DUAL;
END;
/

CREATE SEQUENCE id_borrowers;

create or replace trigger trig_borrower_id
before insert or update on borrowers
for each row
begin
select id_borrowers.NEXTVAL INTO :new.id_borrower FROM DUAL;
END;
/

CREATE SEQUENCE id_borrow;

create or replace trigger trig_borrows_id
before insert or update on borrows
for each row
begin
select id_borrow.NEXTVAL INTO :new.id_borrows FROM DUAL;
END;
/

CREATE SEQUENCE CD_id;

create or replace trigger trig_CD_id
before insert or update on CD
for each row
begin
select CD_id.NEXTVAL INTO :new.id_CD FROM DUAL;
END;
/

CREATE SEQUENCE id_document;

create or replace trigger trig_document_id
before insert or update on documents
for each row
begin
select id_document.NEXTVAL INTO :new.id_documents FROM DUAL;
END;
/

CREATE SEQUENCE DVD_id;

create or replace trigger trig_DVD_id
before insert or update on DVD
for each row
begin
select DVD_id.NEXTVAL INTO :new.id_DVD FROM DUAL;
END;
/

CREATE SEQUENCE id_video;

create or replace trigger trig_videos_id
before insert or update on videos
for each row
begin
select id_video.NEXTVAL INTO :new.id_videos FROM DUAL;
END;
/

CREATE SEQUENCE id_borrowers;

create or replace trigger trig_borrower_id
before insert or update on borrowers
for each row
begin
select id_borrowers.NEXTVAL INTO :new.id_borrower FROM DUAL;
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

create or replace trigger trig_cd_subtitles
before insert or update on cd
for each row
begin 
if (:new.nb_subtitles <= 0) then
raise_application_error('-20001', 'The number of subtitles cannot be negative');
end if;
end;
/

ALTER TABLE DVD
ADD CONSTRAINT CK_DVD_Duration CHECK (duration_dvd > 0 );

ALTER TABLE CD
ADD CONSTRAINT CK_CD_Duration CHECK (duration_cd > 0 );

ALTER TABLE Videos
ADD CONSTRAINT CK_Videos_Duration CHECK (duration_videos > 0 );

ALTER TABLE Videos
ADD CONSTRAINT CK_Videos_Duration CHECK (extension ='FLV' OR extension ='AVI'OR extension = 'MOV' OR extension ='MP4' OR extension = 'WMV');



commit;


  