PROGRAM ejer7;
CONST 
	PATH_BASE= '/Users/facundowertmuller/Desktop/FOD/practica1/';
TYPE
	novela = record
		codigo:integer;
		nombre,genero:string;
		precio:real;
	end;
	
	binario=file of novela;
var
		nombreArchivo:string;
PROCEDURE mostrarMenu;
BEGIN
  writeln;
  writeln('--- MENÚ DE OPCIONES ---');
  writeln('0. Finalizar Programa');
  writeln('1. Crear Archivo Binario desde novelas.txt');
  writeln('2. Agregar Novela --> Binario');
  writeln('3. Modificar Novela Existente --> Binario');
  writeln;
  write('Ingrese una opción: ');
END;
	
	
	
PROCEDURE crearArchivoBinario(var arch_binario: binario; var arch_texto:text);
VAR
	n:novela;
BEGIN
	assign(arch_texto, PATH_BASE + 'novelas.txt');
	assign(arch_binario,  PATH_BASE + nombreArchivo);
	reset(arch_texto);
	rewrite(arch_binario);
	
	while(not eof(arch_texto))do begin
		readln(arch_texto, n.codigo, n.precio, n.genero);
		readln(arch_texto, n.nombre);
		write(arch_binario, n);
	end;
	writeln('Archivo Binario Creado Exitosamente');
	close(arch_texto); close(arch_binario);
END;

PROCEDURE leerNovela(var n:novela);
BEGIN
	writeln('--- Ingrese de nueva novela ---');
	write('Codigo: '); readln(n.codigo);
	if(n.codigo <> -1)then begin
		// Inicializar random (podés poner esto solo una vez en el programa principal)
		write('Nombre: '); readln(n.nombre);
		n.genero:= 'NNNNN';
		n.precio:= random(100000) / 1.0 + 10000;
	end;
END;

PROCEDURE agregarNovela(var arch_binario: binario);
VAR
	n:novela;
BEGIN
	assign(arch_binario,  PATH_BASE + nombreArchivo);
	reset(arch_binario);
	seek(arch_binario, fileSize(arch_binario));
	leerNovela(n);
	while(n.codigo<>-1) do begin
		write(arch_binario, n);
		leerNovela(n);
	end;
	close(arch_binario);
END;

PROCEDURE modificarNovela(var arch_binario: binario);
VAR
	n:novela;
	encontre:boolean;
	codigo:integer;
BEGIN
	assign(arch_binario,  PATH_BASE + nombreArchivo);
	reset(arch_binario);
	encontre:= false;
	
	writeln('Ingrese el Codigo a Modificar');readln(codigo);
	
	while((not eof(arch_binario)) and (not encontre))do begin
		read(arch_binario, n);
		if(n.codigo = codigo)then begin
			encontre:=true;
			leerNovela(n);
			seek(arch_binario, filePos(arch_binario)-1);
			write(arch_binario, n);
		end;
	end;
	close(arch_binario);
END;

//==============PROCESO PARA TESTEO====================

PROCEDURE imprimir(var arch:binario);
VAR
	n:novela;
BEGIN
	assign(arch, PATH_BASE + nombreArchivo);
	reset(arch);
	while(not eof(arch)) do begin
		read(arch,n);
		writeln('Nombre: ', n.nombre, ' CODIGO: ', n.codigo, ' PRECIO: $ ', n.precio:0:2);
	end;
	close(arch);
END;

//==============PROCESO PARA TESTEO====================
VAR
	archivo_binario: binario;
	archivo_texto: text;
	opc:integer;
BEGIN
	nombreArchivo := 'novelas_binario'; //HARDCODEADO PARA USO PROPIO
	mostrarMenu();
	readln(opc);
	while(opc<>0) do begin
		case opc of
		1: crearArchivoBinario(archivo_binario, archivo_texto);
		2: agregarNovela(archivo_binario);
		3: modificarNovela(archivo_binario);
		4:imprimir(archivo_binario);
		0: writeln('Programa finalizado.');
		else
			writeln('Opción inválida, intente nuevamente.');
		end;
		mostrarMenu();
		readln(opc);
	end;
END.
	
