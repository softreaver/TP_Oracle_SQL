-- 0. a) la date du jour
    SELECT TO_CHAR(SYSDATE, 'DD/MM/YYYY') FROM DUAL;
    -- 19/05/2020

-- b) votre code utilisateur
    SHOW user;
    -- USER est "C##USER1"

-- 1. les emballages livrés par le fournisseur de code F03
    SELECT * FROM EMB WHERE cf = 'F03';
    /*
    E01	carton	        400	15	4	F03
    E02	Boite plastique	200	20	5	F03
    E04	papier	        20	78	7	F03
    */

-- 2. les articles dont le délai de livraison est compris entre 7 et 14 jours, bornes comprises
    SELECT * FROM art WHERE DELAI BETWEEN 7 AND 14;
    /*
    A01	Television 16-9	3000	500	7	F01
    A02	Ecran plat	1000	345	14	F03
    A03	Lecteur DVD	1000	75	14	F04
    A04	Mini cha?ne de salon	1000	245	14	F05
    B01	Tuyau d?arrosage	1000	40	8	F01
    B02	beche	523	10	14	F02
    B03	arrosoir	700	12	14	F02
    E01	Mixeur	1000	50	14	F02
    E02	Machine ? pain	1200	75	10	F01
    E03	Machine a laver le linge	70000	200	14	F02
    E04	Machine a laver la vaisselle	80000	300	14	F06
    L01	Console de jeu	750	100	11	F01
    L02	Raquette de tennis	400	20	14	F04
    L03	Lot de 4 balles de tenis	300	7	14	F06
    M02	lampe	750	20	14	F03
    M03	canape	60000	2000	14	F06
    T01	Sac en cuir	523	60	8	F01
    T02	Bottes en cuir	400	70	14	F05
    */

-- 3. les articles de type bricolage, électroménager ou loisir.
    SELECT CA, NOMA FROM art WHERE ca LIKE 'B%' OR ca LIKE 'E%' OR ca LIKE 'L%';
    /*
    B01	Tuyau d?arrosage
    B02	beche
    B03	arrosoir
    E01	Mixeur
    E02	Machine ? pain
    E03	Machine a laver le linge
    E04	Machine a laver la vaisselle
    L01	Console de jeu
    L02	Raquette de tennis
    L03	Lot de 4 balles de tenis
    */

-- 4. les conditionnements, classés sur le code emballage
    SELECT * FROM cond ORDER BY ce ASC;
    /*
    A01	E01	4
    L02	E01	3
    T03	E01	4
    M03	E01	1
    E01	E01	2
    A03	E01	2
    M01	E02	1
    B03	E02	2
    T01	E02	3
    E03	E02	4
    L01	E02	2
    A02	E02	5
    L01	E03	7
    E02	E03	2
    B01	E03	4
    A04	E03	8
    A01	E03	5
    M02	E03	1
    L03	E04	1
    E04	E04	2
    B02	E04	1
    T02	E05	2
    T04	E05	4
    A01	E06	1
    T03	E06	5
    A04	E06	4
    A04	E07	2
    L01	E07	7
    */

-- 5. les codes des fournisseurs livrant au moins un emballage.
    SELECT CF FROM frs WHERE EXISTS (SELECT CF FROM emb WHERE frs.cf = emb.cf);
    -- OU --
    SELECT DISTINCT frs.cf FROM frs
    INNER JOIN emb ON frs.cf = emb.cf;
    /*
    F01
    F03
    F07
    F08
    */

-- 6. les codes des fournisseurs livrant au moins un article en plus de 30 jours.
    SELECT frs.cf FROM frs
    WHERE EXISTS (SELECT CF FROM art WHERE frs.cf = art.cf AND art.delai > 30);
    -- OU --
    SELECT DISTINCT frs.cf FROM frs
    INNER JOIN art ON frs.cf = art.cf
    WHERE art.delai > 30;
    -- F01
    
