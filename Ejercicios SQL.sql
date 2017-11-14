1)
    select * from Vendedor 
    where nombre like 'a%' and apellido like'%z'

/////////////////////////////////////////////////////////////////////////
2)
    select c.* from venta as v
    inner join cliente as c on c.idCliente = v.idCliente
    inner join sucursal as sSucursal = s.idSucursal
    where s.Nombre = 'SAXONN S.A.'; on v.id

////////////////////////////////////////////////////////////////////////
3)
    select s.idsucursal , s.nombre , s.direccion , count(v.idvendedor) from sucursal as s
    inner join vendedorsucursal as v on s.idSucursal = v.idSucursal
    group by s.idsucursal
    order by s.Nombre;

////////////////////////////////////////////////////////////////////////
4)  
    select p.nombre,count(v.idventa) from item as i
    inner join venta as v on i.idItem = v.idItems
    inner join producto as p on p.idProducto = i.idProducto
    group by p.Nombre
    order by p.Nombre;

///////////////////////////////////////////////////////////////////////
5)
    select s.*,sum(i.cantidad) as Cantidad from venta as v
    inner join sucursal as s on v.idSucursal = s.idSucursal
    inner join item as i on v.idItems = i.idItem
    where ((select sum(it.cantidad) from venta as ve
    inner join sucursal as su on ve.idSucursal = su.idSucursal
    inner join item as it on ve.idItems = it.idItem where su.idsucursal=s.idsucursal) > 20)
    group  by s.idsucursal
    order by Cantidad desc limit 10 ;

///////////////////////////////////////////////////////////////////////
6)
    select ven.*, count(v.idventa) as cantidad from venta as v
    inner join vendedor as ven on v.idvendedor = ven.idvendedor
    where (select count(*) from venta where idvendedor = ven.idvendedor) > 4
    group by ven.idvendedor
    order by cantidad;

///////////////////////////////////////////////////////////////////////
7)
    select ve.* from venta as v
    right join vendedor as ve
    on v.idvendedor = ve.idvendedor
    where v.idvendedor is null;

///////////////////////////////////////////////////////////////////////
8)
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

//////////////////////////////////////////////////////////////////////
9)
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

//////////////////////////////////////////////////////////////////////
10)
    select ve.nombre,(ve.comision+ve.basico)*count(v.idvendedor) as sueldo from venta as v
    inner join vendedor as ve on v.idvendedor=ve.idvendedor
    group by v.idvendedor;


//////////////////////////////////////////////////////////////////////
12)
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
