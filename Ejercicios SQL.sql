-- 1) Bien
    select * from Vendedor 
    where nombre like 'a%' and apellido like'%z'

-- /////////////////////////////////////////////////////////////////////////
-- 2) Bien
    select c.* from venta as v
    inner join cliente as c on c.idCliente = v.idCliente
    inner join sucursal as s on v.idSucursal = s.idSucursal
    where s.Nombre = 'SAXONN S.A.';

-- ////////////////////////////////////////////////////////////////////////
-- 3) Bien
    select s.idsucursal , s.nombre , s.direccion , count(v.idvendedor) from sucursal as s
    inner join vendedorsucursal as v on s.idSucursal = v.idSucursal
    group by s.idsucursal
    order by s.Nombre;

-- ////////////////////////////////////////////////////////////////////////
-- 4) Bien  
    select p.nombre,count(v.idventa) from item as i
    inner join venta as v on i.idItem = v.idItems
    inner join producto as p on p.idProducto = i.idProducto
    group by p.Nombre
    order by p.Nombre;

-- ///////////////////////////////////////////////////////////////////////
-- 5) Bien
    select s.*,sum(i.cantidad) as Cantidad from venta as v
    inner join sucursal as s on v.idSucursal = s.idSucursal
    inner join item as i on v.idItems = i.idItem
    where ((select sum(it.cantidad) from venta as ve
    inner join sucursal as su on ve.idSucursal = su.idSucursal
    inner join item as it on ve.idItems = it.idItem where su.idsucursal=s.idsucursal) > 20)
    group  by s.idsucursal
    order by Cantidad desc limit 10 ;
    
    -- la consulta anterior esta bien pero el ejercicio se resuelve de formas as simple utilizando la sentencia Having!!. Ejemplo
	Select s.*, sum(i.cantidad) as Cantidad
	from sucursal s 
		inner join venta v on s.idSucursal = v.idSucursal
		inner join item i on v.idItems = i.idItem
	group by s.idsucursal
	having cantidad > 20
	order by Cantidad desc limit 10 ;

-- ///////////////////////////////////////////////////////////////////////
-- 6) Bien
    select ven.*, count(v.idventa) as cantidad from venta as v
    inner join vendedor as ven on v.idvendedor = ven.idvendedor
    where (select count(*) from venta where idvendedor = ven.idvendedor) > 4
    group by ven.idvendedor
    order by cantidad;
    
    -- la consulta anterior esta bien pero el ejercicio se resuelve de formas as simple utilizando la sentencia Having!!. Ejemplo
    select ven.*, count(v.idventa) as cantidad from venta as v
    inner join vendedor as ven on v.idvendedor = ven.idvendedor
    group by ven.idvendedor
    having cantidad > 4
    order by cantidad;

-- ///////////////////////////////////////////////////////////////////////
-- 7) Excelente
    select ve.* from venta as v
    right join vendedor as ve
    on v.idvendedor = ve.idvendedor
    where v.idvendedor is null;

-- ///////////////////////////////////////////////////////////////////////
-- 8) Con Correcion
   select v.idventa,s.idsucursal,i.idproducto, sum(i.cantidad) as suma from venta as v
    inner join sucursal as s on v.idsucursal=s.idsucursal
    inner join item as i on v.iditems=i.iditem
    group by s.idsucursal,i.idproducto
    having (select sum(it.cantidad) as cant from venta as ve
    inner join item as it on ve.iditems=it.iditem
    where ve.idsucursal=s.idsucursal
    group by it.idproducto 
    order by cant desc
    limit 1) = suma;

-- Este ejercicio se compone de dos consultas donde una de ellas calculo la cantidad de ventas de cada uno de los prductos (sentencia select que se usa como FROM) la segunda consula obtiene los registros cuya venta sea maxima. 
-- El secreto de este ejercicio es utilizar la respuesta de una consulta select como tabla para ser incluida en una nueva sentencia select mayor
    select sucursalNombre, prductoNombre, MAX(cantidad)
    from 
		(select s.Nombre sucursalNombre, p.nombre prductoNombre, sum(i.cantidad) cantidad
		from sucursal s 
			inner join venta v on s.idSucursal = v.idSucursal
			inner join item i on v.idItems = i.idItem
			inner join producto p on i.idProducto = p.idProducto
		group by s.Nombre, p.nombre) datos
    group by sucursalNombre;
