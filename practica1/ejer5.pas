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
	end
else
		writeln('Error: primero debe crear el archivo binario.');
END;

// --------------------------------------------------------
VAR
	archivo_binario: archivo_celulares;
	archivo_texto: text;
	opc:integer;
BEGIN
  mostrarMenu();
  readln(opc);
  while(opc<>0) do begin
    case opc of
      1: crearArchivoBinario(archivo_binario, archivo_texto);
      2: listarPorStock(archivo_binario);
      3: listarPorDescripcion(archivo_binario);
	  4: exportarBinarioTexto(archivo_binario, archivo_texto);
      0: writeln('Programa finalizado.');
		
    else
      writeln('Opción inválida, intente nuevamente.');
    end;
    mostrarMenu();
    readln(opc);
  end;
END.


{
MOCK:
1001 45999.99 Samsung
20 5 Pantalla HD de 6.5", batería de larga duración
Galaxy A13
1002 99999.99 Apple
5 2 Procesador A15 Bionic, cámara dual 12 MP
iPhone 13
1003 68999.00 Motorola
10 4 Diseño compacto, pantalla OLED de 6.4"
Moto G72
1004 34999.50 Xiaomi
30 10 Celular económico, buena relación calidad-precio
Redmi 9A
1005 79999.99 Google
8 3 Android puro, excelente cámara nocturna
Pixel 6a

}
