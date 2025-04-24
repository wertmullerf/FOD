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
	nroEmpleado,edad:integer;
	encontre:boolean;
BEGIN	
	assign(empleados, '/Users/facundowertmuller/Desktop/FOD/practica1/facundo1');
	reset(empleados);
	writeln('INGRESE EL NRO DE EMPLEADO A MODIFICAR');
	readln(nroEmpleado);
	writeln('INGRESE LA EDAD NUEVA');
	readln(edad);
	encontre:=false;
	while((not EOF(empleados)) and (not encontre)) do begin
		read(empleados, e);
		if(e.nroEmpleado = nroEmpleado)then begin
			encontre:= true;
			writeln('ENTRE');
			e.edad:= edad;
			seek (empleados, filepos(empleados)-1);
			write(empleados, e);
		end;
	end;
	close(empleados);
END.
