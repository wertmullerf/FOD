PROGRAM ejer2;
CONST 
	NOMBRE_MAESTRO = 'productos';
	NOMBRE_DETALLE = 'ventas';
	PATH_BASE= '/Users/facundowertmuller/Desktop/FOD/practica2/';
	valoralto=9999;
TYPE
	producto = record
		codigo_producto: integer;
		nombre:string[25];
		precio:real;
		stock_actual, stock_minimo:integer;
	end;
	
	productoDetalle = record
		codigo_producto:integer;
		cantidad_vendida:integer;
	end;
	
	archivoMaestro= file of producto;
	archivoDetalle= file of productoDetalle;
	
	
//-------------------------------
PROCEDURE imprimirMaestro;
VAR
  arch: file of producto;
  p: producto;
BEGIN
  assign(arch, PATH_BASE + NOMBRE_MAESTRO);
  reset(arch);
  writeln('---- CONTENIDO DEL ARCHIVO MAESTRO ----');
  while not eof(arch) do begin
    read(arch, p);
    writeln('Código: ', p.codigo_producto);
    writeln('Nombre: ', p.nombre);
    writeln('Precio: $', p.precio:0:2);
    writeln('Stock actual: ', p.stock_actual);
    writeln('Stock mínimo: ', p.stock_minimo);
    writeln('---------------------------------------');
  end;
  close(arch);
END;


PROCEDURE crearMaestro;
VAR
  arch: file of producto;
  p: producto;
BEGIN
  assign(arch, PATH_BASE + NOMBRE_MAESTRO);
  rewrite(arch);

  p.codigo_producto := 1; p.nombre := 'Lavandina'; p.precio := 120; p.stock_actual := 50; p.stock_minimo := 10; write(arch, p);
  p.codigo_producto := 2; p.nombre := 'Detergente'; p.precio := 150; p.stock_actual := 30; p.stock_minimo := 15; write(arch, p);
  p.codigo_producto := 3; p.nombre := 'Jabon en polvo'; p.precio := 250; p.stock_actual := 40; p.stock_minimo := 20; write(arch, p);
  p.codigo_producto := 4; p.nombre := 'Desinfectante'; p.precio := 200; p.stock_actual := 25; p.stock_minimo := 20; write(arch, p);
  p.codigo_producto := 5; p.nombre := 'Alcohol'; p.precio := 180; p.stock_actual := 60; p.stock_minimo := 30; write(arch, p);

  close(arch);
END;

PROCEDURE crearDetalle;
VAR
  arch: file of productoDetalle;
  d: productoDetalle;
BEGIN
  assign(arch, PATH_BASE + NOMBRE_DETALLE);
  rewrite(arch);

  d.codigo_producto := 1; d.cantidad_vendida := 5; write(arch, d);
  d.codigo_producto := 2; d.cantidad_vendida := 10; write(arch, d);
  d.codigo_producto := 2; d.cantidad_vendida := 3; write(arch, d);
  d.codigo_producto := 4; d.cantidad_vendida := 8; write(arch, d);
  d.codigo_producto := 5; d.cantidad_vendida := 35; write(arch, d);

  close(arch);
END;


//-------------------------------
//-------------------------------
PROCEDURE leer (var detalle:archivoDetalle ;var dato:productoDetalle);
BEGIN
    if (not eof(detalle))
        then read (detalle,dato)
    else 
        dato.codigo_producto := valoralto;
END;
//-------------------------------
PROCEDURE recortarStock(var arch_maestro: archivoMaestro);
VAR
	arch_detalle: archivoDetalle;
	regM: producto;
	regD: productoDetalle;
	total,aux:integer;
BEGIN
	assign(arch_maestro, PATH_BASE + NOMBRE_MAESTRO);
	assign(arch_detalle, PATH_BASE + NOMBRE_DETALLE);
	reset(arch_maestro);
	reset(arch_detalle);
	read(arch_maestro,regM);
	leer(arch_detalle, regD);
	while(regD.codigo_producto <> valoralto) do begin
		aux:= regD.codigo_producto;
		total:= 0;
		while(regD.codigo_producto = aux) do begin
			total := total + regD.cantidad_vendida;
			leer(arch_detalle, regD);
		end;
		
		while(regM.codigo_producto <> aux) do
			read(arch_maestro, regM);
		
		regM.stock_actual := regM.stock_actual - total;
		seek(arch_maestro, filepos(arch_maestro) - 1);
		write(arch_maestro, regM);
		if(not EOF(arch_maestro))then 
			read(arch_maestro, regM);
		
	end;
	close(arch_maestro);
	close(arch_detalle);
	
END;

//-------------------------------

PROCEDURE exportarTexto(var arch_maestro:archivoMaestro);
VAR
	texto: text;
	p:producto;
BEGIN
	assign(arch_maestro, PATH_BASE + NOMBRE_MAESTRO);
	assign(texto, PATH_BASE + 'stock_minimo.txt');
	reset(arch_maestro);
	rewrite(texto);
	
	while(not eof(arch_maestro))do begin
		read(arch_maestro, p);
		if(p.stock_actual < p.stock_minimo)then
			writeln(texto, p.codigo_producto, ' ', p.nombre,  ' ', p.precio:0:2, ' ', p.stock_minimo ,' ' ,p.stock_actual);
	end;
	close(arch_maestro);
	close(texto);
	writeln('Archivo stock_minimo.txt generado con exito');
END;
//-------------------------------
VAR
	arch_maestro: archivoMaestro;
BEGIN
	
	imprimirMaestro;

	//recortarStock(arch_maestro);
	exportarTexto(arch_maestro);
	
	
END.
