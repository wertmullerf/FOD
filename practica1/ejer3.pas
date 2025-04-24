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
	empleados: empleados_file;
	e:empleado;
BEGIN	
	assign(empleados, '/Users/facundowertmuller/Desktop/FOD/practica1/facundo1');
	rewrite(empleados); {si no existe --> crea
						 si ya existe --> pisa el contenido}
	writeln('INGRESE EL APELLIDO');
	readln(e.apellido);
	while(e.apellido <> 'fin') do begin
		e.nroEmpleado := random(100);
		e.edad:= 20 + random(80);
		e.dni := '000001234';
		write(empleados, e);
		writeln('INGRESE EL APELLIDO');
		readln(e.apellido);
	end;
	close(empleados);
END.

