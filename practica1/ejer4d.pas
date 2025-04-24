PROGRAM ejer3;
TYPE
	empleado = record
		nroEmpleado: integer;
		apellido: string[25];
		edad:integer;
		DNI:string;
	end;
	
	empleados_file = file of empleado;

VAR
	archivo_binario: empleados_file;
	e: empleado;
	archivo_texto: text;
BEGIN
	assign(archivo_binario, '/Users/facundowertmuller/Desktop/FOD/practica1/facundo1');
	assign(archivo_texto, '/Users/facundowertmuller/Desktop/FOD/practica1/faltaDNIEmpleado.txt');
	reset(archivo_binario);
	rewrite(archivo_texto);
	while(not eof(archivo_binario)) do begin
		read(archivo_binario, e);
		if(e.DNI = '00')then
			writeln(archivo_texto, e.nroEmpleado, ' ', e.apellido, ' ', e.edad, ' ', e.DNI);
	end;
	close(archivo_binario);
	close(archivo_texto);
END.
