DROP TABLE Autors CASCADE CONSTRAINTS;
CREATE TABLE Autors (
  Id_autors INT, 
  Name_autors VARCHAR2(100), 
  Surname_autors VARCHAR2(100), 
  CONSTRAINT PK_Autors PRIMARY KEY (Id_autors));
  
DROP TABLE Editors CASCADE CONSTRAINTS;
CREATE TABLE Editors (
  Name_editors VARCHAR2(100), 
  Adresse VARCHAR2(255), 
  Phone_number INT, 
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

DROP TABLE Borrows CASCADE CONSTRAINTS;
CREATE TABLE Borrows (
  Id_borrows INT, 
  Name_borrows VARCHAR2(255),
  Surname_borrows VARCHAR2(255),
  Adresse VARCHAR2(255), 
  Phone_number INT,
  Name_categorie VARCHAR2(255),
  CONSTRAINT PK_Borrows PRIMARY KEY (Id_borrows),
  CONSTRAINT FK_Borrows_Categories FOREIGN KEY(Name_categorie) REFERENCES Categories(Name_categories));
  
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
  CONSTRAINT FK_Documents_Borrow FOREIGN KEY(Borrow_Id) REFERENCES Borrows(Id_borrows),
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
  Duration_DVD TIMESTAMP,
  Document_Id INT,
  CONSTRAINT PK_DVD PRIMARY KEY (Id_DVD),
  CONSTRAINT FK_DVD_Documents FOREIGN KEY(Document_Id) REFERENCES Documents(Id_Documents));
  
DROP TABLE CD CASCADE CONSTRAINTS;
CREATE TABLE CD (
  Id_CD INT, 
  Duration_CD TIMESTAMP,
  Nb_subtitles INT,
  Document_Id INT,
  CONSTRAINT PK_CD PRIMARY KEY (Id_CD),
  CONSTRAINT FK_CD_Documents FOREIGN KEY(Document_Id) REFERENCES Documents(Id_Documents));
  
DROP TABLE Videos CASCADE CONSTRAINTS;
CREATE TABLE Videos (
  Id_Videos INT, 
  Duration_Videos TIMESTAMP,
  Document_Id INT,
  CONSTRAINT PK_Videos PRIMARY KEY (Id_videos),
  CONSTRAINT FK_Videos_Documents FOREIGN KEY(Document_Id) REFERENCES Documents(Id_Documents));
  