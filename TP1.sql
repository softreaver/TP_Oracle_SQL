
--- QUESTION 1 ---
SET AUTOCOMMIT ON;

CREATE TABLE FRS(
    CF      char(3),
    NOMF    varchar(20),
    ADRF    varchar(150),
    TYPEF   char(3)
);

INSERT INTO FRS VALUES ('&CODE_FOURNISSEUR', '&NOM_FOURNISSEUR', '&ADRESSE_FOURNISSEUR', '&TYPE_FOURNISSEUR');


--- QUESTION 2 ---

create table EMB(CE VARCHAR2(4),NOME VARCHAR2(20),PDSE NUMBER,QTE NUMBER,COUTE NUMBER,CF VARCHAR2(4));

insert into EMB(CE,NOME,PDSE,QTE,COUTE,CF) values ('E01','carton','400','15','4','F03');
insert into EMB(CE,NOME,PDSE,QTE,COUTE,CF) values ('E02','Boite plastique','200','20','5','F03');
insert into EMB(CE,NOME,PDSE,QTE,COUTE,CF) values ('E03','caisse','600','7','10','F01');
insert into EMB(CE,NOME,PDSE,QTE,COUTE,CF) values ('E04','papier','20','78','7','F03');
insert into EMB(CE,NOME,PDSE,QTE,COUTE,CF) values ('E05','aluminium','47','6','9','F08');
insert into EMB(CE,NOME,PDSE,QTE,COUTE,CF) values ('E06','Sac plastique','300','65','3','F07');
insert into EMB(CE,NOME,PDSE,QTE,COUTE,CF) values ('E07','Papier recyclé','30','31','5','F07');
insert into EMB(CE,NOME,PDSE,QTE,COUTE,CF) values ('E08','Film issolant','70','15','10','F08');
GRANT SELECT ON EMB TO public;
GRANT SELECT ON EMB TO C##User1;

--- QUESTION 3 ---

CREATE TABLE ART(
    CA      char(3),
    NOMA    varchar(50),
    PDSA    number(10),
    PRIXA   number(10),
    DELAI   number(10),
    CF      char(3)
);

insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('A01','Television 16-9','3000','500','7','F01');
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('A02','Ecran plat','1000','345','15','F03');
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('A03','Lecteur DVD','1000','75','25','F04');
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('A04','Mini chaîne de salon','1000','245','12','F05');
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('B01','Tuyau d’arrosage','1000','40','8','F01');
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('B02','beche','523','10','10','F02');
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('B03','arrosoir','700','12','20','F02');
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('E01','Mixeur','1000','50','23','F02');
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('E02','Machine à pain','1200','75','10','F01');
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('E03','Machine a laver le linge','70000','200','18','F02');
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('E04','Machine a laver la vaisselle','80000','300','27','F06');
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('L01','Console de jeu','750','100','11','F01');
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('L02','Raquette de tennis','400','20','9','F04');
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('L03','Lot de 4 balles de tenis','300','7','7','F06');
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('M01','Lit pour enfant','5000','150','60','F01');
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('M02','lampe','750','20','80','F03');
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('M03','canape','60000','2000','100','F06');
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('T01','Sac en cuir','523','60','8','F01');
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('T02','Bottes en cuir','400','70','7','F05');
insert into ART(CA,NOMA,PDSA,PRIXA, DELAI,CF) values ('T03','Rideau','700','30',NULL, NULL);
insert into ART(CA,NOMA,PDSA,PRIXA, DELAI,CF) values ('T04','nappe','500','15', NULL, NULL);

GRANT SELECT ON ART TO public;


CREATE TABLE COND(
    CA      char(3),
    CE      char(3),
    NBART   number(10)
);

