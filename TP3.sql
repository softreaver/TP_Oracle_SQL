/* TP3 SQL CNAM 2020 - Christopher MILAZZO */

-- 1. Exécuter les requêtes suivantes et conclure :
-- a) select NOMA, NOMF from ART, FRS ;
select NOMA, NOMF from ART, FRS ;
-- OBSERVATION : Renvoi le produit cartésien des table ART et FRS puis fait un projection des colonnes ART.NOMA et FRS.NOMF

-- b) select NOMA, NOMF from ART, FRS where ART.CF=FRS.CF;
select NOMA, NOMF from ART, FRS where ART.CF=FRS.CF;
-- OBSERVATION : Affiche le nom des articles et le nom du fournisseur associé

-- c) select NOMA, NOMF from ART, FRS(+);
select NOMA, NOMF from ART, FRS(+);
-- OBSERVATION : Erreur de syntaxe, il manque une clause WHERE pour faire une jointure externe

-- d) select NOMA, NOMF from ART, FRS where ART.CF(+)=FRS.CF;
select NOMA, NOMF from ART, FRS where ART.CF(+)=FRS.CF;
-- OBSERVATION : Effectue une jointure externe pour afficher les fournisseur qui ne sont pas référencés

-- 2. Ecrire les requêtes permettant de :
-- a) afficher les codes des articles conditionnables dans un carton (in, jointure, exists)
SELECT art.ca FROM art
INNER JOIN frs ON art.cf=frs.cf
INNER JOIN emb ON emb.cf=frs.cf
WHERE emb.nome = 'carton';
-- OU --
SELECT art.ca FROM art
WHERE art.cf IN (
    SELECT emb.cf FROM emb
    WHERE emb.nome = 'carton'
);
-- OU --
SELECT art.ca FROM art
WHERE EXISTS (
    SELECT emb.cf FROM emb
    WHERE art.cf = emb.cf AND emb.nome = 'carton'
);

-- b) afficher les codes des fournisseurs ne livrant aucun article (minus, not in, not exists, demi-jointure)
SELECT frs.cf FROM frs
MINUS
SELECT art.cf FROM art
    WHERE art.cf IS NOT NULL;
-- OU -- 
SELECT frs.cf FROM frs
    WHERE frs.cf NOT IN (
        SELECT art.cf FROM art
        WHERE art.cf IS NOT NULL
    );
-- OU --
SELECT frs.cf FROM frs
    WHERE NOT EXISTS (
        SELECT art.cf FROM art
        WHERE frs.cf = art.cf AND art.cf IS NOT NULL
    );
-- OU --
SELECT frs.cf FROM frs
LEFT JOIN art ON art.cf = frs.cf
WHERE art.cf IS NULL;

-- c) afficher les codes des emballages ne conditionnant aucun article électroménager (minus, not in, not exists)
SELECT emb.ce FROM emb
MINUS (
    SELECT cond.ce FROM cond
    INNER JOIN art ON cond.ca = art.ca
    WHERE art.ca LIKE 'E%'
);
-- OU --
SELECT emb.ce FROM emb
WHERE emb.ce NOT IN (
    SELECT cond.ce FROM cond
    INNER JOIN art ON cond.ca = art.ca
    WHERE art.ca LIKE 'E%'
);
-- OU -- 
SELECT emb.ce FROM emb
WHERE NOT EXISTS (
    SELECT cond.ce FROM cond
    INNER JOIN art ON cond.ca = art.ca
    WHERE emb.ce = cond.ce AND art.ca LIKE 'E%'
);
    /*
    E05
    E06
    E07
    E08    
    */

-- 3. a) ajouter à la table ART la colonne NBEMB (valeur par défaut 0)
ALTER TABLE art
ADD NBEMB int DEFAULT (0);
    -- Table ART modifié(e).

-- b) valoriser cette colonne en exécutant une seule requête
SET TRANSACTION READ WRITE;
UPDATE art
SET nbemb = (
    SELECT count(cond.ca) FROM cond
    WHERE cond.ca = art.ca
);
--ROLLBACK;
-- 21 lignes mis à jour.

-- c) vérifier, puis exécuter un commit si le résultat est correct
SELECT art.ca, art.nbemb FROM art
WHERE art.nbemb = (
    SELECT count(cond.ca) FROM cond
    WHERE art.ca = cond.ca
);
/*
    A01	3
    A02	1
    A03	1
    A04	3
    B01	1
    B02	1
    B03	1
    E01	1
    E02	1
    E03	1
    E04	1
    L01	3
    L02	1
    L03	1
    M01	1
    M02	1
    M03	1
    T01	1
    T02	1
    T03	2
    T04	1
*/
-- VERIF OK j'ai bien les 21 articles présents
COMMIT;

