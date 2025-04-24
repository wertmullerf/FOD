PROGRAM ejer;
CONST
  PATH_BASE = '/Users/facundowertmuller/Desktop/FOD/practica3/ejercicio2/';
TYPE asistencia = record
			nro_asistente:integer;
			apellido, email, nombre:string[30];
			dni: longint;
		end;
		
		archivo = file of asistencia;
		
PROCEDURE imprimirMaestro(VAR maestro: archivo);
VAR
  reg: asistencia;
BEGIN
  reset(maestro);
  writeln('----- LISTADO DE ASISTENTES -----');
  while (not eof(maestro)) do begin
    read(maestro, reg);
    if ((reg.nombre[1] <> '@') ) then  // no mostrar los eliminados lógicos
      writeln('NRO: ', reg.nro_asistente, ' - Nombre: ', reg.nombre,
              ' - Apellido: ', reg.apellido, ' - DNI: ', reg.dni,
              ' - Email: ', reg.email);
  end;
  close(maestro);
END;
		
PROCEDURE leerAsistencia(var a:asistencia);
BEGIN
	writeln('Ingrese el nombre: '); readln(a.nombre);
	if(a.nombre <> 'fin')then begin
		writeln('Ingrese el numero de asistente'); readln(a.nro_asistente);
		a.apellido:= 'ZZZZZZ';
		a.email:= 'zzzz@gmail.com';
		a.dni:= 46111804;
	end;
END;

PROCEDURE eliminarLogicamente(VAR maestro:archivo);
VAR
	reg:asistencia;
BEGIN
	reset(maestro);
	while(not eof(maestro))do begin
		read(maestro, reg);
		if(reg.nro_asistente < 1000)then begin
			reg.nombre := '@' + reg.nombre;
			seek(maestro, filepos(maestro)-1);
			write(maestro, reg);
		end;
	end;
	close(maestro);
END;
VAR
	maestro: archivo;
	reg:asistencia;

BEGIN
	assign(maestro, PATH_BASE + 'asistencias');
	reset(maestro);
	rewrite(maestro);
	leerAsistencia(reg);
	while(reg.nombre <> 'fin')do begin
		write(maestro, reg);
		leerAsistencia(reg);
	end;
	close(maestro);
	imprimirMaestro(maestro);
	
	eliminarLogicamente(maestro);
	imprimirMaestro(maestro);
END.

			
