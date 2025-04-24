PROGRAM ejer3;
TYPE
	empleado = record
		nroEmpleado: integer;
		apellido: string[25];
		edad:integer;
		DNI:string;
	end;
	
	empleados_file = file of empleado;
	
PROCEDURE leerEmpleado(var e:empleado);
BEGIN
	writeln('INGRESE EL APELLIDO');
	readln(e.apellido);
	if(e.apellido <> 'fin') then begin
		writeln('INGRESE EL NRO DE EMPLEADO');
		readln(e.nroEmpleado);
		e.edad:= 20 + random(80);
		e.dni := '000001234';
	end;
END;
VAR
	empleados: empleados_file;
	e:empleado;
	ape:string;
BEGIN	
	assign(empleados, '/Users/facundowertmuller/Desktop/FOD/practica1/facundo1');
	reset(empleados);
	seek(empleados, fileSize(empleados));
	leerEmpleado(e);
	while(e.apellido <> 'fin') do begin
		write(empleados, e);
		leerEmpleado(e);
	end;
	close(empleados);
END.
