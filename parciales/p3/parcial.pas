PROGRAM parcial;
CONST
	valoralto = 9999;
	PATH_BASE = '/Users/facundowertmuller/Desktop/FOD/parciales/p3/';
TYPE
	log = record
		numero_usuario, cantidad_mails:integer;
		nombre_usuario, nombre, apellido:string[30]; 
	
	end;
	
	maestro = file of log;
	
	detalleReg = record
		numero_usuario,cuenta_destino:integer;
		cuerpo:string[30];
	end;
	
	archivoDetalle = file of detalleReg;
	
	
PROCEDURE leer(var archivo: archivoDetalle; var dato: detalleReg);
BEGIN
	if(not eof(archivo))then
		read(archivo,dato)
	else
		dato.numero_usuario := valoralto;
END;
PROCEDURE incisoA (var mae:maestro; var detalle:archivoDetalle);
VAR
	regm:log;
	d:detalleReg;
BEGIN
	reset(mae);
	reset(detalle);
	leer(detalle, d);
	while(d.numero_usuario <> valoralto)do begin
		read(mae,regm);
		while(regm.numero_usuario <> d.numero_usuario)do
			read(mae,regm);
		
		while(regm.numero_usuario = d.numero_usuario) do begin
			regm.cantidad_mails:= regm.cantidad_mails + 1;
			leer(detalle, d);
		end;
		
		seek(mae, filepos(mae)- 1);
		write(mae, regm);
	end;
	close(mae);
	close(detalle);
END;

PROCEDURE incisoB(var mae: maestro; var txt: text);
VAR
	regm:log;
BEGIN
	reset(mae);
	rewrite(txt);
	while(not eof(mae))do begin
		read(mae, regm);
		writeln(txt,'NRO USUARIO: ', regm.numero_usuario, ' NOMBRE USUARIO: ', regm.nombre_usuario, ' CANTIDAD MENSAJES: ', regm.cantidad_mails);
	end;
	close(mae);
	close(txt);
END;
VAR
	mae:maestro;
	detalle: archivoDetalle;
	opcion:integer;
	archTxt: text;
BEGIN
	assign(mae, PATH_BASE + 'logsmall.dat');
	assign(detalle, PATH_BASE + '6junio2017.dat');
	assign(archTxt, PATH_BASE + 'listado.txt');
	writeln('Ingresa la operación a realizar');
	readln(opcion);
	
	case opcion of
		1: incisoA(mae,detalle);
		2: incisoB(mae, archTxt);
	end;
END.
