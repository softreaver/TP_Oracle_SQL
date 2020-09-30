-- IV) Les TRIGGERS (ces requêtes seront sauvegardées dans le répertoire BD/TP4/TRIGGERS)
-- N.B. Pour faciliter la maintenance, on veillera à n’avoir qu’un seul « before trigger » et /ou un seul « after trigger » par table.
-- Pour cela, avant de créer un nouveau trigger, on s’assurera au préalable qu’il ne faut pas plutôt modifier un trigger déjà existant. 
 
-- Après la création de chaque trigger, on testera systématiquement « son efficacité » en exécutant des fichiers de commande de test.

-- 1) Génération automatique des valeurs de colonnes « dérivées »
--      a - Créer le trigger qui assure la mise à jour automatique de la colonne NBEMB de ART à chaque adjonction ou suppression d’un conditionnement d’article.
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
        -- Elément Trigger UPDATE_NBEMB compilé

--        - tester son efficacité en exécutant le fichier de requêtes ci-dessous qui effectue :
--              - un premier affichage partiel de la table ART,
                SELECT * FROM ART WHERE ca = 'A01' or ca = 'T03';
                    -- A01	Television 16-9	3000	500	7	F01	3
                    -- T03	Rideau	    700	 30	  (null) (null)	2
                    
--              - puis l’adjonction du conditionnement suivant : 1 article A01 dans l’emballage E07,
                INSERT INTO cond VALUES ('A01', 'E07', 1, 0, 0);

--              - puis la suppression du conditionnement de l’article T03 dans l’emballage E06
                DELETE FROM cond
                WHERE cond.ca = 'T03' and cond.ce = 'E06';
                -- 1 ligne supprimé.

--              - puis un deuxième affichage partiel de la table ART (vérifier alors les nouvelles valeurs de NBEMB pour A01 et T03)
                SELECT * FROM ART WHERE ca = 'A01' or ca = 'T03';
                -- A01	Television 16-9	3000	500	 7	   F01	  4
                -- T03	Rideau	        700	    30	(null) (null) 1
                
--              - et enfin la remise des tables dans leur état initial (rollback)
                ROLLBACK;
                -- Annulation (rollback) terminée.

--      b - Les types des articles et des fournisseurs devant être en majuscules, créer les 2 triggers (ou les modifier s’ils existent déjà) qui réalisent systématiquement la prise en compte de ces types en majuscules :
--          i) Lors de l’adjonction d’un nouvel article 
            CREATE OR REPLACE TRIGGER uppercase_art
            BEFORE INSERT ON art
            FOR EACH ROW
            BEGIN
                :new.ca := UPPER(:new.ca);
            END;
        /
        -- Elément Trigger UPPERCASE_ART compilé

--          ii) Lors de l’adjonction d’un nouveau fournisseur ou de la modification du type d’un fournisseur existant.
            CREATE OR REPLACE TRIGGER uppercase_frs
            BEFORE INSERT OR UPDATE ON frs
            FOR EACH ROW
            BEGIN
                :new.typf := UPPER(:new.typf);
            END;
        /
        -- Elément Trigger UPPERCASE_FRS compilé

--      c - Créer le trigger (ou le modifier s’il existe déjà) qui assure la mis à jour automatique de la colonne COUTBRUT de COND à chaque modification de COUTE dans EMB (prévoir les cas où le nouveau ou l’ancien COUTE est inconnu)
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
        -- Elément Trigger UPDATE_COUTBRUT_OF_COND compilé

-- 2) Contrôle de la validité d’une transaction
-- Créer le trigger qui empêche toute mise à jour (adjonction-suppression-modification) de la table FRS le jour de la semaine (lundi, mardi, …) correspondant à votre séance de TP : tester son efficacité.
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
    -- Elément Trigger DAY_RESTRICTION_ON_FRS compilé
    
    -- TEST DE LA RESTRICTION (Rien n'est autorisé le vendredi)
    UPDATE frs SET typf = 'spe';
        -- ORA-20000: Le vendredi, rien n'est permi !

-- 3) Consultation du dictionnaire de données
SELECT * FROM USER_TRIGGERS;
-- Consulter la structure et le contenu « intéressant » de la vue concernant vos triggers et vérifier que vous avez bien les triggers suivants :
--		T_A_DI_COND
--		T_B_I_ART
--		T_B_IU_FRS
--		T_A_U_EMB
--		ST_B_DIU_FRS
-- Supprimer le trigger ST_B_DIU_FRS créé à la question 2 ; reconsulter le D.D.
DROP TRIGGER day_restriction_on_frs;
-- Trigger DAY_RESTRICTION_ON_FRS supprimé(e).