-- 4. Requêtes à exécuter dans une même session:
SET TRANSACTION READ WRITE;
-- a) supprimer les conditionnements des articles audiovisuels dans des caisses ; vérifier
DELETE FROM cond
WHERE cond.ca LIKE 'A%'
    AND cond.ce = (
    SELECT emb.ce FROM emb
    WHERE emb.nome = 'caisse'
);

-- verif OK, pas de tuple affiché avec la requête suivante : 
SELECT art.ca FROM art
    INNER JOIN cond ON cond.ca = art.ca
    INNER JOIN emb ON emb.ce = cond.ce
    WHERE emb.nome = 'caisse'
        AND art.ca LIKE 'A%';
        
COMMIT;

-- b) afficher les codes et noms des emballages conditionnant au moins un article audiovisuel (jointure)
SELECT DISTINCT emb.ce, emb.nome FROM emb
INNER JOIN cond ON cond.ce = emb.ce
WHERE cond.ca LIKE 'A%';
/*
    E06	Sac plastique
    E01	carton
    E02	Boite plastique
    E07	Papier recycl?
*/

-- c) afficher les codes et noms des articles conditionnables dans une caisse
SELECT art.ca, art.noma FROM art
INNER JOIN emb ON emb.cf = art.cf
WHERE emb.nome = 'caisse';
/*
    A01	Television 16-9
    B01	Tuyau d?arrosage
    E02	Machine ? pain
    L01	Console de jeu
    M01	Lit pour enfant
    T01	Sac en cuir
*/

-- d) réintégrer les données supprimées au a) ; vérifier
ROLLBACK;

SELECT art.ca, art.nbemb FROM art
WHERE art.nbemb = (
    SELECT count(cond.ca) FROM cond
    WHERE art.ca = cond.ca
);
/*
    A01	3
    A02	1
    A03	1
    A04	3
    B01	1
    B02	1
    B03	1
    E01	1
    E02	1
    E03	1
    E04	1
    L01	3
    L02	1
    L03	1
    M01	1
    M02	1
    M03	1
    T01	1
    T02	1
    T03	2
    T04	1
*/ 
-- VERIFS OK : 21 articles affichés
COMMIT;

-- 5. Afficher les codes et noms des articles conditionnés dans au moins un emballage livré par un fournisseur de
-- type standard (sans, puis avec jointure)
SELECT DISTINCT art.ca, art.noma FROM art
INNER JOIN cond ON cond.ca = art.ca
INNER JOIN frs ON frs.cf = art.cf
WHERE frs.typf = 'STA';
-- OU --
SELECT art.ca, art.noma FROM art
WHERE EXISTS (
    SELECT cond.ca FROM cond, frs
    WHERE cond.ca = art.ca
        AND art.cf = frs.cf
        AND frs.typf = 'STA'
);

/*
    M01	Lit pour enfant
    T01	Sac en cuir
    A01	Television 16-9
    A02	Ecran plat
    B01	Tuyau d?arrosage
    B03	arrosoir
    E01	Mixeur
    E02	Machine ? pain
    E03	Machine a laver le linge
    B02	beche
    L01	Console de jeu
    M02	lampe
*/

-- 6. Afficher les codes des articles conditionnables dans E04 ou E05
SELECT art.ca FROM art
INNER JOIN emb ON emb.cf = art.cf
WHERE emb.ce = 'E04' OR emb.ce = 'E05';
/*
    A02
    M02
*/

-- 7. Afficher les codes des articles conditionnables dans E03 et E06 (intersect, in, jointure).
SELECT a1.ca FROM art a1
WHERE EXISTS (
    SELECT a2.cf FROM art a2
    WHERE a1.ca = a2.ca
    INTERSECT
    SELECT emb.cf FROM emb
    WHERE emb.ce = 'E03' OR emb.ce = 'E06'
);
-- OU --
SELECT art.ca FROM art
WHERE art.cf IN (
    SELECT emb.cf FROM emb
    WHERE emb.ce = 'E03' OR emb.ce = 'E06'
);
-- OU --
SELECT art.ca FROM art
INNER JOIN emb ON emb.cf = art.cf
WHERE emb.ce = 'E03' OR emb.ce = 'E06';
/*
    A01
    B01
    E02
    L01
    M01
    T01
*/
-- 8. a) ajouter à la table COND les colonnes PRIXNET et COUTBRUT (valeur par défaut : 0) qui contiendront
-- respectivement le prix total des articles du colis plein et son coût global, emballage compris,
-- correspondant à chaque conditionnement.
ALTER TABLE cond
ADD PRIXNET int DEFAULT (0)
ADD COUTBRUT int DEFAULT (0);
-- Table COND modifié(e).
-- Table COND modifié(e).

