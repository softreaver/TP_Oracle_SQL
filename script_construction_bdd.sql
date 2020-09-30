DROP TABLE COND;
DROP TABLE ART;
DROP TABLE EMB;
DROP TABLE FRS;

--1a
create table FRS( CF VARCHAR2(4), NOMF VARCHAR2(20), ADRF VARCHAR2(100), TYPF VARCHAR2(3)); 

--1b solution correcte
-- insert INTO FRS (CF,NOMF,ADRF,TYPF) VALUES (&c,&n,&a,&t);

--1b quelques donn?es sans passer par une requ?te param?tr?e
insert INTO FRS (CF,NOMF,ADRF,TYPF) VALUES ('F01','podium','45 rue des blanches 43777 aix','STA');
insert INTO FRS (CF,NOMF,ADRF,TYPF) VALUES ('F02','sogedis','12 avenue de la Loire 54989 evens','STA');
insert INTO FRS (CF,NOMF,ADRF,TYPF) VALUES ('F03','parna','89 all?es des avions 31000 toulouse','STA');
insert INTO FRS (CF,NOMF,ADRF,TYPF) VALUES ('F04','philmo','78 rue des lilas 43988 Rimes','SPA');
insert INTO FRS (CF,NOMF,ADRF,TYPF) VALUES ('F05','aves','54 rue des mouettes 22334 brignogan','SPA');
insert INTO FRS (CF,NOMF,ADRF,TYPF) VALUES ('F06','prisme','21 all?e du port 66433 Canet','SPA');
insert INTO FRS (CF,NOMF,ADRF,TYPF) VALUES ('F07','padol','9 all?e des pirates 34000 Montpellier','SPE');
insert INTO FRS (CF,NOMF,ADRF,TYPF) VALUES ('F08','vulcain','54 rue Paul Bruhnes 31110 Toulouse','SPE');


--2a
create table EMB(CE VARCHAR2(4),NOME VARCHAR2(20),PDSE NUMBER,QTE NUMBER,COUTE NUMBER,CF VARCHAR2(4));
--INSERT INTO EMB(CE,NOME,PDSE,QTE,COUTE,CF)
--SELECT CE,NOME,PDSE,QTE,COUTE,CF from c##mallak_i.EMB2;

insert into EMB(CE,NOME,PDSE,QTE,COUTE,CF) values ('E01','carton','400','15','4','F03');
insert into EMB(CE,NOME,PDSE,QTE,COUTE,CF) values ('E02','Boite plastique','200','20','5','F03');
insert into EMB(CE,NOME,PDSE,QTE,COUTE,CF) values ('E03','caisse','600','7','10','F01');
insert into EMB(CE,NOME,PDSE,QTE,COUTE,CF) values ('E04','papier','20','78','7','F03');
insert into EMB(CE,NOME,PDSE,QTE,COUTE,CF) values ('E05','aluminium','47','6','9','F08');
insert into EMB(CE,NOME,PDSE,QTE,COUTE,CF) values ('E06','Sac plastique','300','65','3','F07');
insert into EMB(CE,NOME,PDSE,QTE,COUTE,CF) values ('E07','Papier recycl?','30','31','5','F07');
insert into EMB(CE,NOME,PDSE,QTE,COUTE,CF) values ('E08','Film issolant','70','15','10','F08');

--3
--create table ART AS select * from c##mallak_i.ART2;
--create table COND AS select * from c##mallak_i.COND2;
create table ART(CA VARCHAR(4),NOMA VARCHAR2(40), PDSA NUMBER, PRIXA NUMBER,DELAI NUMBER,CF VARCHAR2(4));
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('A01','Television 16-9','3000','500','7','F01');
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('A02','Ecran plat','1000','345','15','F03');
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('A03','Lecteur DVD','1000','75','25','F04');
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('A04','Mini cha?ne de salon','1000','245','12','F05');
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('B01','Tuyau d?arrosage','1000','40','8','F01');
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('B02','beche','523','10','10','F02');
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('B03','arrosoir','700','12','20','F02');
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('E01','Mixeur','1000','50','23','F02');
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('E02','Machine ? pain','1200','75','10','F01');
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
insert into ART(CA,NOMA,PDSA,PRIXA) values ('T03','Rideau','700','30');
insert into ART(CA,NOMA,PDSA,PRIXA) values ('T04','nappe','500','15');


CREATE table COND(CA VARCHAR(4), CE VARCHAR(4), NBART NUMBER);
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
/*5*/
alter table ART add constraint pc_art PRIMARY KEY (CA);
alter table EMB add constraint pc_emb PRIMARY KEY (CE);
alter table FRS add constraint pc_frs PRIMARY KEY (CF);
alter table COND add constraint pc_cond PRIMARY KEY (CA,CE);

alter table ART add constraint fc_art FOREIGN KEY (CF) references FRS(CF);
alter table EMB add constraint fc_emb FOREIGN KEY (CF) references FRS(CF);
alter table COND add constraint fc1_art FOREIGN KEY (CA) references ART(CA);
alter table COND add constraint fc2_art FOREIGN KEY (CE) references EMB(CE);


alter table ART modify (NOMA VARCHAR(40) NOT NULL);
alter table ART modify (PRIXA NUMBER NOT NULL);

alter table EMB modify (CF VARCHAR2(4) NOT NULL);
alter table EMB modify (qte NUMBER Default 0);

/*6*/

--a
alter table FRS add constraint tf_frs Check (TYPF IN ('STA','SPA','SPE'));
--b
alter table EMB add constraint tf_emb Check (COUTE <>0);
--c
alter table COND add constraint tf_cond Check (nbart is not NULL AND nbart <>0);
--d
alter table ART add constraint tf_art Check (CA LIKE 'A%' OR CA LIKE 'B%'OR CA LIKE 'E%' OR CA LIKE 'L%' OR CA LIKE 'M%'OR CA LIKE 'T%');

/*v?rification 
insert into ART(CA,NOMA,PDSA,PRIXA,DELAI,CF) values ('s01','Television 16-9','3000','500','7','F01');*/


--e
alter table ART add constraint tf_art2 Check ((CF IS NOT NULL) OR (( CA LIKE 'T%') AND (DELAI IS NULL)));
--f
alter table ART add constraint tf_art3 Check (
   ( CA like 'T%' and DELAI is null)
or (CA like 'M%' and PRIXA>1500)
or (DELAI<16 and (CA LIKE 'L%' OR (CA LIKE 'T%' AND CF IS NOT NULL)))
 OR (DELAI <30 AND (CA LIKE 'A%' OR CA LIKE 'B%' OR CA LIKE 'E%'))
 OR (DELAI <90 AND (CA LIKE 'M%' AND PRIXA < 1501) )
);

--g

alter table ART add constraint tf_art4 Check (DELAI BETWEEN 7 AND 180);

/*7*/
--a
insert into COND (CA,CE,NBART) values ('A01','E09','9');
--b
delete from ART WHERE CA='A01';

/*8*/
--a
update ART
SET DELAI='14'
WHERE CF IS NOT NULL AND CF<>'F01';

/*b solution correcte
Update ART
SET DELAI=&delai 
Where CA=&ca;
*/

UPDATE ART
SET DELAI=DELAI*2
WHERE CA='M01';
