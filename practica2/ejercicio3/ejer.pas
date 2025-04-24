PROGRAM ejer3;
CONST 
	PATH_BASE= '/Users/facundowertmuller/Desktop/FOD/practica2/ejercicio3/';
	valoralto='ZZZZ';
TYPE    
    provinciaMaestro = record
        nombre: string[25];
        cant_alfabetizadas: longint;
        total_encuestados: longint;
    end;

    provinciaDetalle = record  
        base: provinciaMaestro;
        cod_localidad:integer;
    end;

    archivoMaestro = file of provinciaMaestro;
    archivoDetalle = file of provinciaDetalle;


procedure imprimirMaestro;
var
  mae: archivoMaestro;
  p: provinciaMaestro;
begin
  assign(mae, PATH_BASE + 'maestro');
  reset(mae);
  writeln('----- CONTENIDO DEL ARCHIVO MAESTRO -----');
  while not eof(mae) do begin
    read(mae, p);
    writeln('Provincia: ', p.nombre);
    writeln('Alfabetizados: ', p.cant_alfabetizadas);
    writeln('Encuestados: ', p.total_encuestados);
    writeln('-----------------------------------------');
  end;
  close(mae);
end;


PROCEDURE leer(var detalle: archivoDetalle; var dato: provinciaDetalle);
BEGIN
    if(not eof(detalle))then
        read(detalle, dato)
    else
        dato.base.nombre := valoralto;
END;

PROCEDURE minimo(var reg1, reg2: provinciaDetalle; var min: provinciaDetalle;
                 var det1, det2: archivoDetalle);
BEGIN
  if (reg1.base.nombre <= reg2.base.nombre) then begin
    min := reg1;
    leer(det1, reg1);
  end 
  else begin
    min := reg2;
    leer(det2, reg2);
  end;
END;

VAR
    mae: archivoMaestro;
    det1,det2: archivoDetalle;
    regm: provinciaMaestro;
    regd1, min,regd2: provinciaDetalle;
BEGIN
	imprimirMaestro;
    assign(mae, PATH_BASE + 'maestro');
    assign(det1, PATH_BASE + 'detalle1');
    assign(det2, PATH_BASE + 'detalle2');
    reset(mae);
    reset(det1);
    reset(det2);

    leer(det1,regd1);
    leer(det2,regd2);
    minimo(regd1,regd2,min,det1,det2);
    while(min.base.nombre <> valoralto)do begin
        // Avanzar maestro hasta encontrar la provincia
        read(mae, regm);
        while (regm.nombre <> min.base.nombre) do
            read(mae, regm);

        // Sumar todos los registros de esa provincia
        while (min.base.nombre = regm.nombre) do begin
            regm.cant_alfabetizadas := regm.cant_alfabetizadas + min.base.cant_alfabetizadas;
            regm.total_encuestados := regm.total_encuestados + min.base.total_encuestados;
            minimo(regd1, regd2, min, det1, det2);
        end;

        seek(mae, filepos(mae) - 1);
        write(mae, regm);

    end;

	close(mae);
	close(det1);
	close(det2);
	writeln;	
	imprimirMaestro;

END.
