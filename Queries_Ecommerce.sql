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