PROGRAM generar_maestro;
CONST
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

VAR
	maestro: archivo;
	reg: acceso;
BEGIN
	assign(maestro, PATH_BASE + 'maestro');
	rewrite(maestro);

	// Datos de prueba: todos ordenados por anio, mes, dia, idUsuario
	// Año 2023, Mes 1, Día 1
	reg.anio := 2023; reg.mes := 1; reg.dia := 1; reg.idUsuario := 101; reg.tiempo := 2.5; write(maestro, reg);
	reg.anio := 2023; reg.mes := 1; reg.dia := 1; reg.idUsuario := 102; reg.tiempo := 1.0; write(maestro, reg);

	// Día 2
	reg.anio := 2023; reg.mes := 1; reg.dia := 2; reg.idUsuario := 101; reg.tiempo := 1.5; write(maestro, reg);
	reg.anio := 2023; reg.mes := 1; reg.dia := 2; reg.idUsuario := 105; reg.tiempo := 3.2; write(maestro, reg);

	// Mes 2
	reg.anio := 2023; reg.mes := 2; reg.dia := 1; reg.idUsuario := 101; reg.tiempo := 1.1; write(maestro, reg);

	// Año 2024
	reg.anio := 2024; reg.mes := 1; reg.dia := 1; reg.idUsuario := 200; reg.tiempo := 2.0; write(maestro, reg);

	close(maestro);
	writeln('Archivo maestro generado con éxito.');
END.