-- //////////////////////////////////////////////////////////////////////
-- 9) Con Correcion
    select  s.idsucursal,v.idcliente,sum(i.cantidad*p.precio) as suma from venta as v
    inner join sucursal as s on v.idsucursal=s.idsucursal
    inner join item as i on v.iditems=i.iditem
    inner join cliente as c on c.idcliente=v.idcliente
    inner join producto as p on p.idproducto=i.idproducto
    group by s.idsucursal,c.idcliente
    having (select sum(it.cantidad*pr.precio) as cant from venta as ve
    inner join item as it on ve.iditems=it.iditem
    inner join producto as pr on it.idproducto= pr.idproducto
    where ve.idsucursal=s.idsucursal
    group by ve.idcliente
    order by cant desc
    limit 1) = suma
    
    -- la consulta no responde a la consigna. La consulta correcta es la siguiente.
	select nombre, apellido, 'Cliente'
	from cliente 

	union 

	select nombre, apellido, 'Vendedor'
	from vendedor

-- //////////////////////////////////////////////////////////////////////
-- 10) Con Correcion
    select ve.nombre,(ve.comision+ve.basico)*count(v.idvendedor) as sueldo from venta as v
    inner join vendedor as ve on v.idvendedor=ve.idvendedor
    group by v.idvendedor;
    
    -- El parentesis en la cuenta es incorrecto porque no es lo mismo (2+2) * 3 que 2 + (2*3) falta el nombre de la sucursal. La consulta correcta es:

	select ve.nombre nombreVendedor, ve.basico + (ve.comision*count(v.idvendedor)) as sueldo, s.nombre nombreSucursal
	from venta as v
		inner join vendedor as ve on v.idvendedor=ve.idvendedor
		inner join sucursal as s on s.idSucursal = v.idSucursal
		group by v.idvendedor;
        
-- //////////////////////////////////////////////////////////////////////
-- 11) Falta el ejercicio
-- Este ejercicio se resuelve de forma similar que el ejercicio 8 utilizando dos consultas. La primera consulta retorna el listado de todos los clientes por sucursal con su total de compras
-- El resultado de esta consulta se utiliza como tabla para la consulta principal donde esta hace una max del total de ventas calculado por cliente.

select NombreSucursal, Nombre, Apellido, DNI, Direccion, MAX(totalCompras)
from 
	(Select s.nombre NombreSucursal, c.Nombre, c.Apellido, c.DNI, c.Direccion, sum(i.cantidad * p.Precio) totalCompras
	from sucursal s
		inner join venta v on s.idSucursal = s.idSucursal
		inner join cliente c on c.idCliente = v.idCliente
		inner join item i on v.idVenta = i.idVenta
		inner join producto p on i.idProducto = p.idProducto
	group by s.nombre, c.Nombre, c.Apellido, c.DNI, c.Direccion) AS datos
group by NombreSucursal, Nombre, Apellido, DNI, Direccion


-- //////////////////////////////////////////////////////////////////////
-- 12)  Falta el ejercicio
     (select  s.idsucursal,v.idventa, sum(i.cantidad*p.precio) as mejor from venta as v
    inner join sucursal as s on v.idsucursal=s.idsucursal
    inner join item as i on v.iditems=i.iditem
    inner join producto as p on p.idproducto=i.idproducto
    group by s.idsucursal,v.idventa
    having (select sum(it.cantidad*pr.precio) as cant from venta as ve
    inner join item as it on ve.iditems=it.iditem
    inner join producto as pr on it.idproducto= pr.idproducto
    where ve.idsucursal=s.idsucursal
    group by ve.idventa
    order by cant desc
    limit 1) = mejor)
    union all
    (select  suc.idsucursal,ven.idventa,sum(ite.cantidad*pro.precio) as peor from venta as ven
    inner join sucursal as suc on ven.idsucursal=suc.idsucursal
    inner join item as ite on ven.iditems=ite.iditem
    inner join producto as pro on pro.idproducto=ite.idproducto
    group by suc.idsucursal,ven.idventa
    having (select sum(it.cantidad*pr.precio) as cant from venta as ve
    inner join item as it on ve.iditems=it.iditem
    inner join producto as pr on it.idproducto= pr.idproducto
    where ve.idsucursal=suc.idsucursal
    group by ve.idventa
    order by cant asc
    limit 1)=peor)
    
-- Este ejercicio se resuelve de forma similar que el ejercicio 8 y 11 utilizando dos consultas. La primera consulta retorna el listado de todos las ventas por sucursal
-- El resultado de esta consulta se utiliza como tabla para la consulta principal donde esta hace una max y min de total de ventas
select s.Nombre, max(VentaTotal) MejorVenta, min(VentaTotal) PeorVenta
from
	(select s.idSucursal, sum(i.cantidad * p.precio) VentaTotal
	from sucursal s 
		inner join venta v on v.idSucursal = s.idSucursal  
		inner join item i on i.idVenta = v.idVenta
		inner join producto p on p.idProducto = i.idProducto
	group by s.idSucursal) datos
	inner join sucursal s on datos.idSucursal = s.idSucursal
group by Nombre;

