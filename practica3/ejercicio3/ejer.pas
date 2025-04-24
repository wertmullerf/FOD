PROGRAM ejer;
CONST
  PATH_BASE = '/Users/facundowertmuller/Desktop/FOD/practica3/ejercicio3/';
TYPE novela = record
			codigo:integer;
			genero,nombre,director:string[25];
			duracion,precio:real;
		end;
		
		archivo = file of novela;
	
VAR
	opcion:integer;
	rutaArchivo:string;
	nombreArchivo:string;
PROCEDURE leerNovela(var n:novela);
BEGIN
	writeln('Ingrese el codigo de novela');
	readln(n.codigo);
	if(n.codigo <> -1) then begin
		writeln('Ingrese el nombre: ');
		readln(n.nombre);
		n.genero:='ZZZZ';
		n.director := 'ZZZZZ';
		n.duracion := 60 + random(60); // 60 a 119 minutos
		n.precio := 10000 + random(10000); //10.000 a 19.999;
	end;
END;	
	
PROCEDURE cargarArchivo(var arch:archivo);
VAR
	n:novela;
BEGIN
	rewrite(arch);
	n.codigo:= 0;
	write(arch, n);
	leerNovela(n);
	while(n.codigo <> -1) do begin
		write(arch, n);
		leerNovela(n);
	end;
END;

PROCEDURE altaNovela(var arch:archivo);
VAR
	cabecera, nuevo, libre: novela;
	x: integer;
BEGIN	
	reset(arch);
	read(arch, cabecera);
	leerNovela(nuevo);
	x:= cabecera.codigo;
	if(x <> 0)then begin
		seek(arch, x * (-1)); // Voy a la posición libre
		read(arch, libre); // Leo lo que había en esa posición
		seek(arch, filepos(arch) - 1);
		write(arch,nuevo);
		// Actualizo cabecera con el "siguiente" de la lista libre
		seek(arch, 0);
		cabecera.codigo := libre.codigo;
		write(arch, cabecera);
	end
	else begin
		seek(arch, filesize(arch));  // No hay espacio libre, agrego al final
		write(arch, nuevo);
	end;
	
	close(arch);
END;

PROCEDURE modificarDatosNovela(var arch: archivo);
VAR
	n,reg:novela;
	codigo: integer;
	encontrado:boolean;
BEGIN
	reset(arch);
	writeln('Ingrese el codigo de la novela a modificar'); readln(codigo);
	encontrado:= false;
	seek(arch, 1); //no proceso la cabecera
	while((not eof(arch)) and (not encontrado))do begin
		read(arch, reg);
		if(reg.codigo = codigo)then begin
			writeln('Ingrese el nuevo nombre: '); readln(n.nombre);
			n.codigo:= reg.codigo; // --> Mantengo el mismo codigo
			writeln('Ingrese el nuevo genero: '); readln(n.genero);
			writeln('Ingrese el nuevo director: '); readln(n.director);
			writeln('Ingrese la nueva duracion: '); readln(n.duracion);
			writeln('Ingrese el nuevo precio: '); readln(n.precio);
			
			seek(arch, filepos(arch) - 1);
			write(arch, n);
			encontrado:=true;
		end;
	end;
	
	if(not encontrado)then
		writeln('El codigo de novela no existe');
	
	close(arch);
END;


PROCEDURE baja(var arch:archivo);
VAR
	x,y:integer; // --> NNR 
	reg,cabecera:novela;
	encontrado:boolean;
	codigo:integer;
BEGIN
	writeln('Ingrese el codigo a buscar');
	readln(codigo);
	reset(arch);
	read(arch, cabecera);
	
	x:= cabecera.codigo;
	encontrado:= false;
	while((not eof(arch)) and (not encontrado))do begin
		read(arch, reg);
		
		// Si existe (ojo: no usar valoralto, sino comparar por el código real)
		IF (reg.codigo = codigo) THEN BEGIN
			encontrado := true;
			y:= filepos(arch) - 1;
			 // Retrocedo
			seek(arch, y);
			// Escribo lo que habia en cabecera en esta posición (la novela eliminada va a contener el "siguiente libre")
			reg.codigo := x;
			write(arch, reg);

			// Voy a cabecera (posición 0)
			seek(arch, 0);
			// Escribo y * (-1) en cabecera.codigo (o sea, agrego y a la lista libre)
			cabecera.codigo := y * (-1);
			write(arch, cabecera);
		END;
	end;
	IF(NOT encontrado) THEN
		writeln('No se encontró la novela con código ', codigo);
    
   close(arch);
END;


PROCEDURE exportarNovelas(var arch: archivo);
VAR
	txt:text;
	reg:novela;
	i:integer;
	
BEGIN
	reset(arch);
	assign(txt, PATH_BASE + 'novelas.txt');
	rewrite(txt);
	writeln(txt, 'LISTADO COMPLETO DE NOVELAS (INCLUYE BORRADAS)');
	writeln(txt, '---------------------------------------------');
	
	i:= 0;
	while not eof(arch) do begin
		read(arch, reg);
		write(txt, 'Registro ', i, ' | Código: ', reg.codigo);
		if i = 0 then
			writeln(txt, ' (Cabecera)')
		else if reg.codigo <= 0 then
			writeln(txt, ' (BORRADO)')
		else
			writeln(txt, ' | Nombre: ', reg.nombre, ' | Director: ', reg.director);
		i := i + 1;
	end;
	
	close(arch);
	close(txt);
END;
VAR 	
	arch: archivo;
BEGIN
	writeln('Ingrese el nombre del archivo'); readln(nombreArchivo);
	assign(arch, PATH_BASE + nombreArchivo);
	repeat
		writeln('----- MENU -----');
		writeln('1. Crear archivo');
		writeln('2. Dar de Alta una Novela');
		writeln('3. Modificar Datos de Una Novela');
		writeln('4. Eliminar Novela por Codigo');
		writeln('5. Exportar Novelas .txt' );
		writeln('0. Salir');
		readln(opcion);
    case opcion of
		1: cargarArchivo(arch);
		2: altaNovela(arch);
		3: modificarDatosNovela(arch);
		4: baja(arch);
		5: exportarNovelas(arch);
    end;
    until opcion = 0;
END.
