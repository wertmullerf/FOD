PROGRAM parcial;
CONST
	df =5;
	valoralto=9999;
TYPE producto = record
		codigo,stock_min,stock_actual:integer;
		nombre:string[30];
		precio:integer;
	end;
	
	maestro = file of producto;
	
	venta = record
		codigo:integer;
		cantidad:integer;
	end;
	detalle = file of venta;
	
	vArchDetalle = array[1..DF] of detalle;
	vRegDetalle = array[1..DF] of venta;

PROCEDURE leer(var arch: detalle; var dato:venta);
BEGIN
	if(not eof(arch))then
		read(arch,dato)
	else
		dato.codigo := valoralto;
END;

PROCEDURE minimo(var detalles: vArchDetalle; var registros: vRegDetalle; var min: venta);
VAR
	i,indice:integer;
BEGIN
	min.codigo := valoralto;
	for i:= 1 to DF do begin
		if(registros[i].codigo < min.codigo)then begin
			min := registros[i];
			indice := i;
		end;
	end;
	if(min.codigo <> valoralto)then
		leer(detalles[indice], registros[indice]);
END;
PROCEDURE actualizarMaestro(var mae:maestro; var txt:text);
VAR
	i,codAct:integer;
	acc:real;
	a:string;
	vArch:vArchDetalle;
	vReg: vRegDetalle;
	min:venta;
	regm:producto;
BEGIN
	rewrite(txt);
	reset(mae);
	for i:= 1 to DF do begin
		str(i,a);
		assign(vArch[i], 'detalle' + a+'.dat');
		reset(vArch[i]);
		leer(vArch[i], vReg[i]);
	end;
	
	minimo(vArch, vReg, min);
	
	while(min.codigo<>valoralto) and (not eof(mae))do begin
		read(mae, regm);
		while((not eof(mae)) and (regm.codigo < min.codigo))do
			read(mae,regm);
		
		if (regm.codigo = min.codigo) then begin
			codAct := min.codigo;
			acc := 0;
			while (min.codigo = codAct) do begin
				regm.stock_actual := regm.stock_actual - min.cantidad;
				acc := acc + (min.cantidad * regm.precio);
				
				minimo(vArch, vReg, min);
			end;
			writeln(acc);
			if (acc > 10000) then
				writeln(txt, 'Codigo: ', regm.codigo,
						 ' Precio: ', regm.precio,
						 ' Stock actual: ', regm.stock_actual,
						 ' Stock minimo: ', regm.stock_min);

			seek(mae, filepos(mae) - 1);
			write(mae, regm);
		end
		else
		  minimo(vArch, vReg, min); // salto venta si el código no existe en maestro
	end;
	close(mae);
	close(txt);
	for i:= 1 to DF do
		close(vArch[i]);
	
	writeln('exito');
END;

procedure imprimirMaestro(var mae: maestro);
var
  reg: producto;
begin
  reset(mae);
  writeln('--- LISTADO DE PRODUCTOS DEL MAESTRO ---');
  while not eof(mae) do
  begin
    read(mae, reg);
    writeln('Codigo: ', reg.codigo);
    writeln('Stock actual: ', reg.stock_actual);
  
    writeln('----------------------------------------');
  end;
  close(mae);
end;


VAR
	txt:text;
	mae:maestro;

BEGIN
	assign(mae, 'maestro.dat');
	assign(txt, 'archivo_exportado.txt');
	actualizarMaestro(mae,txt);
END.

