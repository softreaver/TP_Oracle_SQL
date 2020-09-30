-- I - Cr�er un nouveau utilisateur c##TestView
--      D�finir le mot de passe lors de la cr�ation. Ce mot de passe doit �tre modifier lors de la premi�re connextion
--      Attribuer tous les droits n�cessaires � cet utilisateur pour pouvoir cr�er, modifier et interroger la BDD
--      Ajouter � cet utilisateur le sch�ma de TP2 (executer le code tp2 generation BDD - correction TP1.sql)

CREATE ROLE C##ROLES_TP4 ;

GRANT CREATE SESSION ,CREATE TABLE ,CREATE VIEW TO C##ROLES_TP4;

create profile "C##PROFILE_TP4" limit
        cpu_per_session UNLIMITED
        cpu_per_call UNLIMITED
        connect_time UNLIMITED
        idle_time UNLIMITED
        sessions_per_user UNLIMITED
        logical_reads_per_session UNLIMITED
        logical_reads_per_call UNLIMITED
        private_sga UNLIMITED
        composite_limit UNLIMITED
        password_life_time UNLIMITED
        password_grace_time UNLIMITED
        password_reuse_max UNLIMITED
        password_reuse_time UNLIMITED
        password_verify_function NULL
        failed_login_attempts UNLIMITED
        password_lock_time UNLIMITED;

CREATE USER C##TestView IDENTIFIED BY mysecret DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp PASSWORD EXPIRE;
ALTER USER C##TestView QUOTA 100M ON users;
ALTER USER C##TestView  PROFILE C##PROFILE_TP4;
GRANT C##ROLES_TP4, connect, resource TO C##TestView;


