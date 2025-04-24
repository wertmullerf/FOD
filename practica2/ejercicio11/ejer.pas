PROGRAM ejer;
CONST 
	DF = 15;
	valoralto = 'ZZZZ';
	PATH_BASE = '/Users/facundowertmuller/Desktop/FOD/practica2/ejercicio11/';

TYPE empleado = record
			departamento, division:string[25];
			numero_empleado, categoria:integer;
			horas_extras:real;
		end;
		
		vCategorias = array[1..DF] of real;
		archivo= file of empleado;
		
		
PROCEDURE calcularCostoCategoria(var v:vCategorias);
VAR
	txt:text;
	cat:integer;
	valor:real;
BEGIN
	assign(txt, PATH_BASE + 'categorias.txt');
	reset(txt);
	while(not EOF(txt))do begin
		read(txt, cat, valor);
		v[cat]:= valor;
	end;
	
	close(txt);
END;

PROCEDURE leer(var arch:archivo; var dato: empleado);
BEGIN
	if(not EOF(arch))then
		read(arch,dato)
	else
		dato.departamento := valoralto;
END;
VAR
	maestro:archivo;
	v:vCategorias;
	total_division, total_empleado, total_horas_division:real;
	departamento,division:string[25];
	e:empleado;
	total_horas_departamento, total_departamento: real;
BEGIN
	assign(maestro, PATH_BASE + 'maestro');
	reset(maestro);
	calcularCostoCategoria(v);
	
	leer(maestro, e);
	while(e.departamento <>valoralto)do begin
		departamento:= e.departamento;
		writeln('Departamento: ', departamento);
		total_horas_departamento:=0;
		total_departamento:=0;
		while(e.departamento = departamento)do begin
			total_division:= 0;
			total_horas_division:=0;
			division:= e.division;
			writeln('Division: ', division);
					writeln('Nro', '  ', ' Total HS ',  ' Importe a cobrar ');

			while((e.departamento = departamento)and(division = e.division))do begin
				total_empleado:= e.horas_extras * v[e.categoria];
				total_division :=  total_division + total_empleado;
				total_horas_division:= total_horas_division + e.horas_extras;
				
				writeln(e.numero_empleado, '    ', e.horas_extras:0:2, '  ',  '  $', total_empleado:0:2);  
				leer(maestro, e);
			end;
			total_departamento:= total_departamento + total_division;
			total_horas_departamento:= total_horas_departamento + total_horas_division;
			writeln('Total de horas division: ', total_horas_division:0:2);
			writeln('Monto total por división: $', total_division:0:2);
			WRITELN;
		end;
		writeln('Total horas departamento: ', total_horas_departamento:0:2);
		writeln('Monto total departamento: $', total_departamento:0:2);
		WRITELN;
	end;
	
	close(maestro);
	
END.
