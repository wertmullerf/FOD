PROGRAM ejer1;
CONST 
	PATH_BASE= '/Users/facundowertmuller/Desktop/FOD/practica2/';
	valoralto=9999;
TYPE
   empleado = record
        codigo: Integer;
        nombre: String[30];
        comision: Real;
    end;

	archivo = file of empleado;


//_____________________________________________________________
procedure imprimir(var arch:archivo);
var
    emp:empleado;
begin
	//assign(arch, PATH_BASE + 'empleadosDetalle');
    reset(arch);
    while(not eof(arch)) do begin
		read(arch, emp);
        WriteLn('Codigo:',emp.codigo);
        writeln('Nombre:', emp.nombre);
        writeln('Monto:', emp.comision:2:2);
        WriteLn('_________');
	end;
	close(arch);
end;
//_____________________________________________________________

PROCEDURE generarArchivo(var detalle:archivo);
VAR
	e:empleado;
	carga:text;
BEGIN
	rewrite(detalle);
	assign(carga, PATH_BASE + 'empleados.txt');
	reset(carga);
	while(not EOF(carga))do begin
		readln(carga, e.codigo);
		readln(carga, e.nombre);
		readln(carga, e.comision);
		write(detalle, e);
	end;
	writeln('Binario Creado Exitosamente');
	close(detalle);
	close(carga);
END;

//-------------------------------
procedure leer (var detalle:archivo;var dato:empleado);
begin
    if (not eof(detalle))
        then read (detalle,dato)
    else 
        dato.codigo := valoralto;
end;
//-------------------------------
VAR
    detalle, maestro: archivo;
    codActual:integer;
    nombreActual:string;
    regDetalle,regMaestro:empleado;
    acc:real;
BEGIN
	assign(detalle, PATH_BASE + 'empleadosDetalle');
	generarArchivo(detalle);
	writeln;
	imprimir(detalle);
	assign(maestro, PATH_BASE + 'maestro');
	rewrite(maestro);
	reset(detalle);
	leer(detalle,regDetalle);
	while(regDetalle.codigo <> 9999)do begin
		acc:=0;
		codActual := regDetalle.codigo;
		nombreActual:= regDetalle.nombre;
		while(codActual = regDetalle.codigo)do begin
			acc:= acc + regDetalle.comision;
			leer(detalle, regDetalle); // --> Avanza en el ultimo caso OJO
		end;
		regMaestro.codigo:= codActual;
		regMaestro.nombre:= nombreActual;
		regMaestro.comision:= acc;
		write(maestro,regMaestro);
	end;
	
	writeln;
	close(maestro);
	imprimir(maestro);
	
	close(detalle);
	
	
END.