-- 7. les articles textiles coûtant moins de 30€.
    SELECT art.noma FROM art WHERE art.ca LIKE 'T%' AND art.prixa < 30;
    -- nappe

-- 8. en donnant un intitulé significatif à la valeur affichée:
-- a) le nombre total d’articles
    SELECT CONCAT('Nombre total d''articles = ', COUNT(art.ca)) AS afficher_total_art FROM art;
    -- Nombre total d'articles = 21

-- b) le nombre de fournisseurs d’articles
    SELECT CONCAT('Nombre de fournisseurs d’articles = ', COUNT(frs.cf)) AS afficher_total_frs_art FROM frs
    WHERE EXISTS (SELECT art.cf FROM art WHERE art.cf = frs.cf);
    -- OU --
    SELECT CONCAT('Nombre de fournisseurs d’articles = ', COUNT(DISTINCT frs.cf)) AS afficher_total_frs_art FROM frs
    INNER JOIN art ON art.cf = frs.cf;
    -- Nombre de fournisseurs d’articles = 6

-- c) le nombre de fournisseurs d’emballage
    SELECT CONCAT('Nombre de fournisseurs d''emballage = ', COUNT(frs.cf)) AS afficher_total_frs_emb FROM frs
    WHERE EXISTS (SELECT emb.cf FROM emb WHERE emb.cf = frs.cf);
    -- OU --
    SELECT CONCAT('Nombre de fournisseurs d''emballage = ', COUNT(DISTINCT frs.cf)) AS afficher_total_frs_emb FROM frs
    INNER JOIN emb ON emb.cf = frs.cf;
    -- Nombre de fournisseurs d'emballage = 4

-- d) le nombre total d’emballages en stock
    SELECT CONCAT('Nombre d''emballage en stock = ', COUNT(DISTINCT emb.ce)) AS afficher_total_avail_emb FROM emb
    WHERE qte > 0;
    -- Nombre d'emballage en stock = 8

-- e) la valeur globale, en euros, du stock d’emballages
    SELECT concat(concat( 'La valeur globale du stock d''emballage = ', sum(emb.coute * emb.qte) ), ' euros' ) FROM emb;
    -- La valeur globale du stock d'emballage = 1330 euros

-- f) le nombre d’articles non fabriqués (on n’utilisera pas la clause where)
    SELECT concat( 'Nombre d''artciles non fabriqués = ', count(art.ca) ) FROM art
    INNER JOIN frs ON art.cf = frs.cf;
    -- Nombre d'artciles non fabriqués = 19

-- g) le nombre d’articles fabriqués (idem)
    SELECT
    (SELECT count(art.ca) FROM art) as total_art,
    (SELECT count(art.ca) FROM art
    INNER JOIN frs ON art.cf = frs.cf) as provided_art,
    (SELECT concat( 'test = ', total_art - provided_art ) FROM art)
    FROM art;
    

-- 9. a) pour chaque article, son code, son nom, son prix actuel, son prix diminué de 8,5%, son prix diminué de
-- 8,5% arrondi à l’euro le plus proche, son prix diminué de 8,5% arrondi à la dizaine d’euros la plus
-- proche
    SELECT  art.ca, art.noma,
            art.prixa, art.prixa - (art.prixa * 0.085) as prix_diminue,
            ROUND(art.prixa - (art.prixa * 0.085)) as prix_diminue_arrondi,
            ROUND(art.prixa - (art.prixa * 0.085), -1) as prix_diminue_arrondi_au_dixiaime
    FROM art;

