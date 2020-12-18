
CREATE TABLE budzet (
    id_budzetu  NUMERIC(10) NOT NULL,
    kategoria   VARCHAR(255),
    prog       NUMERIC(7, 2)
);

ALTER TABLE budzet ADD CONSTRAINT budzet_pk PRIMARY KEY ( id_budzetu );

CREATE TABLE impreza_kulturalna (
    id_uslugi           NUMERIC(10) NOT NULL,
    id_imprezy          NUMERIC(10),
    oczekiwana_wartosc  NUMERIC(6, 2) NOT NULL
);

ALTER TABLE impreza_kulturalna ADD CONSTRAINT impreza_kulturalna_pk PRIMARY KEY ( id_uslugi );

CREATE TABLE komisja (
    id_komisji NUMERIC(10) NOT NULL
);

ALTER TABLE komisja ADD CONSTRAINT komisja_pk PRIMARY KEY ( id_komisji );

CREATE TABLE opieka_medyczna (
    id_uslugi              NUMERIC(10) NOT NULL,
    id_opieki_medycznej    NUMERIC(10),
    oczekiwana_refundacja  NUMERIC(6, 2) NOT NULL
);

ALTER TABLE opieka_medyczna ADD CONSTRAINT opieka_medyczna_pk PRIMARY KEY ( id_uslugi );

CREATE TABLE parametry (
    parametr_niskodochodowy  NUMERIC(3, 2) NOT NULL,
    oprocentowanie_uslug     NUMERIC(4, 2) NOT NULL
);

CREATE TABLE pomoc_mieszkaniowa (
    id_uslugi                NUMERIC(10) NOT NULL,
    id_pomocy_mieszkaniowej  NUMERIC(10),
    oczekiwana_wartosc       NUMERIC(6, 2) NOT NULL,
    dlugosc                  NUMERIC(2)
);

ALTER TABLE pomoc_mieszkaniowa ADD CONSTRAINT pomoc_mieszkaniowa_pk PRIMARY KEY ( id_uslugi );

CREATE TABLE pracownik (
    id_pracownika           NUMERIC(10) NOT NULL,
    imie                    VARCHAR(255 ) NOT NULL,
    nazwisko                VARCHAR(255 ) NOT NULL,
    stanowisko              VARCHAR(255 ) NOT NULL,
    data_rozpoczecia_pracy  TIMESTAMP WITH TIME ZONE NOT NULL,
    pesel                   VARCHAR(11) NOT NULL,
    pensja                  NUMERIC(12, 2) NOT NULL,
    komisja_id_komisji      NUMERIC(10) NOT NULL
);

ALTER TABLE pracownik ADD CONSTRAINT pracownik_pk PRIMARY KEY ( id_pracownika );

CREATE TABLE refundacja_wakacji (
    id_uslugi            NUMERIC(10) NOT NULL,
    id_refundacji        NUMERIC(10),
    wartosc_oczrekiwana  NUMERIC(6, 2) NOT NULL
);

ALTER TABLE refundacja_wakacji ADD CONSTRAINT refundacja_wakacji_pk PRIMARY KEY ( id_uslugi );

CREATE TABLE uslugi (
    id_uslugi          NUMERIC(10) NOT NULL,
    rodzaj_uslugi      VARCHAR(255 ) NOT NULL,
    wymagany_dokument  VARCHAR(255 ) NOT NULL,
    max_wartosc        NUMERIC(10, 2)
);

--  ERROR: No Discriminator Column found in Arc FKArc_1 - check constraint cannot be generated

ALTER TABLE uslugi ADD CONSTRAINT uslugi_pk PRIMARY KEY ( id_uslugi );

CREATE TABLE wniosek (
    id_wniosku               NUMERIC(10) NOT NULL,
    decyzja                  VARCHAR(255 ) NOT NULL,
    uwaga                    VARCHAR(255 ),
    uwaga_komisji            VARCHAR(255 ),
    data_zlozenia            TIMESTAMP WITH TIME ZONE NOT NULL,
    data_zamkniecia          TIMESTAMP WITH TIME ZONE NOT NULL,
    pracownik_id_pracownika  NUMERIC(10) NOT NULL,
    uslugi_id_uslugi         NUMERIC(10) NOT NULL,
    komisja_id_komisji       NUMERIC(10) NOT NULL
);