insert into COND (CA,CE,NBART) values ('A01','E01','4');
insert into COND (CA,CE,NBART) values ('A01','E03','5');
insert into COND (CA,CE,NBART) values ('A01','E06','1');
insert into COND (CA,CE,NBART) values ('A02','E02','5');
insert into COND (CA,CE,NBART) values ('A03','E01','2');
insert into COND (CA,CE,NBART) values ('A04','E03','8');
insert into COND (CA,CE,NBART) values ('A04','E06','4');
insert into COND (CA,CE,NBART) values ('A04','E07','2');
insert into COND (CA,CE,NBART) values ('B01','E03','4');
insert into COND (CA,CE,NBART) values ('B02','E04','1');
insert into COND (CA,CE,NBART) values ('B03','E02','2');
insert into COND (CA,CE,NBART) values ('E01','E01','2');
insert into COND (CA,CE,NBART) values ('E02','E03','2');
insert into COND (CA,CE,NBART) values ('E03','E02','4');
insert into COND (CA,CE,NBART) values ('E04','E04','2');
insert into COND (CA,CE,NBART) values ('L01','E03','7');
insert into COND (CA,CE,NBART) values ('L01','E07','7');
insert into COND (CA,CE,NBART) values ('L01','E02','2');
insert into COND (CA,CE,NBART) values ('L02','E01','3');
insert into COND (CA,CE,NBART) values ('L03','E04','1');
insert into COND (CA,CE,NBART) values ('M01','E02','1');
insert into COND (CA,CE,NBART) values ('M02','E03','1');
insert into COND (CA,CE,NBART) values ('M03','E01','1');
insert into COND (CA,CE,NBART) values ('T01','E02','3');
insert into COND (CA,CE,NBART) values ('T02','E05','2');
insert into COND (CA,CE,NBART) values ('T03','E01','4');
insert into COND (CA,CE,NBART) values ('T03','E06','5');
insert into COND (CA,CE,NBART) values ('T04','E05','4');

GRANT SELECT ON COND TO public;


--- QUESTION 4 ---

DESC ART;
/*
Nom   NULL ? Type         
----- ------ ------------ 
CA           CHAR(3)      
NOMA         VARCHAR2(50) 
PDSA         NUMBER(10)   
PRIXA        NUMBER(10)   
DELAI        NUMBER(10)   
CF           CHAR(3)  
*/

SELECT * FROM ART;
/*
A01	Television 16-9	3000	500	7	F01
A02	Ecran plat	1000	345	15	F03
A03	Lecteur DVD	1000	75	25	F04
ETC ....
*/

DESC COND;
/*
Nom   NULL ? Type       
----- ------ ---------- 
CA           CHAR(3)    
CE           CHAR(3)    
NBART        NUMBER(10) 
*/


SELECT * FROM COND;
/*
A01	E01	4
A01	E03	5
A01	E06	1
ETC....
*/


DESC EMB;
/*
Nom   NULL ? Type         
----- ------ ------------ 
CE           VARCHAR2(4)  
NOME         VARCHAR2(20) 
PDSE         NUMBER       
QTE          NUMBER       
COUTE        NUMBER       
CF           VARCHAR2(4) 
*/


SELECT * FROM EMB;
/*
E01	carton	400	15	4	F03
E02	Boite plastique	200	20	5	F03
E03	caisse	600	7	10	F01
ETC....
*/


DESC FRS;
/*
Nom   NULL ? Type          
----- ------ ------------- 
CF           CHAR(3)       
NOMF         VARCHAR2(20)  
ADRF         VARCHAR2(150) 
TYPEF        CHAR(3)  
*/


SELECT * FROM FRS;
/*
F01	podium	45 rue des blanches 43777 aix	STA
F02	sogedis	12 avenue de la Loire 54989 evens	STA
F03	parna	89 allées des avions 31000 toulouse	STA
ETC....
*/

--- QUESTION 5 ---

ALTER TABLE ART
ADD CONSTRAINT PK_CA PRIMARY KEY (CA);

ALTER TABLE COND
ADD CONSTRAINT PK_CA_CE PRIMARY KEY (CA, CE);

ALTER TABLE EMB
ADD CONSTRAINT PK_CE PRIMARY KEY (CE);