-- b) pour chaque article non fabriqué, son code et la date à laquelle il serait livré si on le commandait
-- aujourd’hui 
    SELECT ca, noma, SYSDATE + delai AS date_reception FROM art
    WHERE cf IS NOT NULL;
    /*
    A01	Television 16-9	26/05/20
    A02	Ecran plat	02/06/20
    A03	Lecteur DVD	02/06/20
    A04	Mini cha?ne de salon	02/06/20
    B01	Tuyau d?arrosage	27/05/20
    B02	beche	02/06/20
    B03	arrosoir	02/06/20
    E01	Mixeur	02/06/20
    E02	Machine ? pain	29/05/20
    E03	Machine a laver le linge	02/06/20
    E04	Machine a laver la vaisselle	02/06/20
    L01	Console de jeu	30/05/20
    L02	Raquette de tennis	02/06/20
    L03	Lot de 4 balles de tenis	02/06/20
    M01	Lit pour enfant	18/07/20
    M02	lampe	02/06/20
    M03	canape	02/06/20
    T01	Sac en cuir	27/05/20
    */

-- 10. les noms des articles contenant le terme « cuir »
    SELECT noma FROM art
    WHERE noma LIKE '%cuir%';
    /*
    Sac en cuir
    Bottes en cuir
    */

-- 11. pour chaque article, son code, son prix actuel et son prix augmenté de 10%, cette augmentation ne pouvant
-- pas toutefois excéder 40€
    SELECT ca, prixa,
    CASE
        WHEN (prixa * 0.1) > 40 THEN prixa + 40
        ELSE prixa + (prixa * 0.1)
    END
    AS prix_augmente
    FROM art;
    /*
    A01	500	540
    A02	345	379,5
    A03	75	82,5
    A04	245	269,5
    B01	40	44
    B02	10	11
    B03	12	13,2
    E01	50	55
    E02	75	82,5
    E03	200	220
    E04	300	330
    L01	100	110
    L02	20	22
    L03	7	7,7
    M01	150	165
    M02	20	22
    M03	2000	2040
    T01	60	66
    T02	70	77
    T03	30	33
    T04	15	16,5
    */

-- 12. a) le délai de livraison le plus court (suivi du mot « jours »)
    SELECT MIN(delai) || ' jours' FROM art;
    -- 7 jours

-- b) les articles fournis sous ce délai
    SELECT ca, noma FROM art
    WHERE delai <= (
        SELECT MIN(delai) FROM art
    );
    -- A01	Television 16-9

-- 13. les codes des fournisseurs d’articles avec délai maximum, délai minimum, nombre d’articles fournis avec
-- leur prix moyen
    SELECT frs.cf,
        (SELECT MAX(delai) FROM art WHERE art.cf = frs.cf) AS delai_maxi,
        (SELECT MIN(delai) FROM art WHERE art.cf = frs.cf) AS delai_mini,
        (SELECT COUNT(ca) FROM art WHERE art.cf = frs.cf) AS nb_art,
        (SELECT ROUND( AVG(art.prixa), 2 ) FROM art WHERE art.cf = frs.cf) AS prix_moyen
    FROM frs;
    /*
    F05	14	14	2	157,5
    F03	14	14	2	182,5
    F06	14	14	3	769
    F01	60	7	6	154,17
    F04	14	14	2	47,5
    F02	14	14	4	68
    F07			0	
    F08			0	
    */

-- 14. a) les codes des fournisseurs livrant plus de 2 emballages, et le nombre d’emballages livrés
    SELECT frs.cf, COUNT(emb.ce) AS nb_emballages FROM frs
    INNER JOIN emb ON frs.cf = emb.cf
    GROUP BY frs.cf HAVING COUNT(emb.ce) > 2;
    -- OU --
    SELECT cf,
        (
            SELECT COUNT (ce) FROM emb
            WHERE emb.cf = frs.cf
        ) AS nb_emballages
    FROM frs
    WHERE (
        SELECT COUNT (ce) FROM emb
        WHERE emb.cf = frs.cf
    ) > 2;
    

-- b) les codes des fournisseurs ne livrant qu’un emballage (et emballage correspondant)
    SELECT frs.cf, emb.nome FROM frs
    INNER JOIN emb ON frs.cf = emb.cf
    WHERE (
        SELECT COUNT(emb.nome) FROM emb
        WHERE frs.cf = emb.cf
    ) = 1;
    -- F01	caisse

