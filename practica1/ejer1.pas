{
Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. La carga finaliza
cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del
archivo debe ser proporcionado por el usuario desde teclado
}
PROGRAM programa1;
TYPE
	archivo_enteros = file of integer;
VAR
	num:integer;
	enteros:archivo_enteros;
	nombre_fisico:string;
BEGIN
	write('Ingrese el nombre del archivo: ');
	readln(nombre_fisico);
	
	assign(enteros, nombre_fisico);
	readln(num);
	while(num <> 3000) do begin
		write(enteros,num);
		readln(num);
	end;
	
	close(enteros);
	
END.