-- 4) Génération automatique d’évènements
--      a) Créer la table EMB_A_CDR, contenant une colonne CE (code des emballages à commander) et une colonne DATE_CDE de type date.
        CREATE TABLE emb_a_cdr (
            ce varchar(4) NOT NULL,
            date_cde date
        );

--      b) Créer le trigger (ou le modifier s’il existe déjà) qui insère automatiquement une ligne dans cette table chaque fois que la quantité en stock d’un emballage passe en dessous de 5, avec la date correspondant à ce passage.
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
        -- Elément Trigger ALARM_LOW_STOCK_EMB compilé

--      c) Tester ce trigger.
        UPDATE emb SET qte = 5 WHERE ce = 'E01';
        SELECT * FROM emb_a_cdr;
        -- OK, aucun enregistrement dans emb_a_cdr
        
        UPDATE emb SET qte = 3 WHERE ce = 'E01';
        SELECT * FROM emb_a_cdr;
        -- OK, 1 enregistrement :        
        -- E01	07/08/20

-- 5) Mise en place de contraintes complexes
-- Créer (ou modifier s’ils existent déjà) les triggers assurant la mise en place des contraintes suivantes :
--      a - Il y a 1 conditionnement minimum et 5 conditionnements maximum par article.
        CREATE GLOBAL TEMPORARY TABLE TEMP_COND AS SELECT * FROM COND WHERE 0=1;
        -- Global temporary TABLE créé(e).
        
        CREATE OR REPLACE TRIGGER BEFORE_MINI_COND_CHECK BEFORE DELETE ON cond FOR EACH ROW 
        BEGIN 
            INSERT INTO TEMP_COND(ca, ce, nbart, prixnet, coutbrut) VALUES (:new.ca, :new.ce, :new.nbart, :new.prixnet, :new.coutbrut);
        END ;
        /
        -- Elément Trigger BEFORE_MINI_COND_CHECK compilé

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
        -- Elément Trigger MINIMUM_COND compilé
        
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
        -- Elément Trigger MAXIMUM_COND compilé

--      b - Tout fournisseur d’articles (figurant dans ART)  doit être de type STA ou SPA
        CREATE OR REPLACE TRIGGER frs_type_check
        BEFORE INSERT OR UPDATE ON frs
        FOR EACH ROW
        DECLARE
            count_cf_in_art number;
        BEGIN
            SELECT count(cf) into count_cf_in_art FROM art WHERE cf = :new.cf;
            IF :new.typf != 'STA' AND :new.typf != 'SPA' THEN
                raise_application_error ( -20003 , 'Les fournisseurs d''article doivent être de type STA ou SPA.' );
            END IF;
        END;
        /
        -- Elément Trigger FRS_TYPE_CHECK compilé
        
        -- TEST
        UPDATE frs SET typf = 'STA' WHERE cf = 'F01';
        -- OK : 1 ligne mis à jour.
        UPDATE frs SET typf = 'SPE' WHERE cf = 'F01';
        -- OK : ORA-20003: Les fournisseurs d'article doivent être de type STA ou SPA.

        ROLLBACK;
        
--      c - Tout fournisseur d’emballages (figurant dans EMB) doit être de type STA ou SPE
        CREATE OR REPLACE TRIGGER frs_type_check_for_emb
        BEFORE INSERT OR UPDATE ON frs
        FOR EACH ROW
        DECLARE
            count_cf_in_emb number;
        BEGIN
            SELECT count(cf) into count_cf_in_emb FROM emb WHERE cf = :new.cf;
            IF :new.typf != 'STA' AND :new.typf != 'SPA' THEN
                raise_application_error ( -20004 , 'Les fournisseurs d''emballage doivent être de type STA ou SPA.' );
            END IF;
        END;
        /
        -- Elément Trigger FRS_TYPE_CHECK_FOR_EMB compilé
        
        -- TEST
        UPDATE frs SET typf = 'STA' WHERE cf = 'F08';
        -- OK : 1 ligne mis à jour.
        UPDATE frs SET typf = 'SPE' WHERE cf = 'F08';
        -- OK : ORA-20004: Les fournisseurs d'emballage doivent être de type STA ou SPA.