-- 15. a) Pour chaque article, son code et le nombre de conditionnements possibles
    SELECT art.ca, COUNT(emb.ce) FROM art
    INNER JOIN frs ON art.cf = frs.cf
    INNER JOIN emb ON emb.cf = frs.cf
    GROUP BY art.ca;
    /*
    T01	1
    A02	3
    M01	1
    A01	1
    L01	1
    M02	3
    B01	1
    E02	1
    */

-- b) les articles pour lesquels le nombre de conditionnement est maximum
    SELECT a1.ca, a1.noma FROM art a1
    INNER JOIN cond ON cond.ca = a1.ca
    WHERE (
        SELECT COUNT(emb.ce) FROM art a2
        INNER JOIN frs ON a2.cf = frs.cf
        INNER JOIN emb ON emb.cf = frs.cf
        WHERE a1.ca = a2.ca
        GROUP BY a2.ca
    ) = (
        SELECT COUNT(a3.ca) FROM art a3
        INNER JOIN cond ON cond.ca = a3.ca
        WHERE a1.ca = a3.ca
    );
    /*
    B01	Tuyau d?arrosage
    E02	Machine ? pain
    M01	Lit pour enfant
    T01	Sac en cuir
    */

-- c) les articles n’ayant qu’un conditionnement possible
    SELECT art.ca FROM art
    INNER JOIN frs ON art.cf = frs.cf
    INNER JOIN emb ON emb.cf = frs.cf
    GROUP BY art.ca HAVING COUNT(emb.ce) = 1;
    /*
    T01
    M01
    A01
    L01
    B01
    E02
    */

-- 16. a) le nombre d’articles textiles
    SELECT CONCAT( 'Nombre d''articles textiles = ', COUNT(art.ca) ) FROM art
    WHERE art.ca LIKE 'T%';
    -- Nombre d'articles textiles = 4

-- b) pour chaque type d’article, le type et le nombre d’articles de ce type
    SELECT CASE
            WHEN art.ca LIKE 'A%' THEN 'Audiovisuel'
            WHEN art.ca LIKE 'B%' THEN 'Bricolage'
            WHEN art.ca LIKE 'E%' THEN 'Electroménager'
            WHEN art.ca LIKE 'L%' THEN 'Loisirs'
            WHEN art.ca LIKE 'M%' THEN 'Mobilie'
            WHEN art.ca LIKE 'T%' THEN 'Textile'
        END AS type_article,
        COUNT(art.ca) AS nb_article
    FROM art
    GROUP BY CASE
            WHEN art.ca LIKE 'A%' THEN 'Audiovisuel'
            WHEN art.ca LIKE 'B%' THEN 'Bricolage'
            WHEN art.ca LIKE 'E%' THEN 'Electroménager'
            WHEN art.ca LIKE 'L%' THEN 'Loisirs'
            WHEN art.ca LIKE 'M%' THEN 'Mobilie'
            WHEN art.ca LIKE 'T%' THEN 'Textile'
        END;
        /*
        Audiovisuel	4
        Bricolage	3
        Electroménager	4
        Loisirs	3
        Mobilie	3
        Textile	4
        */

-- 17. a) le prix moyen et le délai moyen de livraison pour l’ensemble des articles de type « mobilier »
    SELECT
        'Prix moyen = ' || ROUND(AVG(prixa), 2) AS prix_moyen,
        'Délai moyen de livraison = ' || ROUND(AVG(delai), 2) AS delai_moyen_livraison
    FROM art
    WHERE ca LIKE 'M%'
    GROUP BY CASE WHEN ca like 'M%' THEN 'm' END;
    -- Prix moyen = 723,33	Délai moyen de livraison = 29,33

