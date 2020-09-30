-- III - Les INDEX (ces requ�tes seront sauvegard�es dans le r�pertoire BD/TP4/INDEX)
--  1) Quels sont les index automatiquement cr��s par Oracle ? V�rifier en consultant les vues USER_INDEXES et USER_IND_COLUMNS du D.D.

    /* Les donn�es affich�es par les requ�tes ci-dessous d�montrent que Oracle a cr�� automatiquement des indexes pour toutes les cl�s primaires. */

SELECT * FROM USER_INDEXES;
SELECT * FROM USER_IND_COLUMNS;
/*
    PC_ART	ART	CA
    PC_COND	COND	CA
    PC_COND	COND	CE
    PC_EMB	EMB	CE
    PC_FRS	FRS	CF
*/


--  2) Cr�er tous les index souhaitables, sachant en outre que la table ART sera souvent consult�e d�apr�s le nom des articles.
CREATE INDEX nom_art
ON art(noma);
    -- Index NOM_ART cr��(e).

--  3) Mettre en place la contrainte suivante : tous les noms d�emballage sont diff�rents
ALTER TABLE emb
ADD CONSTRAINT nom_emb_unique UNIQUE (nome);
    -- Table EMB modifi�(e).
    /* OBERVATION : Oracle indexe automatiquement les colonnes uniques */
