
1)
delimiter $$
CREATE PROCEDURE CargarCliente (nombree varchar(30), apellidoo varchar(30), dnii int, dir varchar(45))
begin
	declare id int;
		if exists (select * from cliente where DNI=dnii) then
			update cliente set Nombre=nombree, Apellido=apellidoo, DNI=dnii, Direccion=dir where DNI=dnii;
        else
			set id = (select max(idCliente) from cliente);
			insert into cliente values  (id,nombree, apellidoo, dnii, dir);
		end if;
 end $$
///////////////////////////////////////////////////////////////////
2)))

delimiter $$
drop procedure AsignarVendedor $$
CREATE PROCEDURE AsignarVendedor(NombreSucursall varchar(45), DNIVendedorr varchar(45))
begin
    declare Idvendedorr varchar(45);
    declare IdSuc varchar(45);
    declare IdIncremental INT;
	if exists(select * from vendedor where DNI=DNIVendedorr)then
		if exists (select * from sucursal where Nombre=NombreSucursall) then
		set idVendedorr=(select idVendedor from vendedor where DNI=DNIVendedorr);
        set idSuc= (select idSucursal from sucursal where Nombre=NombreSucursall limit 1);
			if not exists (select * from vendedorsucursal where idvendedorr=idVendedor and idsuc=idSucursal) then
            begin
				set IdIncremental = (select count(*) + 1 from vendedorsucursal);
				insert into vendedorsucursal values (IdIncremental,IdSuc,Idvendedorr);
			end;
			else
				select'La sucursal tiene vededor';
			end if;
		else
			select ' la sucursal no existe';
	end if;
	else
		select 'el vendedor NO existe';
	 
	end if;
end $$

call AsignarVendedor('LUGO S.A.', '4049118933');

///////////////////////////////////////////////////////////////////
3)))
CREATE DEFINER=`root`@`localhost` PROCEDURE `AgregarItemVenta`(IdVentaa int, NombreProductoo varchar(30), Cantidadd int)
begin
declare idproductoo,idsucursall,iditemm int;
	if exists  (select * from producto where Nombre=NombreProductoo) then
		set idproductoo =(select idProducto from producto where Nombre=NombreProductoo);
		if exists (select * from Venta where idVenta=IdVentaa) then
			set idsucursall= (select idSucursal from Venta where idVenta=IdVentaa);
            if ((select Cantidad from Stock where (idProducto=idproductoo) and (idSucursal=idsucursall) )>= Cantidadd) then
				set iditemm = (SELECT idItem from Item where idItem = (SELECT max(idItem) from Item))+1;
                insert into item values (iditemm,idVentaa,idproductoo,cantidadd);
                update stock set cantidad= cantidad - cantidadd where idsucursal=idsucursall and idproducto=idproductoo;
			else
				Select 'No hay stock';
			end if;
		end if;
    end if;
end
call AgregarItemVenta(204,'Transpaletas hidráulicas',5);
select * from producto where idproducto=873;
select * from stock where idproducto=873
select * from venta where idsucursal=697
select * from item where iditem=1002
select Cantidad from Stock where idProducto=873 and idSucursal=697

//////////////////////////////////////////////////////////////////////////////////

4)))

delimiter $$
create procedure ActualizarPrecios(porcentaje int)
begin
	update producto as p set precio = Precio*((porcentaje/100)+1) 
	where (select sum(cantidad) from item where idproducto=p.idproducto)>10
	select 'Precios actualizados';
end $$

//////////////////////////////////////////////////////////////////////////////////

5)))

delimiter $$
create procedure AltaStock(NombreSucursall char(45),NombreProductoo char(45), Cantidadd int)
begin
declare idsuc,idprod,idstockk int;
		if exists( select idSucursal from sucursal where NombreSucursall=Nombre) then
			set idsuc = (select idSucursal from sucursal where Nombre=NombreSucursall limit 1);
			if exists(select idproducto from producto where Nombre=NombreProductoo) then
			set idprod = (select idproducto from producto where Nombre=NombreProductoo);
	if exists (select st.idStock from producto as p 
	inner join stock as st on p.idProducto=st.idProducto
	inner join sucursal as s on s.idSucursal=st.idSucursal 
	where (s.Nombre=NombreSucursall) and (p.Nombre=NombreProductoo)) then
		
		update  stock set cantidad = cantidad + cantidadd where idSucursal=idsuc and idProducto	=idprod;
	else 
		set idstockk=(select max (idStock) from Stock)+1;
		insert into item values (idstockk,Cantidadd,idsuc,idprod);
	end if;
		else
		select 'No se encuentra la Sucursal';
		end if;
		else
			select 'No se encuentra el Producto';
		end if;
	
end $$

set SQL_SAFE_UPDATES=0; // para que deje modificar;

