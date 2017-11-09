1)
    select * from Vendedor 
    where nombre like 'a%' and apellido like'%z'

/////////////////////////////////////////////////////////////////////////
2)
    select c.* from venta as v
    inner join cliente as c on c.idCliente = v.idCliente
    inner join sucursal as s on v.idSucursal = s.idSucursal
    where s.Nombre = 'SAXONN S.A.';

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
    select s.nombre,p.*,sum(i.cantidad) as suma  
    from venta as v
    inner join sucursal as s on v.idsucursal = s.idsucursal
    inner join item as i on i.iditem = v.iditems
    inner join producto as p on i.idproducto = p.idproducto
    group by s.idsucursal
    order by s.idsucursal;

//////////////////////////////////////////////////////////////////////
10)
    select ve.nombre,(ve.comision+ve.basico)*count(v.idvendedor) as sueldo from venta as v
    inner join vendedor as ve on v.idvendedor=ve.idvendedor
    group by v.idvendedor;


//////////////////////////////////////////////////////////////////////
12)
     SELECT s.Nombre, MAX(i.cantidad*p.Precio) AS MEJOR, MIN(I.cantidad*p.Precio) AS PEOR 
     FROM venta v 
     INNER JOIN sucursal s ON (s.idSucursal = v.idSucursal) 
     INNER JOIN item i ON (i.idVenta = v.idVenta) 
     INNER JOIN producto p ON (p.idProducto = i.idProducto) 
     GROUP BY s.idsucursal 
     ORDER BY s.idsucursal ASC;