-- b) valoriser ces 2 colonnes par exécution d’une requête (synchronisation)
SET TRANSACTION READ WRITE;

UPDATE cond
SET (PRIXNET, COUTBRUT) = ( (
    SELECT (art.prixa * cond.nbart), ((art.prixa * cond.nbart) + emb.coute) FROM art
    INNER JOIN emb ON emb.ce = cond.ce
    WHERE cond.ca = art.ca
)  );
-- 28 lignes mis à jour.
--ROLLBACK;

-- c) vérifier le contenu de ces 2 colonnes, puis rendre cette valorisation définitive 
/*
    A01	E03	1	500	510
    A01	E01	4	2000	2004
    A01	E06	1	500	503
    A02	E02	5	1725	1730
    A03	E01	2	150	154
    A04	E03	1	245	255
    A04	E06	4	980	983
    A04	E07	2	490	495
    B01	E03	4	160	170
    B02	E04	1	10	17
    B03	E02	2	24	29
    E01	E01	2	100	104
    E02	E03	2	150	160
    E03	E02	4	800	805
    E04	E04	2	600	607
    L01	E03	7	700	710
    L01	E07	7	700	705
    L01	E02	2	200	205
    L02	E01	3	60	64
    L03	E04	1	7	14
    M01	E02	1	150	155
    M02	E03	1	20	30
    M03	E01	1	2000	2004
    T01	E02	3	180	185
    T02	E05	2	140	149
    T03	E01	4	120	124
    T03	E06	5	150	153
    T04	E05	4	60	69
*/
COMMIT;

-- 9. Requêtes à exécuter dans une même session:
SET TRANSACTION READ WRITE;
-- a) ajouter l’emballage E09, de nom « emballage neuf », fourni par F01 et les conditionnements suivants
-- (A01, E03, 1), (T01, E09, 1) et (T02, E09, 1)
INSERT INTO emb (ce, nome, cf)
VALUES ('E09', 'emballage neuf', 'F01');
-- 1 ligne inséré.

-- b)afficher les noms des emballages conditionnant au moins les mêmes articles que E07
SELECT DISTINCT emb.nome FROM emb
INNER JOIN cond c1 ON c1.ce = emb.ce
INNER JOIN art ON art.ca = c1.ca
WHERE emb.ce <> 'E07'
    AND art.ca = ANY (
        SELECT c2.ca FROM cond c2
        WHERE c2.ce = 'E07'
    );
/*
    caisse
    Sac plastique
    Boite plastique
*/

-- c) afficher les noms des emballages conditionnant au plus les mêmes articles que E07
SELECT e1.nome FROM emb e1
WHERE e1.ce <> 'E07'
    AND NOT EXISTS (
        SELECT c2.ca FROM cond c2
        WHERE c2.ce = 'E07'
            AND c2.ca NOT IN (
                SELECT DISTINCT art.ca FROM art
                INNER JOIN cond ON cond.ca = art.ca
                WHERE e1.ce = cond.ce
            )
    );
-- caisse

-- d)supprimer les données ajoutées au a)
ROLLBACK;
-- Annulation (rollback) terminée.

-- 10. Vérification de la validité des types de fournisseurs (à exécuter lors d’une même session):
SET TRANSACTION READ WRITE;
-- a)Prendre en compte le nouveau fournisseur F04 de l’emballage E01 et le nouveau fournisseur F08 de
-- l’article A01
UPDATE emb
SET cf = 'F04'
WHERE ce = 'E01';
-- 1 ligne mis à jour.

-- b)Afficher les fournisseurs standards ne livrant que des emballages ou que des articles
SELECT frs.nomf FROM frs
WHERE frs.typf = 'STA'
    AND (
            (
                frs.cf IN (SELECT a1.cf FROM art a1)
                AND frs.cf NOT IN (SELECT e1.cf FROM emb e1)
            ) OR (
                frs.cf IN (SELECT e2.cf FROM emb e2)
                AND frs.cf NOT IN (SELECT a2.cf FROM art a2)
            )
    );
-- sogedis

-- c)Afficher les fournisseurs de type SPA livrant des emballages ou de type SPE livrant des articles (cas des
-- types erronés)
SELECT frs.nomf FROM frs
WHERE   ( frs.typf = 'SPA' AND frs.cf IN (SELECT emb.cf FROM emb) )
    OR  ( frs.typf = 'SPE' AND frs.cf IN (SELECT art.cf FROM art) );
-- philmo

-- d)Remettre les données à l’état initial
ROLLBACK;
-- Annulation (rollback) terminée.
