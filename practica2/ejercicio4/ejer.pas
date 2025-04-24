PROGRAM ejer4;
CONST
  PATH_BASE = '/Users/facundowertmuller/Desktop/FOD/practica2/ejercicio4/';
  valoralto = 9999;
TYPE
	RANGO_DETALLE = 1..30;
	producto = record
		codigo:integer;
		nombre,descripcion:string;
		stock_disponible, stock_minimo: integer;
		precio: real;
	end;
	
	productoDetalle = record
		codigo:integer;
		cantidad_vendida: integer;
	end;
	
	archivoMaestro = file of producto;
	archivoDetalle = file of productoDetalle;
	vRegistrosDetalle = array[RANGO_DETALLE] of productoDetalle;
	vArchivosDetalle = array[RANGO_DETALLE] of archivoDetalle;
	
//==========================================================================================

PROCEDURE leer(var detalle: archivoDetalle; var dato: productoDetalle);
BEGIN
	if(not EOF(detalle))then
		read(detalle, dato)
	else
		dato.codigo := valoralto;
END;


procedure imprimirMaestro;
var
  mae: archivoMaestro;
  p: producto;
begin
  assign(mae, PATH_BASE + 'maestro');
  reset(mae);
  writeln('----- CONTENIDO DEL ARCHIVO MAESTRO -----');
  while not eof(mae) do begin
    read(mae, p);
    writeln('Codigo: ', p.codigo);
    writeln('Stock Disponible: ', p.stock_disponible);
    writeln('Stock Minim: ', p.stock_minimo);
    writeln('-----------------------------------------');
  end;
  close(mae);
end;

//===========================================================================================
{
PROCEDURE crearDetalles;
VAR
	i:RANGO_DETALLE;
BEGIN
END;

}
{
PROCEDURE leerProducto(var p: productoDetalle);
BEGIN
	p.codigo:= 1;
	//if(p.codigo<> 0) then
	p.cantidad_vendida:= random(10) + 1; // 1 a 10
END;
}
PROCEDURE cargarArchivosDetalle ( var v:vArchivosDetalle);
VAR
    i:RANGO_DETALLE;
    a:string;
    p:productoDetalle;
BEGIN
    for i:= 1 to 30 do begin  
        Str (i,a);
        assign (v[i], PATH_BASE+ 'detalle'+ a);
        rewrite (v[i]);
        //leerProducto(p);
        p.codigo:= i;
		p.cantidad_vendida:= random(10) + 1; // 1 a 10

        //while (p.codigo<>0) do begin   
        write (v[i],p);
            //leerProducto(p);
        close (v[i]);
    end;
END;


PROCEDURE cargarMaestro;
VAR	
  mae: archivoMaestro;
  p: producto;
  i:RANGO_DETALLE;
begin
	assign(mae, PATH_BASE + 'maestro');
	rewrite(mae);
	for i:= 1 to 30 do begin
		p.codigo:= i; 
		p.nombre:= 'TEST'; 
		p.descripcion:= 'TEST DESCRIPCION';
		p.stock_disponible := 10 + random(100);
		p.stock_minimo:=  1 + random(50);
		p.precio:= 1000 + random(4000);
		write(mae, p);
	end;
	close(mae);
END;
//==========================================================================================

PROCEDURE 	minimo(var registrosDetalle: vRegistrosDetalle; var min: productoDetalle; var archivosDetalle: vArchivosDetalle);
VAR
	i,indice:RANGO_DETALLE;
BEGIN
	min.codigo := valoralto;
	for i:= 1 to 30 do begin
		if(registrosDetalle[i].codigo <= min.codigo)then begin
			indice:= i;
			min:= registrosDetalle[i];
		end;
	end;
	if(min.codigo <> valoralto)then
		leer(archivosDetalle[indice], registrosDetalle[indice]);
END;


PROCEDURE bajoEnStock(var maestro:archivoMaestro);
VAR
	texto: text;
	p:producto;
BEGIN
	assign(texto, PATH_BASE + 'bajoStock.txt');
	rewrite(texto);
	reset(maestro);
	while(not eof(maestro)) do begin
		read(maestro, p);
		if(p.stock_disponible < p.stock_minimo)then
			writeln(texto, p.codigo, ' ', p.nombre,  ' ', p.precio:0:2, ' ', p.stock_minimo ,' ' ,p.stock_disponible);
	end;
	close(texto);
	close(maestro);
END;

//==========================================================================================
VAR
	maestro: archivoMaestro;
	registrosDetalle: vRegistrosDetalle;
	archivosDetalle: vArchivosDetalle;
	regm: producto;
	min: productoDetalle;
	i: RANGO_DETALLE;
	a:string;
BEGIN
	cargarMaestro;
	cargarArchivosDetalle(archivosDetalle);
	assign(maestro, PATH_BASE + 'maestro');
	reset(maestro);
	//asignacion de archivos y leo los archivos detalle
	for i:= 1 to 30 do begin
		//Str(i,a);

		//assign(archivosDetalle[i], PATH_BASE + 'detalle' + a); //buscar como pasar i a toString;
		reset(archivosDetalle[i]);
		leer(archivosDetalle[i], registrosDetalle[i]);
	end;

	//calculo el minimo
	minimo(registrosDetalle,min, archivosDetalle);
	while(min.codigo <> valoralto)do begin
		
		read(maestro, regm);
		while (regm.codigo <> min.codigo) do
            read(maestro, regm);
         
		while(regm.codigo = min.codigo)do begin
			regm.stock_disponible := regm.stock_disponible  - min.cantidad_vendida;
			minimo(registrosDetalle,min, archivosDetalle);
		end;
		
		seek(maestro, filepos(maestro) -1);
		write(maestro, regm);
	end;
	
	for i:= 1 to 30 do
		close(archivosDetalle[i]);
	close(maestro);
	imprimirMaestro;
	
	bajoEnStock(maestro);
	
END.