ALTER TABLE wniosek ADD CONSTRAINT wniosek_pk PRIMARY KEY ( id_wniosku );

CREATE TABLE wykorzystanie (
    wykorzystanie            NUMERIC(7, 2),
    niski_dochod             CHAR(1),
    budzet_id_budzetu        NUMERIC(10) NOT NULL,
    pracownik_id_pracownika  NUMERIC(10) NOT NULL
);

CREATE TABLE zapomoga (
    id_uslugi           NUMERIC(10) NOT NULL,
    id_zapomogi         NUMERIC(10),
    oczekiwana_wartosc  NUMERIC(6, 2) NOT NULL
);

ALTER TABLE zapomoga ADD CONSTRAINT zapomoga_pk PRIMARY KEY ( id_uslugi );

CREATE TABLE zalaczniki (
    id_zalacznika       NUMERIC(10) NOT NULL,
    tresc               VARCHAR(255) NOT NULL,
    wniosek_id_wniosku  NUMERIC(10) NOT NULL
);

ALTER TABLE zalaczniki ADD CONSTRAINT zalaczniki_pk PRIMARY KEY ( id_zalacznika );

ALTER TABLE impreza_kulturalna
    ADD CONSTRAINT impreza_kulturalna_uslugi_fk FOREIGN KEY ( id_uslugi )
        REFERENCES uslugi ( id_uslugi );

ALTER TABLE opieka_medyczna
    ADD CONSTRAINT opieka_medyczna_uslugi_fk FOREIGN KEY ( id_uslugi )
        REFERENCES uslugi ( id_uslugi );

ALTER TABLE pomoc_mieszkaniowa
    ADD CONSTRAINT pomoc_mieszkaniowa_uslugi_fk FOREIGN KEY ( id_uslugi )
        REFERENCES uslugi ( id_uslugi );

ALTER TABLE pracownik
    ADD CONSTRAINT pracownik_komisja_fk FOREIGN KEY ( komisja_id_komisji )
        REFERENCES komisja ( id_komisji );

ALTER TABLE refundacja_wakacji
    ADD CONSTRAINT refundacja_wakacji_uslugi_fk FOREIGN KEY ( id_uslugi )
        REFERENCES uslugi ( id_uslugi );

ALTER TABLE wniosek
    ADD CONSTRAINT wniosek_komisja_fk FOREIGN KEY ( komisja_id_komisji )
        REFERENCES komisja ( id_komisji );

ALTER TABLE wniosek
    ADD CONSTRAINT wniosek_pracownik_fk FOREIGN KEY ( pracownik_id_pracownika )
        REFERENCES pracownik ( id_pracownika );

ALTER TABLE wniosek
    ADD CONSTRAINT wniosek_uslugi_fk FOREIGN KEY ( uslugi_id_uslugi )
        REFERENCES uslugi ( id_uslugi );

ALTER TABLE wykorzystanie
    ADD CONSTRAINT wykorzystanie_budzet_fk FOREIGN KEY ( budzet_id_budzetu )
        REFERENCES budzet ( id_budzetu );

ALTER TABLE wykorzystanie
    ADD CONSTRAINT wykorzystanie_pracownik_fk FOREIGN KEY ( pracownik_id_pracownika )
        REFERENCES pracownik ( id_pracownika );

ALTER TABLE zapomoga
    ADD CONSTRAINT zapomoga_uslugi_fk FOREIGN KEY ( id_uslugi )
        REFERENCES uslugi ( id_uslugi );

ALTER TABLE zalaczniki
    ADD CONSTRAINT zalaczniki_wniosek_fk FOREIGN KEY ( wniosek_id_wniosku )
        REFERENCES wniosek ( id_wniosku );

--  ERROR: No Discriminator Column found in Arc FKArc_1 - constraint trigger for Arc cannot be generated 

--  ERROR: No Discriminator Column found in Arc FKArc_1 - constraint trigger for Arc cannot be generated 

--  ERROR: No Discriminator Column found in Arc FKArc_1 - constraint trigger for Arc cannot be generated 

--  ERROR: No Discriminator Column found in Arc FKArc_1 - constraint trigger for Arc cannot be generated 

--  ERROR: No Discriminator Column found in Arc FKArc_1 - constraint trigger for Arc cannot be generated



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                            13
-- CREATE INDEX                             0
-- ALTER TABLE                             23
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   6
-- WARNINGS                                 0
