create table woody.product
(
    id   int auto_increment
        primary key,
    name varchar(200) null
);

INSERT INTO woody.product (id, name) VALUES (1, 'Yoyo');
INSERT INTO woody.product (id, name) VALUES (2, 'Joli train');