-- 6) Utilisation des « instead of » triggers (facultatif mais intéressant)
--      a - Créer la vue VPAPIER (CE, NOME, COUTE, CF, NOMA, NBART) correspondant aux codes, nom coût et fournisseur des caisses (emballages dont le nom contient le mot « papier »), avec pour chacune, les noms et nombres d’articles qui y sont conditionnés. Vérifier son « contenu ».
        CREATE OR REPLACE VIEW VPAPIER
        AS SELECT emb.ce, emb.nome, emb.qte, emb.cf, art.noma, cond.nbart FROM emb
            INNER JOIN cond ON cond.ce = emb.ce
                INNER JOIN art ON cond.ca = art.ca
                    WHERE emb.nome LIKE '%papier%';
        -- View VPAPIER créé(e).
        
        SELECT * FROM VPAPIER;
        /*
            E04	papier	78	F03	beche	1
            E04	papier	78	F03	Machine a laver la vaisselle	2
            E04	papier	78	F03	Lot de 4 balles de tenis	1
        */

--      b -Cette vue sera mise à la disposition du magasinier responsable des caisses y pourra y « insérer des lignes » ; l’insertion d’une ligne dans cette vue correspondra :
--          -soit à la prise en compte d’une nouvelle caisse, avec spécification obligatoire de son code, son nom et son fournisseur et éventuellement, son coût, le nom du 1er article conditionnable et le nombre correspondant. Le nom de l’emballage devra alors contenir le mot « caisse » ; si ce n’est pas le cas, on le rajoutera automatiquement en fin du nom.
--          -soit à la prise en compte d’un nouveau conditionnement dans une caisse déjà existante avec spécification obligatoire du code emballage  et du nom de l’article conditionnable.
--      Dans les deux cas, si le nombre n’est pas précisé, on le prendra égal à 1.
--      Créer le trigger qui remplace l’insertion d’une ligne dans la vue VPAPIER par l’insertion d’une ligne dans EMB si l’emballage n’est pas répertorié,  puis d’une ligne dans COND le cas échéant.
--      Tester son efficacité.
        

-- 7) Génération automatique des valeurs de colonnes dérivées (suite question 1)
--      a - Créer le trigger (ou le modifier s’il existe déjà) qui effectue le calcul automatique des colonnes PRIXNET et COUTBRUT de COND à chaque prise en compte d’un conditionnement ou à chaque modification de NBART.
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
        -- Elément Trigger UPDATE_PRIXNET_COUTBRUT_COND compilé
        
        -- TEST
        SELECT * FROM cond WHERE ca = 'A01' AND ce = 'E03';
        -- A01	E03	1	500	510
        UPDATE cond SET nbart = nbart + 1 WHERE ca = 'A01' AND ce = 'E03';
        -- 1 ligne mis à jour.
        SELECT * FROM cond WHERE ca = 'A01' AND ce = 'E03';
        -- OK :
        -- A01	E03	2	1000	1010
        INSERT INTO cond(ca, ce, nbart) VALUES('A01', 'E04', 20);
        -- 1 ligne inséré.
        SELECT * FROM cond WHERE ca = 'A01' AND ce = 'E04';
        -- OK
        -- A01	E04	20	10000	10007
        ROLLBACK;

--      b - Créer le trigger (ou le modifier s’il existe déjà) qui met à jour les colonnes PRIXNET et COUTBRUT de COND à chaque modification de PRIXA dans ART.
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
        -- Elément Trigger UPDATE_PRIXNET_COUTBRUT_ART compilé
        
        -- TEST
        SELECT * FROM cond WHERE ca = 'A01';
        /*
            A01	E01	4	2000	2004
            A01	E03	1	500	    510
            A01	E06	1	500	    503
        */
        UPDATE art SET prixa = prixa * 2 WHERE ca = 'A01';
        -- 1 ligne mis à jour.
        SELECT * FROM cond WHERE ca = 'A01';
        -- OK :
        /*
            A01	E01	4	4000	4004
            A01	E03	1	1000	1010
            A01	E06	1	1000	1003
        */
        ROLLBACK;
