PROGRAM parcial;
CONST
  PATH_BASE = '/Users/facundowertmuller/Desktop/FOD/parciales/p2/';
	DF=3;
	valoralto =9999;
TYPE
	producto = record
		codigo:integer;
		nombre,descripcion,codigo_barra,categoria:string[30];
		stock_actual,stock_minimo:integer;
	end;
	
	archivoProducto = file of producto;
	pedido = record
		codigo,cantidad:integer;
		descripcion:string[30];
	end;
	
	archivoDetalle  = file of pedido;
	vArchDetalle = array[1..DF] of archivoDetalle;
	vRegDetalle = array[1..DF] of pedido;

PROCEDURE leer (var archivo:archivoDetalle; var dato:pedido);
BEGIN
	if (not eof( archivo ))then 
		read (archivo, dato)
  else 
	  dato.codigo := valoralto;
END;

PROCEDURE 	minimo(var registrosDetalle: vRegDetalle; var min: pedido; var archivosDetalle: vArchDetalle);
VAR
	i,indice:integer;
BEGIN
	min.codigo := valoralto;
	for i:= 1 to DF do begin
		if(registrosDetalle[i].codigo <= min.codigo)then begin
			indice:= i;
			min:= registrosDetalle[i];
		end;
	end;
	if(min.codigo <> valoralto)then
		leer(archivosDetalle[indice], registrosDetalle[indice]);
END;

VAR
	maestro: archivoProducto;
	regm: producto;
	vArch: vArchDetalle;
	vReg: vRegDetalle;
	min: pedido;
	i:integer; 
	a:string;
BEGIN
	assign(maestro, PATH_BASE + 'maestro.dat');
	reset(maestro);
	
	for i:= 1 to 3 do begin
		Str(i,a);
		assign(vArch[i], PATH_BASE + 'detalle' + a + '.dat');
		reset(vArch[i]);
		leer(vArch[i], vReg[i]);
	end;
	
	minimo(vReg,min,vArch);
	while(min.codigo <> valoralto)do begin
		read(maestro,regm);
		while(regm.codigo<>min.codigo)do
			read(maestro, regm);
		
		while(regm.codigo = min.codigo)do begin
			if(regm.stock_actual >= min.cantidad)then
				regm.stock_actual:= regm.stock_actual - min.cantidad
			else begin
				writeln('No se pudo satisfacer pedido completo del producto ', regm.codigo);
				writeln('Cantidad pedida: ', min.cantidad, ' | Enviada: ', regm.stock_actual,
						' | Faltante: ', min.cantidad - regm.stock_actual);
				// Se entrega lo que hay
				regm.stock_actual := 0;
			end;
			minimo(vReg,min,vArch);
		end;
	
		if(regm.stock_actual < regm.stock_minimo)then
			writeln('Producto ', regm.codigo, ' bajo stock mínimo. Categoría: ', regm.categoria);
			
		seek(maestro, filepos(maestro)-1);
		write(maestro,regm);
	end;
	
	for i := 1 to DF do
		close(vArch[i]);
	close(maestro);
END.