ALTER TABLE FRS
ADD CONSTRAINT PK_CF PRIMARY KEY (CF);

ALTER TABLE ART
MODIFY NOMA NOT NULL;

ALTER TABLE ART
MODIFY PRIXA NOT NULL;

ALTER TABLE EMB
MODIFY CF NOT NULL;

ALTER TABLE EMB
MODIFY QTE DEFAULT 0;

ALTER TABLE ART
ADD CONSTRAINT FK_ART_FRS FOREIGN KEY (CF)
    REFERENCES FRS(CF);
    
ALTER TABLE EMB
MODIFY CF
CHAR(3);

ALTER TABLE EMB
ADD CONSTRAINT FK_EMB_FRS FOREIGN KEY (CF)
    REFERENCES FRS(CF);
    
ALTER TABLE EMB
MODIFY CE
CHAR(3);

ALTER TABLE COND
ADD CONSTRAINT FK_COND_EMB FOREIGN KEY (CE)
    REFERENCES EMB(CE);

ALTER TABLE COND
ADD CONSTRAINT FK_COND_ART FOREIGN KEY (CA)
    REFERENCES ART(CA);

DESC FRS;

--- QUESTION 6 ---

-- a) le type d’un fournisseur (toujours renseigné) est soit STA, soit SPA, soit SPE :
ALTER TABLE FRS
MODIFY TYPEF NOT NULL;

ALTER TABLE FRS
MODIFY TYPEF
CONSTRAINT typef_constraint
CHECK(TYPEF = 'STA' OR TYPEF = 'SPA' OR TYPEF = 'SPE');

-- b) le coût d’un emballage ne peut pas être nul (mais peut être inconnu) :
ALTER TABLE EMB
MODIFY COUTE
CONSTRAINT coute_non_nul
CHECK(COUTE > 0);

-- c) le nombre d’articles dans tout conditionnement est toujours connu (non « null ») et ne peut être nul :
ALTER TABLE COND
MODIFY NBART NOT NULL;

ALTER TABLE COND
MODIFY NBART
CONSTRAINT nb_art_non_nul
CHECK(NBART > 0);

-- d) le type d’un article (1er caractère du code) doit être A, B, E, L, M ou T :
ALTER TABLE ART
MODIFY CA
CONSTRAINT ca_commence_par_A_B_E_L_M_ou_T
CHECK(CA LIKE 'A%' OR CA LIKE 'B%' OR CA LIKE 'E%' OR CA LIKE 'L%' OR CA LIKE 'M%' OR CA LIKE 'T%');

-- e) seuls, les articles textiles peuvent être fabriqués, c'est-à-dire sans fournisseur (code fournisseur inconnu) ; et dans ce cas, le délai de livraison n’est pas enregistré :
ALTER TABLE ART
ADD CONSTRAINT fabrication_textile
CHECK(CA LIKE 'T%' OR CF IS NOT NULL);

ALTER TABLE ART
ADD CONSTRAINT delai_inconnu
CHECK((CF IS NOT NULL AND DELAI IS NOT NULL) OR (CF IS NULL AND DELAI IS NULL));

-- f) le délai de livraison ne peut excéder 15 jours pour les articles de loisir et les
-- textiles non fabriqués ; il ne peut excéder 30 jours pour l’audiovisuel, le bricolage
-- et l’électroménager ; il ne peut excéder 90 jours pour le mobilier, sauf si le prix de
-- vente dépasse 1500 euros :
ALTER TABLE ART
ADD CONSTRAINT contraintes_delai
CHECK(
    (CA LIKE 'T%' AND CF IS NULL) OR
    (
        (CA LIKE 'L%' OR (CA LIKE 'T%' AND CF IS NOT NULL)) AND
        (DELAI <= 15)
    ) OR
    (
        (CA LIKE 'A%' OR CA LIKE 'B%' OR CA LIKE 'E%') AND
        (DELAI <= 30)
    ) OR
    (
        (CA LIKE 'M%' AND PRIXA <= 1500) AND
        (DELAI <= 90)
    ) OR
    (CA LIKE 'M%' AND PRIXA > 1500)
);

