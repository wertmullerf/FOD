PROGRAM ejer;
CONST 
	PATH_BASE= '/Users/facundowertmuller/Desktop/FOD/practica2/ejercicio2/';
	valoralto=9999;
TYPE producto = record
			codigo, stock_min, stock_actual:integer;
			nombre:string[25];
			precio:real;
		end;
		
		venta = record
			codigo,cantidad:integer;
		end;
		archivo = file of producto;
		detalle = file of venta;

PROCEDURE leerMaestro(var arch: archivo; var p:producto);
BEGIN
	if(not eof(arch))then
		read(arch, p)
	else
		p.codigo:= valoralto;
END;
PROCEDURE leerDetalle(var arch: detalle; var v:venta);
BEGIN
	if(not eof(arch))then
		read(arch, v)
	else
		v.codigo:= valoralto;
END;

VAR
	maestro:archivo;
	det: detalle;
	p:producto;
	v:venta;
	totalVendido:integer;
BEGIN
	assign(maestro, PATH_BASE + 'maestro');
	assign(det, PATH_BASE + 'detalle');
	reset(maestro);
	reset(det);
	leerDetalle(det, v);
	while(v.codigo <> valoralto)do begin 
		seek(maestro, 0); // --> al no estar ordenado me tengo que ir poniendo en la primera pos por cada iteracion
		leerMaestro(maestro, p);
		while((p.codigo <> valoralto)and(p.codigo <> v.codigo))do
			leerMaestro(maestro, p);
		
		if(p.codigo = v.codigo)then begin
			totalVendido:= 0;
			while(p.codigo = v.codigo)do begin
				totalVendido:= totalVendido + v.cantidad;
				leerDetalle(det, v);
			end;
			p.stock_actual := p.stock_actual - totalVendido;
			seek(det, filepos(det) -1);
			write(maestro, p);
		end;
		
		leerDetalle(det,v); // avanzo en el detalle
	end;
	
	close(maestro);
	close(det);
END.
