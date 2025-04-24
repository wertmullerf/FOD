PROGRAM ejer5;
CONST
	valoralto = 9999;
TYPE
	fechaReg = record
		dia:integer;
		mes:1..12;
		anio:integer;
	end;
	RANGO_DETALLES = 1..5;
	log = record
		cod_usuario:integer;
		fecha: fechaReg;
		tiempo_sesion:real;
	end;
	
	archivo= file of log;
	
	vRegDetalles= array[RANGO_DETALLES] of log;
	vDetalles = array[RANGO_DETALLES] of archivo;
	
VAR
	maestro: archivo;
	detalles: vDetalles;
	registros: vRegDetalles;
	min: log;
	
	
PROCEDURE leer(var detalle: archivo; var dato: log);
BEGIN
	if(not eof(detalle))then
		read(detalle, dato)
	else
		dato.cod_usuario:= valoralto
END;

PROCEDURE 	minimo(var registrosDetalle: vRegDetalles; var min: log; var archivosDetalle: vDetalles);
VAR
	i,indice:RANGO_DETALLES;
BEGIN
	min.codigo := valoralto;
	for i:= 1 to 30 do begin
		if(registrosDetalle[i].cod_usuario <= min.cod_usuario)then begin
			indice:= i;
			min:= registrosDetalle[i];
		end;
	end;
	if(min.cod_usuario <> valoralto)then
		leer(archivosDetalle[indice], registrosDetalle[indice]);
END;

VAR
	aux:string;
	regm:log;
BEGIN
	assign(maestro, 'maestro');
	rewrite(maestro);
	for i:= 1 to 5 do begin
		Str(i,aux);
		assign(detalles[i], 'detalle' + aux);
		reset(detalles[i]);
		leer(detalles[i], registros[i]);
	end;
	
	minimo(registros, min, detalles);
	while(min.cod_usuairo <> valoralto)do begin
		regm.cod_usuario:=min.cod_usuario;
		regm.tiempo_sesion:=0;
		while(min.cod_usuario = regm.cod_usuario)do begin
			regm.tiempo_sesion:= regm.tiempo_sesion + min.tiempo_sesion;
			regm.fecha := min.fecha; //me guardo la ult fecha de cada usuario;
			minimo(registros, min, detalles);
		end;
		write(maestro, regm);
	end;
END.
