PROGRAM ejer;
CONST
  valoralto = 'ZZZZ'; // para cortar cuando terminan los archivos
  PATH_BASE = '/Users/facundowertmuller/Desktop/FOD/practica2/ejercicio14/';
TYPE 	vuelo = record
				destino,fecha,hora:string;
				cantidad:integer;
			end;
			
			archivo = file of vuelo;
			
			regLista = record
				destino,fecha,hora:string;
			end;
			
			lista = ^nodo;
			nodo= record
				dato:regLista;
				sig:lista;
			end;
			
			
PROCEDURE leer(var arch:archivo; var dato:vuelo);
BEGIN
	if(not eof(arch))then
		read(arch,dato)
	else
		dato.destino:=valoralto;
END;
			
			
PROCEDURE minimo(var reg1, reg2, min: vuelo; var det1, det2: archivo);
BEGIN
    if (reg1.destino < reg2.destino) or
       ((reg1.destino = reg2.destino) and (reg1.fecha < reg2.fecha)) or
       ((reg1.destino = reg2.destino) and (reg1.fecha = reg2.fecha) and (reg1.hora < reg2.hora)) then 
     begin
		min := reg1;
        leer(det1, reg1);
    end
    else begin
        min := reg2;
        leer(det2, reg2);
    end;
END;

VAR	
	maestro,detalle1,detalle2:archivo;
	regM,regD1,regD2,min:vuelo;
	destinoAct,fechaAct,horaAct:string;
	cantidad_comprados:integer;
	actualice: boolean;
BEGIN
	assign(maestro, PATH_BASE + 'maestro');reset(maestro);
	assign(detalle1, PATH_BASE + 'detall1'); reset(detalle1);
	assign(detalle2, PATH_BASE + 'detall2'); reset(detalle2);

	leer(detalle1, regD1);
	leer(detalle2, regD2);
	minimo(regD1,regD2,min,detalle1,detalle2);
	while(min.destino<>valoralto)do begin
		destinoAct:= min.destino;
		fechaAct:= min.fecha;
		horaAct:= min.hora;
		cantidad_comprados:= 0;
		while((min.destino = destinoAct) and(min.fecha = fechaAct) and (min.hora = horaAct))do begin
			cantidad_comprados :=cantidad_comprados + min.cantidad;
			minimo(regD1,regD2,min,detalle1,detalle2);
		end;
		actualice:=false;
		leer(maestro, regM);
		while((regM.destino <> valoralto)and(not actualice))do begin
			if (regM.destino = destinoAct) and  (regM.fecha = fechaAct) and (regM.hora = horaAct) then begin
				regM.cantidad := regM.cantidad - cantidad_comprados;
				seek(maestro, filepos(maestro)-1);
				write(maestro, regM);
				actualice:= true;
			end
			else
				leer(maestro, regM);
		end;
	end;
	close(maestro); close(detalle1); close(detalle2);
	
	reset(maestro);
	while (not eof(maestro))do begin
		read(maestro, regM);
		writeln('Destino: ', regM.destino, ' - Fecha: ', regM.fecha, ' - Hora: ', regM.hora, ' - Cantidad: ', regM.cantidad);
	end;
	
END.
