PROGRAM ejer;
CONST
	valoralto=9999;
	PATH_BASE = '/Users/facundowertmuller/Desktop/FOD/practica3/ejercicio6/';

TYPE prenda = record
			cod_prenda, stock: integer;
			descripcion, colores, tipo_prenda:string[25];
			 precio_unitario: real;
		end;
		
		archivo = file of prenda;
		archivoBaja= file of integer;
		
PROCEDURE leerD(var arch:archivoBaja; var dato: integer);
BEGIN
	if(not eof(arch))then
		read(arch, dato)
	else
		dato:= valoralto;
END;

PROCEDURE leerM(var arch:archivo; var dato: prenda);
BEGIN
	if(not eof(arch))then
		read(arch, dato)
	else
		dato.cod_prenda:= valoralto;
END;

PROCEDURE bajaLogica(var maestro: archivo; var detalle: archivoBaja);
VAR
	datoM:prenda;
	datoD:integer;
	encontre: boolean;
BEGIN
	reset(maestro);
	reset(detalle);
	
	leerD(detalle,datoD);
	while(datoD <> valoralto)do begin
		seek(maestro, 0);
		leerM(maestro, datoM);
		encontre:=false;
		while((datoM.cod_prenda <> valoralto) and (not encontre)) do begin
			if(datoM.cod_prenda = datoD)then begin
				datoM.stock :=datoM.stock* ( -1);
				seek(maestro, filepos(maestro) -1);
				write(maestro, datoM);
				encontre:=true;
			end;
			leerM(maestro, datoM);
		end;
		leerD(detalle, datoD);
	end;
	close(maestro);
	close(detalle);
END;

PROCEDURE imprimir(var arch:archivo);
VAR
	reg:prenda;
BEGIN
	reset(arch);
	while(not eof(arch))do begin
		read(arch, reg);
		writeln('CODIGO PRENDA: ', reg.cod_prenda, ' STOCK: ', reg.stock);
	end;
	close(arch);
END;

PROCEDURE bajaFisica(var arch, nuevo: archivo);
VAR
	reg:prenda;
BEGIN
	reset(arch);
	rewrite(nuevo);
	leerM(arch, reg);
	while reg.cod_prenda <> valoralto do begin
		if reg.stock >= 0 then begin
			write(nuevo, reg);
		end;
		leerM(arch, reg);
	end;
	close(nuevo); close(arch);
	erase(arch);
	rename(nuevo, 'maestro');
END;
VAR
	maestro,nuevo: archivo;
	detalle: archivoBaja;
	
BEGIN
	assign(maestro, PATH_BASE+ 'maestro');
	assign(detalle, PATH_BASE + 'detalle');
	assign(nuevo, PATH_BASE + 'nuevo');
	imprimir(maestro);
	bajaLogica(maestro,detalle);
	writeln;writeln;writeln;
	imprimir(maestro);
	bajaFisica(maestro, nuevo);
	writeln;writeln;writeln;
	imprimir(nuevo);
END.
