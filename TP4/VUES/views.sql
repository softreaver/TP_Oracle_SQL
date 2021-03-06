-- II - Les VUES (ces requ�tes seront sauvegard�es dans les r�pertoires BD/TP4/VUES)
--  1) Mise en place de sous-sch�mas (� faire avec 2 comptes U1 : c##user1 et U2 : c##TestView)
--      a) L�utilisateur U1 cr�e le sous-sch�ma suivant :
--          -cr�ation d�une vue VCAISSES sur EMB correspondant aux codes, nom et quantit�s en stock des caisses 
--          -d�l�gation des seuls privil�ges suivants � l�utilisateur U2 : consultation de la vue et modification de la quantit� en stock.
CREATE VIEW VCAISSES
AS SELECT ce, nome, qte FROM emb;
-- View VCAISSES cr��(e).

GRANT select, update(qte)
ON VCAISSES
TO c##TestView;
-- Succ�s de l'�l�ment Grant.



--      b) L�utilisateur U2 essaie :
--          -de consulter la table EMB de U1
SELECT * FROM c##user1.EMB;
    -- ORA-00942: Table ou vue inexistante
    -- 00942. 00000 -  "table or view does not exist"
    
--          -de consulter la vue VCAISSES cr�e par U1
SELECT * FROM C##USER1.vcaisses;
    /*
    E01	carton	15
    E02	Boite plastique	20
    E03	caisse	7
    E04	papier	78
    E05	aluminium	6
    E06	Sac plastique	65
    E07	Papier recycl?	31
    E08	Film issolant	15
    */

--          -de modifier le nom d�une caisse directement dans la table EMB de U1, puis en passant par la vue VCAISSES
SET TRANSACTION READ WRITE;
UPDATE c##user1.emb
SET nome='new caisse'
WHERE nome='caisse';
    -- Erreur SQL : ORA-00942: Table ou vue inexistante
UPDATE C##USER1.vcaisses
SET nome='new caisse'
WHERE nome='caisse';
    -- Erreur SQL : ORA-01031: privil�ges insuffisants
    
--          -d�augmenter de 10 unit�s la quantit� en stock de toutes les caisses directement dans la table EMB de U1, puis en passant par la vue VCAISSES
UPDATE C##USER1.emb
SET qte = 10 + qte
WHERE nome='caisse';
    -- Erreur SQL : ORA-00942: Table ou vue inexistante
    
UPDATE C##USER1.vcaisses
SET qte = 10 + qte
WHERE nome='caisse';
    -- 1 ligne mis � jour.

/*          -conclure
La table EMB de User1 n'est pas accessible car c##TextView n'y a pas �t� autoris�.
La vue quant � elle � �t� autoris� � c##TestView pour les requ�tes SELECT et UPDATE (qte)
*/

--      c) L�utilisateur U1 visualise sa table EMB, conclure, remettre ensuite la table EMB dans son �tat initial
SELECT * FROM c##User1.emb;
    -- E03	caisse	600	17	10	F01
    -- CONCLUSION : On peut modifier les tables depuis les vues associ�es
    
ROLLBACK;

-- 2) Consultation du dictionnaire de donn�es (D.D)
--      a)Consulter dans le D.D. la description de USER_VIEWS et ALL_VIEWS
SELECT * FROM USER_VIEWS;
    -- Liste vide
SELECT * FROM ALL_VIEWS;
    -- Liste exhaustive

--      b) Consulter le contenu des colonnes et/ou lignes � int�ressantes � de ces vues
--      c) Reprendre les questions a) et b) ci-dessus pour toutes les vues concernant les privil�ges
SELECT * FROM ALL_VIEWS WHERE VIEW_NAME LIKE '%PRIVILEGE%';

--      d) L�utilisateur U1 supprime les privil�ges qu�il a accord�s � U2 : re-consulter la (les) vue(s) ad�quate(s) du D.D.
SELECT * FROM TABLE_PRIVILEGES WHERE GRANTEE='C##TESTVIEW';
    -- C##TESTVIEW	C##USER1	VCAISSES	C##USER1	Y	N	N	S	N	N	N	
REVOKE all privileges ON VCAISSES from C##TestView;



-- 3) �criture de requ�tes complexes
--  On veut afficher
--      - Pour chaque emballage, son code, son nom et le nombre de conditionnements le concernant, si ce nombre d�passe le nombre moyen de conditionnements par emballage
SELECT emb.ce, emb.nome, (
    SELECT count(c1.ca)
    FROM cond c1
    WHERE c1.ce = emb.ce
    GROUP BY c1.ce
) AS nb_conditionnement
FROM emb
WHERE (
        SELECT count(c3.ca)
        FROM cond c3
        WHERE c3.ce = emb.ce
        GROUP BY c3.ce
    ) > (
        SELECT ROUND(AVG(count(c2.ca)), 2)
        FROM cond c2
        GROUP BY c2.ce
    );
/*
    E01	carton	6
    E02	Boite plastique	6
    E03	caisse	6
*/

--      - Les fournisseurs (code, nom, nombre d�articles fournis, nombre d�emballages fournis, avec ces nombres � 0 le cas �ch�ant), pr�sent�s dans l�ordre alphab�tique.
SELECT frs.cf, frs.nomf, NVL(
    (
        SELECT count(art.ca)
        FROM art
        WHERE art.cf = frs.cf
        GROUP BY art.cf
    ), 0) AS nb_articles, NVL(
    (
        SELECT count(emb.ce)
        FROM emb
        WHERE emb.cf = frs.cf
        GROUP BY emb.cf
    ), 0) AS nb_emballages
FROM frs
ORDER BY frs.nomf ASC;
/*
    F05	aves	2	0
    F07	padol	0	2
    F03	parna	2	3
    F04	philmo	2	0
    F01	podium	6	1
    F06	prisme	3	0
    F02	sogedis	4	0
    F08	vulcain	0	2
*/