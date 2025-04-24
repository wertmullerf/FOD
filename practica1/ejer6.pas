PROGRAM  programaStock;
CONST 
	PATH_BASE= '/Users/facundowertmuller/Desktop/FOD/practica1/';
TYPE
  celular = record
    codigo: integer;
    nombre: string;
    descripcion: string;
    marca: string;
    precio: real;
    stockMin: integer;
    stockDisponible: integer;
  end;

  archivo_celulares = file of celular;

{VARIABLES GLOBALES --> NOS SIRVE PARA SABER COMO LE PUSIMOS ALBINARIO}
VAR
  nombreArchivo: string;


PROCEDURE informarCelular(c:celular);
BEGIN
	writeln('Cod: ', c.codigo, ' | Nombre: ', c.nombre, ' | Marca: ', c.marca, 
			' | Precio: $', c.precio:0:2, ' | Stock: ', c.stockDisponible, '/', c.stockMin,
			' | Desc: ', c.descripcion);
END;
// --------------------------------------------------------
PROCEDURE mostrarMenu;
BEGIN
  writeln;
  writeln('--- MENÚ DE OPCIONES ---');
  writeln('0. Finalizar Programa');
  writeln('1. Crear Archivo Binario desde celulares.txt');
  writeln('2. Listar Celulares Que Cumplan Stock Menor (inciso b)');
  writeln('3. Buscar Celulares por Celular (inciso c)');
   writeln('4. Exportar Binario a Texto (inciso d)');
   writeln('5. Agregar Celulares Al FInal');
   writeln('6. Actualizar Stock Por Nombre');
   writeln('7. Exportar Sin Stock');
  writeln;
  write('Ingrese una opción: ');
END;

// --------------------------------------------------------
PROCEDURE crearArchivoBinario(var archivo_binario: archivo_celulares; var archivo_texto: text);
var
	c:celular;
BEGIN
  write('Ingrese el nombre del archivo binario a crear: ');
  readln(nombreArchivo);
  assign(archivo_binario,PATH_BASE + nombreArchivo);
  rewrite(archivo_binario);

  assign(archivo_texto, PATH_BASE + 'celulares.txt');
  reset(archivo_texto);

  while not eof(archivo_texto) do begin

	{
	En este punto leo como se solicita en la NOTA 2. Por lineas
	}
    readln(archivo_texto, c.codigo, c.precio, c.marca);
    readln(archivo_texto, c.stockDisponible, c.stockMin, c.descripcion);
    readln(archivo_texto, c.nombre);
    write(archivo_binario, c);
  end;

  close(archivo_binario);
  close(archivo_texto);
  writeln('Archivo binario "', nombreArchivo, '" creado con éxito.');
END;

// --------------------------------------------------------

PROCEDURE listarPorStock(var archivo_binario: archivo_celulares);
VAR
	c:celular;
BEGIN
  writeln('Entré a listarPorStock'); // 👈 esto es solo para debug
	assign(archivo_binario,PATH_BASE + nombreArchivo);
	reset(archivo_binario);
	writeln;
	writeln;
	writeln;
	writeln('Celulares Que Se Encuentran Debajo Del Stock Minimo');
	writeln('-------------------------------------------------------');
	while(not eof(archivo_binario))do begin
		read(archivo_binario, c);
		if(c.stockDisponible < c.stockMin) then
			informarCelular(c);
	end;
	close(archivo_binario);
END;

// --------------------------------------------------------

PROCEDURE exportarBinarioTexto(var archivo_binario:archivo_celulares; var archivo_texto: text);
VAR
	c:celular;
BEGIN
	assign(archivo_binario,PATH_BASE + nombreArchivo);
	assign(archivo_texto,PATH_BASE + 'celulares.txt');
	reset(archivo_binario);
	rewrite(archivo_texto);
	
	while(not eof(archivo_binario))do begin
		read(archivo_binario, c);
		//hay que formatear porque sino queda mal el archivo
		writeln(archivo_texto, c.codigo, ' ', c.precio:0:2, ' ', c.marca);
		writeln(archivo_texto, c.stockDisponible, ' ', c.stockMin, ' ', c.descripcion);
		writeln(archivo_texto, c.nombre);
	end;
	  writeln('Exportación a celulares_exportado.txt completada con éxito.');
	close(archivo_binario);
	close(archivo_texto);
END;

// --------------------------------------------------------

PROCEDURE listarPorDescripcion(var archivo_binario:archivo_celulares);
VAR
	cadena:string;
	c:celular;
