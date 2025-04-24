PROGRAM ejer;
CONST
	PATH_BASE = '/Users/facundowertmuller/Desktop/FOD/practica3/ejercicio6/';
TYPE 	ave = record
				codigo:integer;
				nombre_especie, famia_ave, descripcion, zona: string[30];
			end;
			
			archivo = file of ave;
			
PROCEDURE borrarPorCodigo(var maestro:archivo; codigoBorrado:integer);
VAR
	borrado:boolean;
	reg:ave;
BEGIN
	reset(maestro);
	borrado:=false;	
	while((not eof(maestro)) and (not borrado))do begin
		read(maestro, reg);
		if(reg.codigo = codigoBorrado)then begin
			reg.codigo:= reg.codigo * (-1);
			seek(maestro, filepos(maestro) - 1);
			write(maestro, reg);
			borrado:= true;
		end;	
	end;
END;

VAR
	maestro:archivo;
	codigoBorrado:integer;
BEGIN
	assign(maestro, PATH_BASE + 'maestro');
	writeln('Ingrese el codigo de ave que desee eliminar');
	readln(codigoBorrado);
	borrarPorCodigo(maestro, codigoBorrado);
END.
