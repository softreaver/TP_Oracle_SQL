-- III - Les INDEX (ces requêtes seront sauvegardées dans le répertoire BD/TP4/INDEX)
--  1) Quels sont les index automatiquement créés par Oracle ? Vérifier en consultant les vues USER_INDEXES et USER_IND_COLUMNS du D.D.

    /* Les données affichées par les requêtes ci-dessous démontrent que Oracle a créé automatiquement des indexes pour toutes les clés primaires. */

SELECT * FROM USER_INDEXES;
SELECT * FROM USER_IND_COLUMNS;
/*
    PC_ART	ART	CA
    PC_COND	COND	CA
    PC_COND	COND	CE
    PC_EMB	EMB	CE
    PC_FRS	FRS	CF
*/


--  2) Créer tous les index souhaitables, sachant en outre que la table ART sera souvent consultée d’après le nom des articles.
CREATE INDEX nom_art
ON art(noma);
    -- Index NOM_ART créé(e).

--  3) Mettre en place la contrainte suivante : tous les noms d’emballage sont différents
ALTER TABLE emb
ADD CONSTRAINT nom_emb_unique UNIQUE (nome);
    -- Table EMB modifié(e).
    /* OBERVATION : Oracle indexe automatiquement les colonnes uniques */
