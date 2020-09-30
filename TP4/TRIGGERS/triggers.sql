-- IV) Les TRIGGERS (ces requ�tes seront sauvegard�es dans le r�pertoire BD/TP4/TRIGGERS)
-- N.B. Pour faciliter la maintenance, on veillera � n�avoir qu�un seul � before trigger � et /ou un seul � after trigger � par table.
-- Pour cela, avant de cr�er un nouveau trigger, on s�assurera au pr�alable qu�il ne faut pas plut�t modifier un trigger d�j� existant. 
 
-- Apr�s la cr�ation de chaque trigger, on testera syst�matiquement � son efficacit� � en ex�cutant des fichiers de commande de test.

-- 1) G�n�ration automatique des valeurs de colonnes � d�riv�es �
--      a - Cr�er le trigger qui assure la mise � jour automatique de la colonne NBEMB de ART � chaque adjonction ou suppression d�un conditionnement d�article.
        CREATE OR REPLACE TRIGGER update_nbemb
            AFTER INSERT OR DELETE ON cond
            DECLARE
                total_cond number;
            BEGIN
                FOR articles IN (SELECT DISTINCT art.ca FROM art)
                LOOP
                    SELECT COUNT(*) into total_cond FROM cond
                        WHERE cond.ca = articles.ca;
                    UPDATE art
                        SET nbemb = total_cond
                            WHERE art.ca = articles.ca;
                END LOOP;
            END;
        /
        -- El�ment Trigger UPDATE_NBEMB compil�

--        - tester son efficacit� en ex�cutant le fichier de requ�tes ci-dessous qui effectue :
--              - un premier affichage partiel de la table ART,
                SELECT * FROM ART WHERE ca = 'A01' or ca = 'T03';
                    -- A01	Television 16-9	3000	500	7	F01	3
                    -- T03	Rideau	    700	 30	  (null) (null)	2
                    
--              - puis l�adjonction du conditionnement suivant : 1 article A01 dans l�emballage E07,
                INSERT INTO cond VALUES ('A01', 'E07', 1, 0, 0);

--              - puis la suppression du conditionnement de l�article T03 dans l�emballage E06
                DELETE FROM cond
                WHERE cond.ca = 'T03' and cond.ce = 'E06';
                -- 1 ligne supprim�.

--              - puis un deuxi�me affichage partiel de la table ART (v�rifier alors les nouvelles valeurs de NBEMB pour A01 et T03)
                SELECT * FROM ART WHERE ca = 'A01' or ca = 'T03';
                -- A01	Television 16-9	3000	500	 7	   F01	  4
                -- T03	Rideau	        700	    30	(null) (null) 1
                
--              - et enfin la remise des tables dans leur �tat initial (rollback)
                ROLLBACK;
                -- Annulation (rollback) termin�e.

--      b - Les types des articles et des fournisseurs devant �tre en majuscules, cr�er les 2 triggers (ou les modifier s�ils existent d�j�) qui r�alisent syst�matiquement la prise en compte de ces types en majuscules :
--          i) Lors de l�adjonction d�un nouvel article 
            CREATE OR REPLACE TRIGGER uppercase_art
            BEFORE INSERT ON art
            FOR EACH ROW
            BEGIN
                :new.ca := UPPER(:new.ca);
            END;
        /
        -- El�ment Trigger UPPERCASE_ART compil�

--          ii) Lors de l�adjonction d�un nouveau fournisseur ou de la modification du type d�un fournisseur existant.
            CREATE OR REPLACE TRIGGER uppercase_frs
            BEFORE INSERT OR UPDATE ON frs
            FOR EACH ROW
            BEGIN
                :new.typf := UPPER(:new.typf);
            END;
        /
        -- El�ment Trigger UPPERCASE_FRS compil�

--      c - Cr�er le trigger (ou le modifier s�il existe d�j�) qui assure la mis � jour automatique de la colonne COUTBRUT de COND � chaque modification de COUTE dans EMB (pr�voir les cas o� le nouveau ou l�ancien COUTE est inconnu)
        CREATE OR REPLACE TRIGGER update_coutbrut_of_cond
            AFTER UPDATE OF coute ON emb
        BEGIN
            UPDATE cond
            SET COUTBRUT =  (
                SELECT ((art.prixa * cond.nbart) + emb.coute) FROM art
                INNER JOIN emb ON emb.ce = cond.ce
                WHERE cond.ca = art.ca
            );
        END;
        /
        -- El�ment Trigger UPDATE_COUTBRUT_OF_COND compil�

-- 2) Contr�le de la validit� d�une transaction
-- Cr�er le trigger qui emp�che toute mise � jour (adjonction-suppression-modification) de la table FRS le jour de la semaine (lundi, mardi, �) correspondant � votre s�ance de TP : tester son efficacit�.
    CREATE OR REPLACE TRIGGER day_restriction_on_frs
    BEFORE INSERT OR UPDATE OR DELETE ON frs
    DECLARE
        day_name VARCHAR(10);
    BEGIN
        SELECT to_char(SYSDATE, 'day') into day_name FROM dual;
        IF day_name = 'vendredi' THEN
            raise_application_error ( -20000 , 'Le '||day_name||', rien n''est permi !' );
        END IF;
    END;
    /
    -- El�ment Trigger DAY_RESTRICTION_ON_FRS compil�
    
    -- TEST DE LA RESTRICTION (Rien n'est autoris� le vendredi)
    UPDATE frs SET typf = 'spe';
        -- ORA-20000: Le vendredi, rien n'est permi !

-- 3) Consultation du dictionnaire de donn�es
SELECT * FROM USER_TRIGGERS;
-- Consulter la structure et le contenu � int�ressant � de la vue concernant vos triggers et v�rifier que vous avez bien les triggers suivants :
--		T_A_DI_COND
--		T_B_I_ART
--		T_B_IU_FRS
--		T_A_U_EMB
--		ST_B_DIU_FRS
-- Supprimer le trigger ST_B_DIU_FRS cr�� � la question 2 ; reconsulter le D.D.
DROP TRIGGER day_restriction_on_frs;
-- Trigger DAY_RESTRICTION_ON_FRS supprim�(e).

-- 4) G�n�ration automatique d��v�nements
--      a) Cr�er la table EMB_A_CDR, contenant une colonne CE (code des emballages � commander) et une colonne DATE_CDE de type date.
        CREATE TABLE emb_a_cdr (
            ce varchar(4) NOT NULL,
            date_cde date
        );

--      b) Cr�er le trigger (ou le modifier s�il existe d�j�) qui ins�re automatiquement une ligne dans cette table chaque fois que la quantit� en stock d�un emballage passe en dessous de 5, avec la date correspondant � ce passage.
        CREATE OR REPLACE TRIGGER alarm_low_stock_emb
            AFTER UPDATE OF qte ON emb
                FOR EACH ROW
        BEGIN
            IF :old.qte >= 5 and :new.qte < 5 THEN
                INSERT INTO emb_a_cdr
                    VALUES (:old.ce, SYSDATE);
            END IF;
        END;
        /
        -- El�ment Trigger ALARM_LOW_STOCK_EMB compil�

--      c) Tester ce trigger.
        UPDATE emb SET qte = 5 WHERE ce = 'E01';
        SELECT * FROM emb_a_cdr;
        -- OK, aucun enregistrement dans emb_a_cdr
        
        UPDATE emb SET qte = 3 WHERE ce = 'E01';
        SELECT * FROM emb_a_cdr;
        -- OK, 1 enregistrement :        
        -- E01	07/08/20

-- 5) Mise en place de contraintes complexes
-- Cr�er (ou modifier s�ils existent d�j�) les triggers assurant la mise en place des contraintes suivantes :
--      a - Il y a 1 conditionnement minimum et 5 conditionnements maximum par article.
        CREATE GLOBAL TEMPORARY TABLE TEMP_COND AS SELECT * FROM COND WHERE 0=1;
        -- Global temporary TABLE cr��(e).
        
        CREATE OR REPLACE TRIGGER BEFORE_MINI_COND_CHECK BEFORE DELETE ON cond FOR EACH ROW 
        BEGIN 
            INSERT INTO TEMP_COND(ca, ce, nbart, prixnet, coutbrut) VALUES (:new.ca, :new.ce, :new.nbart, :new.prixnet, :new.coutbrut);
        END ;
        /
        -- El�ment Trigger BEFORE_MINI_COND_CHECK compil�

        CREATE OR REPLACE TRIGGER minimum_cond
        AFTER DELETE ON cond
        DECLARE
            art_qty number;
        BEGIN
            FOR entry IN (SELECT * FROM TEMP_COND) LOOP 
                SELECT COUNT(cond.ca) into art_qty FROM cond WHERE cond.ca = entry.ca;
                IF art_qty <= 1 THEN
                    INSERT INTO cond(ca, ce, nbart, prixnet, coutbrut) VALUES('T', entry.ce, entry.nbart, entry.prixnet, entry.coutbrut); 
                    DBMS_OUTPUT.PUT_LINE( 'Il doit y avoir au minimum un conditionnement par article !' );
                END IF;
            END LOOP;
            DELETE FROM TEMP_COND;
        END;
        /
        -- El�ment Trigger MINIMUM_COND compil�
        
        -- TEST :
        DELETE FROM cond
        WHERE ca = 'T03';
        ROLLBACK;
        
        CREATE OR REPLACE TRIGGER maximum_cond
            BEFORE INSERT ON cond
                FOR EACH ROW
        DECLARE
            art_qty number;
        BEGIN
            SELECT COUNT(cond.ca) into art_qty FROM cond WHERE cond.ca = :new.ca;
            IF art_qty >= 5 THEN
                raise_application_error ( -20002 , 'Maximum 5 conditionnements par article !' );
            END IF;
        END;
        /
        -- El�ment Trigger MAXIMUM_COND compil�

--      b - Tout fournisseur d�articles (figurant dans ART)  doit �tre de type STA ou SPA
        CREATE OR REPLACE TRIGGER frs_type_check
        BEFORE INSERT OR UPDATE ON frs
        FOR EACH ROW
        DECLARE
            count_cf_in_art number;
        BEGIN
            SELECT count(cf) into count_cf_in_art FROM art WHERE cf = :new.cf;
            IF :new.typf != 'STA' AND :new.typf != 'SPA' THEN
                raise_application_error ( -20003 , 'Les fournisseurs d''article doivent �tre de type STA ou SPA.' );
            END IF;
        END;
        /
        -- El�ment Trigger FRS_TYPE_CHECK compil�
        
        -- TEST
        UPDATE frs SET typf = 'STA' WHERE cf = 'F01';
        -- OK : 1 ligne mis � jour.
        UPDATE frs SET typf = 'SPE' WHERE cf = 'F01';
        -- OK : ORA-20003: Les fournisseurs d'article doivent �tre de type STA ou SPA.

        ROLLBACK;
        
--      c - Tout fournisseur d�emballages (figurant dans EMB) doit �tre de type STA ou SPE
        CREATE OR REPLACE TRIGGER frs_type_check_for_emb
        BEFORE INSERT OR UPDATE ON frs
        FOR EACH ROW
        DECLARE
            count_cf_in_emb number;
        BEGIN
            SELECT count(cf) into count_cf_in_emb FROM emb WHERE cf = :new.cf;
            IF :new.typf != 'STA' AND :new.typf != 'SPA' THEN
                raise_application_error ( -20004 , 'Les fournisseurs d''emballage doivent �tre de type STA ou SPA.' );
            END IF;
        END;
        /
        -- El�ment Trigger FRS_TYPE_CHECK_FOR_EMB compil�
        
        -- TEST
        UPDATE frs SET typf = 'STA' WHERE cf = 'F08';
        -- OK : 1 ligne mis � jour.
        UPDATE frs SET typf = 'SPE' WHERE cf = 'F08';
        -- OK : ORA-20004: Les fournisseurs d'emballage doivent �tre de type STA ou SPA.

-- 6) Utilisation des � instead of � triggers (facultatif mais int�ressant)
--      a - Cr�er la vue VPAPIER (CE, NOME, COUTE, CF, NOMA, NBART) correspondant aux codes, nom co�t et fournisseur des caisses (emballages dont le nom contient le mot � papier �), avec pour chacune, les noms et nombres d�articles qui y sont conditionn�s. V�rifier son � contenu �.
        CREATE OR REPLACE VIEW VPAPIER
        AS SELECT emb.ce, emb.nome, emb.qte, emb.cf, art.noma, cond.nbart FROM emb
            INNER JOIN cond ON cond.ce = emb.ce
                INNER JOIN art ON cond.ca = art.ca
                    WHERE emb.nome LIKE '%papier%';
        -- View VPAPIER cr��(e).
        
        SELECT * FROM VPAPIER;
        /*
            E04	papier	78	F03	beche	1
            E04	papier	78	F03	Machine a laver la vaisselle	2
            E04	papier	78	F03	Lot de 4 balles de tenis	1
        */

