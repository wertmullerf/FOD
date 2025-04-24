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
	//'/Users/facundowertmuller/Desktop/FOD/practica1/facundo1 --> MAC
	reset(empleados); 
	while(not eof(empleados))do begin
		read(empleados, e);
		writeln('NRO EMPLEADO: ', e.nroEmpleado, ' EDAD: ', e.edad, ' APELLIDO: ', e.apellido);
	end;
	close(empleados);
END.
