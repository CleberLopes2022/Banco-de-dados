-- criação do banco de dados para E-comerce
create database ecomerce;

use ecomerce;

-- criando a tabela cliente
create table cliente(
	idClient int auto_increment,
    fname varchar(20) not null,
    minit char(3) not null,
    lname varchar (20) not null,
    cpf char(11) not null,
    data_nascimento date not null,
    constraint pk_client primary key (idClient), 
    constraint unique_cpf_client unique (cpf)
 );
 
 -- criando tabela Endereço
create table address(
	idAddress int,
	idClient int,
    typeAddres varchar (30)not null,
    zipCode char(9) not null,
    street varchar (30) not null,
    constraint pk_client primary key (idAddress, idClient),
    constraint fk_address_cliente foreign key (idClient) references cliente (idClient)
 ); 
 
		
 -- criando tabela produto 
 create table product(
	idProduct int auto_increment,
    pname varchar(10) not null,
    classification_kids bool default false,
    category enum ('Eletrônico', 'Vestimenta', 'Brinquedos', 'Móveis', 'Alimentos') not null,
    avaliacao float default 0,
    size varchar(10),
    constraint pk_idProduct primary key (idProduct)
);


-- criando tabela pedido
create table orders(
	idOrder int auto_increment,
    idOrderClient int,
    order_status enum('Cancelado', 'Confirmado', 'Em processamento') default 'Em processamento',
    order_descrition varchar(255),
    send_value float default 10,
    paymentCash bool default false,
    idOPayment int,
    constraint pk_idOrder primary key (idOrder),
    constraint fk_orders_client foreign key (idOrderClient) references cliente (idClient)
);


-- criando tabela pagamento
create table payments(
	idClient int,
    idPayment int,
    typePayment enum ('Cartão','Dois cartões'),
    limitAvailable float,
    constraint pk_payment_client primary key (idClient, idPayment),
    constraint fk_idClient_cliente foreign key (idClient) references cliente (idClient)
);


-- criando a tabela estoque
create table productStorage(
	idProductStorage int auto_increment,
    storageLocation varchar(255),
    quantity int default 0,
    constraint pk_idProductStorage primary key (idProductStorage)
);

-- criando tabela fornecedor
create table supplier (
	idSupplier int auto_increment,
    socialName varchar (255) not null,
    cnpj char(15) not null,
    contact char(11) not null,
    constraint pk_idFornecedor primary key (idSupplier),
    constraint unique_supplier unique (cnpj)
);

-- criando tabela vendedor
create table seller(
	idseller int auto_increment,
    socialName varchar (255) not null,
    cnpj char(15),
    cpf char(11),
    contact char(11),
    location varchar (255),
    constraint pk_seller primary key (idseller),
    constraint unique_cnpj unique (cnpj),
    constraint unique_cfpf unique (cpf) 
);


-- criando tabela produtos por vendedor
create table productSeller (
	idPSeller int,
    idPproduct int,
    prodQuantity int default 1,
    constraint pk_idPSeller_idProduct primary key (idPSeller, idPproduct),
    constraint fk_idProduct foreign key (idPproduct) references product (idProduct),
    constraint fk_idPseller foreign key (idPSeller) references seller (idSeller)
);

 
-- criando tabela de produto por pedido
create table productOrder(
	idPOrder int,
    idPOproduct int,
    poQuantity int default 1,
    poStatus enum ('Disponível', 'Sem estoque') default 'Disponível',
	constraint pk_idPOrder_idPOproduct primary key (idPOrder, idPOproduct),
    constraint fk_idPOrder foreign key (idPOrder) references orders (idOrder),
    constraint fk_idPOproduct foreign key (idPOproduct) references product (idProduct)
);


-- criando tabela locais de estoque
create table storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar (255) not null,
	constraint pk_idLproduct_idLstorage primary key (idLproduct, idLstorage),
    constraint fk_idLproduct foreign key (idLproduct) references product (idProduct),
    constraint fk_idLstorage foreign key (idLstorage) references productStorage (idProductStorage)
);


create table productSupplier (
	idPSupplier int,
    idPsproduct int,
    prodQuantity int not null,
    constraint pk_idPSupplier_idsProduct primary key (idPSupplier, idPsproduct),
    constraint fk_Supplier_idProduct foreign key (idPsproduct) references product (idProduct),
    constraint fk_idPSupplie_Supplier foreign key (idPSupplier) references supplier (idSupplier)
);

-- Ordenando por Id do cliente
SELECT * FROM clients ORDER BY idclient;

-- Nome completo do cliente e endereços
select concat(fname, minit, lname), a.street, a.country 
from clients c, address a 
where c.idClient=a.idClient;

-- Recuperando pedidos por cliente
select concat(fname, minit, lname), o.order_status, o.order_descrition, o.paymentCash
from clients c
inner join orders o
on idOrderClient=idClient;

-- Join com 3 tabelas para saber os prodrutos por estoque e localização
select idProduct, pname, category, quantity, storagelocation from storagelocation s
inner join productstorage ps on s.idLstorage=ps.idProductStorage
inner join product p on p.idProduct=s.idLproduct;

-- Recuperando produtos por pedido com subquerie
select * from product p
	where exists (select * from productorder
					where idproduct=idPOproduct);

-- Recuperando as vendas por vendedor e filtrando a localização
select socialname, cnpj, cpf, location 
from seller, productseller
where idpseller=idseller and location='São Paulo';

-- Agrupando e Filtrando com Group By e Having
select count(*), pname, category from product, productorder
where idProduct=IdPOproduct
group by pname, category
having count(*) > 1;