-- g) les délais de livraison sont tous compris entre 7 et 180 jours. :
ALTER TABLE ART
MODIFY DELAI
CONSTRAINT contrainte_delai_min_max
CHECK(DELAI BETWEEN 7 AND 180);

--- QUESTION 7 ---
-- a) Rajouter le conditionnement de l’article A01 dans l’emballage E09 en quantité 9, conclure : 
INSERT INTO COND VALUES ('A01', 'E09', 9);

-- Erreur commençant à la ligne: 310 de la commande -
-- INSERT INTO COND VALUES ('A01', 'E09', 9)
-- Rapport d'erreur -
-- ORA-02291: violation de contrainte d'intégrité (C##USER1.FK_COND_EMB) - clé parent introuvable
-- CONCLUSION :
-- Cela ne fonctionne pas à cause de la contrainte de clef étrangère. En effet, l'emballage ayant l'ID 'E09' n'existe pas !

-- b) Supprimer l’article A01 de la table ART ; conclure :
DELETE FROM ART 
WHERE CA = 'A01';

-- Erreur commençant à la ligne: 315 de la commande -
-- DELETE FROM ART 
-- WHERE CA = 'A01'
-- Rapport d'erreur -
-- ORA-02292: violation de contrainte (C##USER1.FK_COND_ART) d'intégrité - enregistrement fils existant
-- CONCLUSION
-- Idem qu'au dessus, cela n'est pas permis par la contrainte de clef étrangère. Il faut supprimer tous les tuples de la table COND
-- avant de pouvoir jouer cette requête SQL.

--- QUESTION 8 ---
-- a) Mettre tous les délais de livraison à 14 jours, sauf si le fournisseur n’est pas
-- connu ou s’il s’agit de F01 (13 lignes mises à jour) :
UPDATE ART
    SET DELAI = 14
    WHERE (
        CF != 'F01' AND CF IS NOT NULL
    );
-- 13 lignes mis à jour. OK

-- b) Modifier ces données, en utilisant une requête contenant des variables de
-- substitution, pour prendre en compte les délais suivants : 28 jours pour les articles
-- E02 et E03, 30 jours pour M03, 60 jours pour M01 et M02 :
UPDATE ART
    SET DELAI = &DELAI
    WHERE CA = '&CODE_ARTICLE';

-- c) Doubler le délai de livraison de M01
-- Vérifier le contenu de la table ART (voir annexe) puis valider :
UPDATE ART
    SET DELAI = (DELAI * 2)
    WHERE CA = 'M01';
-- Rapport d'erreur -
-- ORA-02290: violation de contraintes (C##USER1.CONTRAINTES_DELAI) de vérification
-- Le meuble doit couter plus de 1500 euros pour pouvoir avoir un delai de plus de 90 jours !

-- -----Modifier la longueur de la colonne NOMA de ART ------
    -- a) la diminuer (varchar2(10)) ; conclure :
    ALTER TABLE ART
    MODIFY NOMA
    VARCHAR2(10);
    -- Rapport d'erreur -
    -- ORA-01441: impossible de diminuer la largeur de colonne : certaines valeurs sont trop élevées
    -- 01441. 00000 -  "cannot decrease column length because some value is too big"
    -- CONCLUSION :
    -- On ne peut pas diminuer la taille des chaines de caracteres si cette limite a pour consequence la perte de donnees.
    
    -- b) l’augmenter (varchar2(26)) ; conclure :
    ALTER TABLE ART
    MODIFY NOMA
    VARCHAR2(26);
    -- CONCLUSION :
    -- IDEM au dessus
    
    -- c) l’augmenter (varchar2(32)) ; conclure :
    ALTER TABLE ART
    MODIFY NOMA
    VARCHAR2(32);
    -- CONCLUSION :
    -- Cela a fonctionne, on peu conclure que la taille de la plus grande chaine ne depasse pas 32 caracteres.
