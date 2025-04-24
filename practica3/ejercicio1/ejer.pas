PROGRAM menuEmpleados;
CONST
  PATH_BASE = '/Users/facundowertmuller/Desktop/FOD/practica3/ejercicio1/';
TYPE
  empleado = record
    nroEmpleado: integer;
    apellido: string[25];
    nombre: string[25];
    edad: integer;
    DNI: string;
  end;

  empleados_file = file of empleado;

VAR
  empleados: empleados_file;
  e: empleado;
  nombreArchivo, rutaArchivo: string;
  opcion: integer;

PROCEDURE crearArchivo;
BEGIN
  writeln('Ingrese el nombre del archivo a crear:');
  readln(nombreArchivo);
  rutaArchivo := PATH_BASE + nombreArchivo;
  assign(empleados, rutaArchivo);
  rewrite(empleados);

  writeln('INGRESE EL APELLIDO');
  readln(e.apellido);
  while (e.apellido <> 'fin') do begin
    writeln('INGRESE EL NOMBRE');
    readln(e.nombre);
    writeln('INGRESE EL NRO DE EMPLEADO');
    readln(e.nroEmpleado);
    writeln('INGRESE LA EDAD');
    readln(e.edad);
    writeln('INGRESE EL DNI (00 si no tiene)');
    readln(e.DNI);
    write(empleados, e);
    writeln('INGRESE EL APELLIDO');
    readln(e.apellido);
  end;
  close(empleados);
END;

PROCEDURE buscarPorNombreApellido;
VAR
  busqueda: string;
BEGIN
  writeln('Ingrese nombre o apellido a buscar:');
  readln(busqueda);
  assign(empleados, rutaArchivo);
  reset(empleados);
  while (not eof(empleados)) do begin
    read(empleados, e);
    if (e.apellido = busqueda) or (e.nombre = busqueda) then
      writeln(e.nroEmpleado, ' ', e.apellido, ' ', e.nombre, ' ', e.edad, ' ', e.DNI);
  end;
  close(empleados);
END;

PROCEDURE listarEmpleados;
BEGIN
  assign(empleados, rutaArchivo);
  reset(empleados);
  while (not eof(empleados)) do begin
    read(empleados, e);
    writeln(e.nroEmpleado, ' ', e.apellido, ' ', e.nombre, ' ', e.edad, ' ', e.DNI);
  end;
  close(empleados);
END;

PROCEDURE listarJubilacion;
BEGIN
  assign(empleados, rutaArchivo);
  reset(empleados);
  while (not eof(empleados)) do begin
    read(empleados, e);
    if (e.edad > 70) then
      writeln('A jubilarse: ', e.nroEmpleado, ' ', e.apellido, ' ', e.nombre, ' ', e.edad);
  end;
  close(empleados);
END;

PROCEDURE agregarEmpleados;
VAR
  nuevo: empleado;
  existe: boolean;
BEGIN
  assign(empleados, rutaArchivo);
  reset(empleados);
  writeln('Ingrese el nroEmpleado:');
  readln(nuevo.nroEmpleado);
  existe := false;
  while (not eof(empleados)) do begin
    read(empleados, e);
    if (e.nroEmpleado = nuevo.nroEmpleado) then
      existe := true;
  end;
  if existe then
    writeln('Empleado ya registrado.')
  else begin
    writeln('Ingrese apellido, nombre, edad y DNI:');
    readln(nuevo.apellido);
    readln(nuevo.nombre);
    readln(nuevo.edad);
    readln(nuevo.DNI);
    seek(empleados, filesize(empleados));
    write(empleados, nuevo);
  end;
  close(empleados);
END;

PROCEDURE modificarEdad;
VAR
  nro, nuevaEdad: integer;
BEGIN
  writeln('Ingrese número de empleado a modificar:');
  readln(nro);
  writeln('Ingrese nueva edad:');
  readln(nuevaEdad);
  assign(empleados, rutaArchivo);
  reset(empleados);
  while (not eof(empleados)) do begin
    read(empleados, e);
    if (e.nroEmpleado = nro) then begin
      e.edad := nuevaEdad;
      seek(empleados, filepos(empleados) - 1);
      write(empleados, e);
    end;
  end;
  close(empleados);
END;

PROCEDURE exportarTodos;
VAR
  txt: text;
BEGIN
  assign(empleados, rutaArchivo);
  assign(txt, PATH_BASE + 'todos_empleados.txt');
  reset(empleados);
  rewrite(txt);
  while (not eof(empleados)) do begin
    read(empleados, e);
    writeln(txt, e.nroEmpleado, ' ', e.apellido, ' ', e.nombre, ' ', e.edad, ' ', e.DNI);
  end;
  close(empleados);
  close(txt);
END;

PROCEDURE exportarFaltaDNI;
VAR
  txt: text;
BEGIN
  assign(empleados, rutaArchivo);
  assign(txt, PATH_BASE + 'faltaDNIEmpleado.txt');
  reset(empleados);
  rewrite(txt);
  while (not eof(empleados)) do begin
    read(empleados, e);
    if (e.DNI = '00') then
      writeln(txt, e.nroEmpleado, ' ', e.apellido, ' ', e.nombre, ' ', e.edad, ' ', e.DNI);
  end;
  close(empleados);
  close(txt);
END;

PROCEDURE eliminarEmpleado;
VAR
	aux,reg: empleado;
	pos:integer;
	nombre,ape:string[25];
	borrado:boolean;
BEGIN
	writeln('Ingrese el nombre y apellido a eliminar'); readln(nombre); readln(ape);
	assign(empleados, rutaArchivo);
	reset(empleados);
	borrado:=false;
	while((not eof(empleados)) and( not borrado))do begin
		read(empleados, reg);
		if((reg.nombre = nombre)and (reg.apellido = ape))then begin
			pos:= filepos(empleados) - 1;
			//leo el ultimo registro
			seek(empleados, filesize(empleados) - 1);
			read(empleados, aux);
			
			//sobrescribo la pos necesaria
			
			seek(empleados, pos);
			write(empleados, aux);
			//trunco los empleados para borrar el deseado
			seek(empleados, filesize(empleados)-1);
			truncate(empleados);
			borrado:=true;
		end;
	end;
END;

BEGIN
  writeln('Ingrese el nombre del archivo a utilizar (sin path):');
  readln(nombreArchivo);
  rutaArchivo := PATH_BASE + nombreArchivo;

  repeat
    writeln('----- MENU -----');
    writeln('1. Crear archivo');
    writeln('2. Buscar por nombre o apellido');
    writeln('3. Listar todos los empleados');
    writeln('4. Listar empleados próximos a jubilarse (>70 años)');
    writeln('5. Agregar empleados (control de unicidad)');
    writeln('6. Modificar edad de un empleado');
    writeln('7. Exportar todos a "todos_empleados.txt"');
    writeln('8. Exportar sin DNI a "faltaDNIEmpleado.txt"');
    writeln('9. Eliminar Empleado por Nombre y Apellido"');
    writeln('0. Salir');
    readln(opcion);
    case opcion of
      1: crearArchivo;
      2: buscarPorNombreApellido;
      3: listarEmpleados;
      4: listarJubilacion;
      5: agregarEmpleados;
      6: modificarEdad;
      7: exportarTodos;
      8: exportarFaltaDNI;
      9: eliminarEmpleado;
    end;
  until opcion = 0;
END.