BEGIN
	if (nombreArchivo <>  '') then begin
		write('Ingrese texto a buscar en la descripción: ');
		readln(cadena);
		assign(archivo_binario, PATH_BASE + nombreArchivo);
		reset(archivo_binario);
		writeln('Resultados de búsqueda para "', cadena, '"');
		writeln('--------------------------------------------------------');
		while(not eof(archivo_binario))do begin
			read(archivo_binario, c);
			if(pos(cadena, c.descripcion) > 0)then
				informarCelular(c);
		end;
		close(archivo_binario);
	end
else
		writeln('Error: primero debe crear el archivo binario.');
END;

// --------------------------------------------------------

PROCEDURE leerCelular(var c:celular);
BEGIN
	writeln('--- Ingreso de nuevo celular ---');
	write('Nombre: '); readln(c.nombre);
	if(c.nombre <> 'fin')then begin
		// Inicializar random (podés poner esto solo una vez en el programa principal)

		c.codigo := random(1000) + 1000; // código entre 1000 y 1999
		c.descripcion := 'Descripción generada';
		c.marca := 'MarcaX';
		c.precio := random(100000) / 1.0 + 10000; // precio entre 10k y 110k
		c.stockMin := random(10) + 1; // entre 1 y 10
		c.stockDisponible := random(30) + 1; // entre 1 y 30
		
	end;
END;


PROCEDURE agregarCelulares(var archivo_binario:archivo_celulares);
VAR
	c:celular;
BEGIN
	assign(archivo_binario, PATH_BASE + nombreArchivo);
	reset(archivo_binario);
	seek(archivo_binario, fileSize(archivo_binario));
	leerCelular(c);
	while(c.nombre <> 'fin')do begin
		write(archivo_binario, c);
		 leerCelular(c);
	end;
	close(archivo_binario);
END;


PROCEDURE modificarStock(var archivo_binario:archivo_celulares);
VAR
	celularNombre:string;
	c:celular;
	esta:boolean;
	stockMin, stockDisponible: integer;
BEGIN
	writeln('--- Ingrese Celular ---');
	write('Nombre: '); readln(celularNombre);
	writeln('Ingrese Stock Min y Disponible');
	write('Stock Min: '); readln(stockMin);
	write('Stock Disponible: '); readln(stockDisponible);

	assign(archivo_binario, PATH_BASE + nombreArchivo);
	reset(archivo_binario);
	
	esta:= false;
	while((not eof(archivo_binario)) and (not esta)) do begin
		read(archivo_binario, c);
		if(c.nombre = celularNombre)then begin
			esta:= true;
			c.stockMin := stockMin;
			c.stockDisponible := stockDisponible;
			seek(archivo_binario, filePos(archivo_binario)-1);
			write(archivo_binario,c);
		end;
	end;
	close(archivo_binario);

END;

// --------------------------------------------------------

PROCEDURE exportarBinarioTextoSinStock(var archivo_binario: archivo_celulares; var archivo_texto: text);
VAR 
	c:celular;
BEGIN
	assign(archivo_binario, PATH_BASE + nombreArchivo);
	assign(archivo_texto, PATH_BASE + 'sinStock.txt');
	reset(archivo_binario);
	rewrite(archivo_texto);
	while(not eof(archivo_binario))do begin
		read(archivo_binario, c);
		informarCelular(c);
		if(c.stockDisponible = 0)then begin
			writeln(archivo_texto, c.codigo, ' ', c.precio:0:2, ' ', c.marca);
			writeln(archivo_texto, c.stockDisponible, ' ', c.stockMin, ' ', c.descripcion);
			writeln(archivo_texto, c.nombre);
		end;
	end;
	close(archivo_binario);
	close(archivo_texto);
END;

// --------------------------------------------------------
VAR
	archivo_binario: archivo_celulares;
	archivo_texto: text;
	opc:integer;
BEGIN
	nombreArchivo := 'celulares_binario'; //HARDCODEADO PARA USO PROPIO
	mostrarMenu();
	readln(opc);
	while(opc<>0) do begin
		case opc of
		1: crearArchivoBinario(archivo_binario, archivo_texto);
		2: listarPorStock(archivo_binario);
		3: listarPorDescripcion(archivo_binario);
		4: exportarBinarioTexto(archivo_binario, archivo_texto);
		5: agregarCelulares(archivo_binario);
		6: modificarStock(archivo_binario);
		7: exportarBinarioTextoSinStock(archivo_binario, archivo_texto);
		0: writeln('Programa finalizado.');
		
		else
			writeln('Opción inválida, intente nuevamente.');
		end;
		mostrarMenu();
		readln(opc);
	end;
END.