-- b) pour chaque type d’article, le type et ces 2 moyennes
    SELECT CASE
            WHEN art.ca LIKE 'A%' THEN 'Audiovisuel'
            WHEN art.ca LIKE 'B%' THEN 'Bricolage'
            WHEN art.ca LIKE 'E%' THEN 'Electroménager'
            WHEN art.ca LIKE 'L%' THEN 'Loisirs'
            WHEN art.ca LIKE 'M%' THEN 'Mobilie'
            WHEN art.ca LIKE 'T%' THEN 'Textile'
        END AS type_article,
        ROUND(AVG(prixa), 2) AS prix_moyen,
        ROUND(AVG(delai), 2) AS delai_moyen_livraison
    FROM art
    GROUP BY CASE
            WHEN art.ca LIKE 'A%' THEN 'Audiovisuel'
            WHEN art.ca LIKE 'B%' THEN 'Bricolage'
            WHEN art.ca LIKE 'E%' THEN 'Electroménager'
            WHEN art.ca LIKE 'L%' THEN 'Loisirs'
            WHEN art.ca LIKE 'M%' THEN 'Mobilie'
            WHEN art.ca LIKE 'T%' THEN 'Textile'
        END;
        /*
        Audiovisuel	291,25	12,25
        Bricolage	20,67	12
        Electroménager	156,25	13
        Loisirs	42,33	13
        Mobilie	723,33	29,33
        Textile	43,75	11
        */

-- c) les types d’articles pour lesquels tous les articles de ce type ont un délai de livraison compris entre 7 et 14
-- jours
    SELECT CASE
            WHEN a1.ca LIKE 'A%' THEN 'Audiovisuel'
            WHEN a1.ca LIKE 'B%' THEN 'Bricolage'
            WHEN a1.ca LIKE 'E%' THEN 'Electroménager'
            WHEN a1.ca LIKE 'L%' THEN 'Loisirs'
            WHEN a1.ca LIKE 'M%' THEN 'Mobilie'
            WHEN a1.ca LIKE 'T%' THEN 'Textile'
        END AS type_article1
    FROM art a1
    WHERE NOT EXISTS (
        SELECT a2.ca FROM art a2
        WHERE   (SUBSTR(a1.ca, 1, 1) = SUBSTR(a2.ca, 1, 1))
            AND (
                    (a2.delai NOT BETWEEN 7 AND 14)
                    OR (a2.delai IS NULL)
                )
    )
    GROUP BY CASE
            WHEN a1.ca LIKE 'A%' THEN 'Audiovisuel'
            WHEN a1.ca LIKE 'B%' THEN 'Bricolage'
            WHEN a1.ca LIKE 'E%' THEN 'Electroménager'
            WHEN a1.ca LIKE 'L%' THEN 'Loisirs'
            WHEN a1.ca LIKE 'M%' THEN 'Mobilie'
            WHEN a1.ca LIKE 'T%' THEN 'Textile'
        END;
    /*
    Bricolage
    Audiovisuel
    Electroménager
    Loisirs
    */

-- 18. code(s) d(es) emballage(s) avec le nombre d’articles qu’ils conditionnent
    SELECT ce, SUM(nbart) FROM COND
    GROUP BY ce;
    /*
    E01	16
    E06	10
    E07	9
    E04	4
    E05	6
    E03	27
    E02	17
    */

-- 19. a) les code des articles ayant au moins 3 conditionnements possibles
    SELECT art.ca FROM art
    INNER JOIN frs ON art.cf = frs.cf
    INNER JOIN emb ON emb.cf = frs.cf
    GROUP BY art.ca HAVING COUNT(art.noma) >= 3;
    /*
    A02
    M02
    */

-- b) le nombre de ces articles
    SELECT a1.ca, sum(cond.nbart) AS nombre_articles FROM art a1
    INNER JOIN cond ON cond.ca = a1.ca
    WHERE EXISTS (
        SELECT a2.ca FROM art a2
        INNER JOIN frs ON a2.cf = frs.cf
        INNER JOIN emb ON emb.cf = frs.cf
        WHERE a1.ca = a2.ca
        GROUP BY a2.ca HAVING COUNT(a2.noma) >= 3
    ) GROUP BY a1.ca;
    /*
    A02	5
    M02	1
    */

