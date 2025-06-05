PROGRAM parcial1;
CONST
	  PATH_BASE = '/Users/facundowertmuller/Desktop/FOD/parciales/p1/';
	valoralto = 9999;
	DF=10;
TYPE
	base = record
		codigo:integer;
		casos:integer;
	end;
	regMaestro = record
		b:base;
		nombre_municipio:string[30];
	end;
	

	archivo = file of regMaestro; // --> ordenado por codigo
	
	detalle = file of base; // ---> ordenado por codigo
	vDetallesArchivo = array[1..DF] of detalle;
	vDetallesReg = array[1..DF] of base;
	
PROCEDURE leer (var archivo:detalle; var dato:base);
BEGIN
	if (not eof( archivo ))then 
		read (archivo, dato)
  else 
	  dato.codigo := valoralto;
END;

PROCEDURE 	minimo(var registrosDetalle: vDetallesReg; var min: base; var archivosDetalle: vDetallesArchivo);
VAR
	i,indice:integer;
BEGIN
	min.codigo := valoralto;
	for i:= 1 to DF do begin
		if(registrosDetalle[i].codigo <= min.codigo)then begin
			indice:= i;
			min:= registrosDetalle[i];
		end;
	end;
	if(min.codigo <> valoralto)then
		leer(archivosDetalle[indice], registrosDetalle[indice]);
END;


VAR
	vReg: vDetallesReg;
	vArch: vDetallesArchivo;
	maestro: archivo;
	regm:regMaestro;
	min:base;
	i:integer;
	acc:integer;
	a: string;
BEGIN
	assign(maestro, PATH_BASE + 'maestro.dat');
	reset(maestro);
	for  i:= 1 to 10 do begin
		str(i,a);

		assign(vArch[i], PATH_BASE + 'p1detalle' + a + '.dat');
		reset(vArch[i]);
		leer(vArch[i], vReg[i]);
	end;
	
	minimo(vReg, min, vArch);
	while(min.codigo <> valoralto) do begin
		acc:=0;
		read(maestro, regm);
		while((not eof(maestro))and(regm.b.codigo <> min.codigo)) do
			read(maestro, regm);
		
		while( regm.b.codigo = min.codigo)do begin
			regm.b.casos := regm.b.casos  +  min.casos;
			acc:= acc+ min.casos;
			minimo(vReg, min, vArch);
		end;
		
		if(acc > 15)then begin
			writeln('El municipio: ',regm.nombre_municipio,'  CANTIDAD DE CASOS: ', regm.b.casos);
			
		end;

		seek(maestro, filepos(maestro) -1);
		write(maestro, regm);
	end;
	
	for i:= 1 to DF do
		close(vArch[i]);
	close(maestro);
END.
