PROGRAM parcial;
CONST
	PATH_BASE = '/Users/facundowertmuller/Desktop/FOD/parciales/p4/';
TYPE 	
	fechaReg = record
		dia: 1..31;
		mes:1..12;
		anio:integer;
	end;
	prestamo = record
		sucursal,num_prestamo:integer;
		dni:string[30];
		fecha: fechaReg;
		monto:real;
	end;
	
	archivo = file of prestamo;
	
	
PROCEDURE evaluarMaestro(var maestro:archivo; var txt:text);
VAR
	sucursal:integer;
	empleadoDni:string;
	fecha: fechaReg;
	regm:prestamo;
	accSucursal,accEmpresa, accEmpleado, accAnio:integer;
	totalSucursal, totalEmpresa, totalEmpleado, totalAnio:real;
BEGIN
	reset(maestro);
	rewrite(txt);
	totalEmpresa:=0;
	accEmpresa:= 0;
	writeln(txt, 'Informes de ventas de la empresa');
	while(not eof(maestro))do begin
		read(maestro, regm);
		sucursal:= regm.sucursal;
		writeln(txt, 'Sucursal ', sucursal);
		accSucursal:=0;
		totalSucursal:=0;
		while((not eof(maestro))and(sucursal = regm.sucursal)) do begin
			empleadoDni:= regm.dni;
			writeln(txt, 'Empleado DNI ', empleadoDni);
			totalEmpleado:= 0;
			accEmpleado:=0;
			
			while((not eof(maestro))and(sucursal = regm.sucursal) and (empleadoDni = regm.dni)) do begin
				writeln(txt, 'AÑO  ', ' Cantidad de Ventas ', ' Monto de Ventas ' );
				fecha.anio := regm.fecha.anio;
				totalAnio:= 0;
				accAnio:=0;
				while((not eof(maestro))and(sucursal = regm.sucursal) and (empleadoDni = regm.dni) and (fecha.anio = regm.fecha.anio))do begin
					totalAnio := totalAnio + regm.monto;
					accAnio:= accAnio + 1;
					read(maestro, regm);
				end;
				writeln(txt, fecha.anio, '  ', accAnio, '  $', totalAnio:0:2);
				totalEmpleado:= totalEmpleado + totalAnio;
				accEmpleado:= accEmpleado + accAnio;
			end;
			writeln(txt, 'Totales', '         ',  'Total Ventas Empleado: ', accEmpleado, '  Monto Total Empleado: $', totalEmpleado:0:2);
			accSucursal:= accSucursal + accEmpleado;
			totalSucursal:= totalEmpleado + totalEmpleado;
		end;
			writeln(txt,'Cantidad total de ventas de la sucursal: ', accSucursal);
			writeln(txt,'Monto total vendido por la sucursal: $', totalSucursal:0:2);
			accEmpresa:= accEmpresa + accSucursal;
			totalEmpresa:= totalEmpresa + totalSucursal;
	end;
	writeln(txt, 'Cantidad de ventas de la empresa: ', accEmpresa);
	writeln(txt, 'Monto total vendido por la empresa: $', totalEmpresa:0:2);
	
	close(txt);
	close(maestro);
END;
VAR
	maestro: archivo;
	texto: text;

BEGIN
	assign(maestro, PATH_BASE + 'prestamos.dat');
	assign(texto, PATH_BASE + 'output.txt');
	evaluarMaestro(maestro,texto);
END.
