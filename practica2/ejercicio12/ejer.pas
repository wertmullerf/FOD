PROGRAM ejer;
CONST
	DF = 12;
	valoralto = 9999;
	PATH_BASE = '/Users/facundowertmuller/Desktop/FOD/practica2/ejercicio11/';
TYPE
	RANGO_DIAS = 1..31;
	RANGO_MESES = 1..12;

	acceso = record
		dia: RANGO_DIAS;
		mes: RANGO_MESES;
		anio, idUsuario: integer;
		tiempo: real;
	end;

	archivo = file of acceso;
	vContador = array[RANGO_MESES] of real;

PROCEDURE leer(var arch: archivo; var dato: acceso);
BEGIN
	if (not eof(arch)) then
		read(arch, dato)
	else
		dato.anio := valoralto;
END;

VAR
	maestro: archivo;
	anio: integer;
	mes: RANGO_MESES;
	dia: RANGO_DIAS;
	idUsuario: integer;
	acc_dia, acc_anio, acc_mes: real;
	dato: acceso;
	esta:boolean;
BEGIN
	assign(maestro, PATH_BASE + 'maestro');
	reset(maestro);
	writeln('Ingrese el anio que desee hacer el reporte');
	readln(anio);
	esta:=false;
	leer(maestro, dato);
	while (dato.anio <> valoralto) do begin
		while ((dato.anio <> anio) and (dato.anio <> valoralto)) do
			leer(maestro, dato);

		if (dato.anio = anio) then begin
			esta:= true;
			writeln('Año: ', anio);
			acc_anio := 0;
			while (dato.anio = anio) do begin
				mes := dato.mes;
				writeln('Mes: ', mes);
				acc_mes := 0;
				while ((dato.anio = anio) and (mes = dato.mes)) do begin
					dia := dato.dia;
					writeln('Dia: ', dia);
					acc_dia := 0;
					while ((dato.anio = anio) and (dato.mes = mes) and (dato.dia = dia)) do begin
						writeln(' idUsuario ', dato.idUsuario, '   Tiempo: ', dato.tiempo:0:2);
						acc_dia := acc_dia + dato.tiempo;
						leer(maestro, dato);
					end;
					writeln('    Tiempo total acceso día ', dia, ' mes ', mes, ': ', acc_dia:0:2);
					acc_mes := acc_mes + acc_dia;
				end;
				acc_anio := acc_anio + acc_mes;
				writeln('Total tiempo de acceso mes ', mes, ': ', acc_mes:0:2);
			end;
			writeln('Total tiempo de acceso año ', acc_anio:0:2);
		end ;
		if(not esta)then
			writeln('Anio no encontrado en el reporte');
	end;
END.