--      b -Cette vue sera mise � la disposition du magasinier responsable des caisses y pourra y � ins�rer des lignes � ; l�insertion d�une ligne dans cette vue correspondra :
--          -soit � la prise en compte d�une nouvelle caisse, avec sp�cification obligatoire de son code, son nom et son fournisseur et �ventuellement, son co�t, le nom du 1er article conditionnable et le nombre correspondant. Le nom de l�emballage devra alors contenir le mot � caisse � ; si ce n�est pas le cas, on le rajoutera automatiquement en fin du nom.
--          -soit � la prise en compte d�un nouveau conditionnement dans une caisse d�j� existante avec sp�cification obligatoire du code emballage  et du nom de l�article conditionnable.
--      Dans les deux cas, si le nombre n�est pas pr�cis�, on le prendra �gal � 1.
--      Cr�er le trigger qui remplace l�insertion d�une ligne dans la vue VPAPIER par l�insertion d�une ligne dans EMB si l�emballage n�est pas r�pertori�,  puis d�une ligne dans COND le cas �ch�ant.
--      Tester son efficacit�.
        

-- 7) G�n�ration automatique des valeurs de colonnes d�riv�es (suite question 1)
--      a - Cr�er le trigger (ou le modifier s�il existe d�j�) qui effectue le calcul automatique des colonnes PRIXNET et COUTBRUT de COND � chaque prise en compte d�un conditionnement ou � chaque modification de NBART.
        CREATE OR REPLACE TRIGGER update_prixnet_coutbrut_cond
        AFTER INSERT OR UPDATE OF nbart ON cond
        DECLARE
            prix_net NUMBER(38,0);
            cout_brut NUMBER(38,0);
            prix_unitaire NUMBER(38,0);
            cout_emb NUMBER(38, 0);
        BEGIN 
            FOR line IN (SELECT * FROM cond) LOOP
                SELECT art.prixa into prix_unitaire FROM art WHERE ca = line.ca;
                SELECT emb.coute into cout_emb FROM emb WHERE ce = line.ce;
                prix_net := line.nbart * prix_unitaire;
                cout_brut := prix_net + cout_emb;
                UPDATE cond
                SET prixnet = prix_net, coutbrut = cout_brut
                WHERE cond.ca = line.ca AND cond.ce = line.ce;
            END LOOP;
        END;
        /
        -- El�ment Trigger UPDATE_PRIXNET_COUTBRUT_COND compil�
        
        -- TEST
        SELECT * FROM cond WHERE ca = 'A01' AND ce = 'E03';
        -- A01	E03	1	500	510
        UPDATE cond SET nbart = nbart + 1 WHERE ca = 'A01' AND ce = 'E03';
        -- 1 ligne mis � jour.
        SELECT * FROM cond WHERE ca = 'A01' AND ce = 'E03';
        -- OK :
        -- A01	E03	2	1000	1010
        INSERT INTO cond(ca, ce, nbart) VALUES('A01', 'E04', 20);
        -- 1 ligne ins�r�.
        SELECT * FROM cond WHERE ca = 'A01' AND ce = 'E04';
        -- OK
        -- A01	E04	20	10000	10007
        ROLLBACK;

--      b - Cr�er le trigger (ou le modifier s�il existe d�j�) qui met � jour les colonnes PRIXNET et COUTBRUT de COND � chaque modification de PRIXA dans ART.
        CREATE OR REPLACE TRIGGER update_prixnet_coutbrut_art
        AFTER UPDATE OF prixa ON art
        DECLARE
            prix_net NUMBER(38,0);
            cout_brut NUMBER(38,0);
            prix_unitaire NUMBER(38,0);
            cout_emb NUMBER(38, 0);
        BEGIN 
            FOR line IN (SELECT * FROM cond) LOOP
                SELECT art.prixa into prix_unitaire FROM art WHERE ca = line.ca;
                SELECT emb.coute into cout_emb FROM emb WHERE ce = line.ce;
                prix_net := line.nbart * prix_unitaire;
                cout_brut := prix_net + cout_emb;
                UPDATE cond
                SET prixnet = prix_net, coutbrut = cout_brut
                WHERE cond.ca = line.ca AND cond.ce = line.ce;
            END LOOP;
        END;
        /
        -- El�ment Trigger UPDATE_PRIXNET_COUTBRUT_ART compil�
        
        -- TEST
        SELECT * FROM cond WHERE ca = 'A01';
        /*
            A01	E01	4	2000	2004
            A01	E03	1	500	    510
            A01	E06	1	500	    503
        */
        UPDATE art SET prixa = prixa * 2 WHERE ca = 'A01';
        -- 1 ligne mis � jour.
        SELECT * FROM cond WHERE ca = 'A01';
        -- OK :
        /*
            A01	E01	4	4000	4004
            A01	E03	1	1000	1010
            A01	E06	1	1000	1003
        */
        ROLLBACK;