-- 20. pour chaque fournisseur, son code et le nombre d’emballages fournis, y compris si ce nombre est nul
    SELECT frs.cf, COUNT(emb.ce)
    FROM emb
    RIGHT JOIN frs ON frs.cf = emb.cf
    GROUP BY frs.cf;
    /*
    F01	1
    F02	0
    F03	3
    F04	0
    F05	0
    F06	0
    F07	2
    */

-- 21. les codes et noms des articles:
-- a) avec les noms en majuscules, classés par ordre alphabétique
    SELECT art.ca, UPPER(art.noma)
    FROM art
    ORDER BY art.noma ASC;
    /*
    B03	ARROSOIR
    B02	BECHE
    T02	BOTTES EN CUIR
    M03	CANAPE
    L01	CONSOLE DE JEU
    A02	ECRAN PLAT
    M02	LAMPE
    A03	LECTEUR DVD
    M01	LIT POUR ENFANT
    L03	LOT DE 4 BALLES DE TENIS
    E02	MACHINE ? PAIN
    E04	MACHINE A LAVER LA VAISSELLE
    E03	MACHINE A LAVER LE LINGE
    A04	MINI CHA?NE DE SALON
    E01	MIXEUR
    T04	NAPPE
    L02	RAQUETTE DE TENNIS
    T03	RIDEAU
    T01	SAC EN CUIR
    A01	TELEVISION 16-9
    B01	TUYAU D?ARROSAGE
    */

-- b) avec les initiales des noms en majuscules, classés par ordre alphabétique
    SELECT art.ca, INITCAP(art.noma)
    FROM art
    ORDER BY art.noma ASC;
    /*
    B03	Arrosoir
    B02	Beche
    T02	Bottes En Cuir
    M03	Canape
    L01	Console De Jeu
    A02	Ecran Plat
    M02	Lampe
    A03	Lecteur Dvd
    M01	Lit Pour Enfant
    L03	Lot De 4 Balles De Tenis
    E02	Machine ? Pain
    E04	Machine A Laver La Vaisselle
    E03	Machine A Laver Le Linge
    A04	Mini Cha?Ne De Salon
    E01	Mixeur
    T04	Nappe
    L02	Raquette De Tennis
    T03	Rideau
    T01	Sac En Cuir
    A01	Television 16-9
    B01	Tuyau D?Arrosage
    */

-- c) dont le nom commence par une consonne suivi d’un « a »
    SELECT art.ca, art.noma
    FROM art
    WHERE REGEXP_LIKE(LOWER(art.noma), '^[^aeiouy]a');
    /*
    E03	Machine a laver le linge
    E04	Machine a laver la vaisselle
    L02	Raquette de tennis
    M02	lampe
    M03	canape
    T01	Sac en cuir
    T04	nappe
    */

-- d) dont le nom contient la lettre « u »
    SELECT art.ca, art.noma
    FROM art
    WHERE LOWER(art.noma) LIKE '%u%';
    /*
    E01	Mixeur
    L01	Console de jeu
    L02	Raquette de tennis
    M01	Lit pour enfant
    T01	Sac en cuir
    T02	Bottes en cuir
    T03	Rideau
    */

-- e) dont le son du nom est « rydo »
    SELECT art.ca, art.noma
    FROM art
    WHERE SOUNDEX(art.noma) = SOUNDEX('rydo');
    -- T03	Rideau

-- 22. a) prix moyen des articles
    SELECT ROUND(AVG(art.prixa), 2) FROM art;
    -- 205,9

-- b) prix moyen des articles si on diminuait tous les prix de 10%, cette diminution ne pouvant excéder
-- toutefois 50€ 
    SELECT ROUND(AVG(
        CASE
            WHEN (art.prixa * 0.1) > 50 AND art.prixa >= 50 THEN (art.prixa - 50)
            WHEN (art.prixa * 0.1) > 50 THEN 0
            ELSE ( art.prixa - (art.prixa * 0.1) )
        END
    ), 2) AS prix_moyen_diminue FROM art;
    -- 192,46
