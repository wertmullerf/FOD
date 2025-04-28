PROGRAM ejer;
CONST
	PATH_BASE = '/Users/facundowertmuller/Desktop/FOD/practica3/ejercicio8/';
TYPE 
		string30 = string[30];
		distribucion = record
			nombre,descripcion: string30;
			anio,cantidad_desarrolladores:integer;
			version:real; //4.1  ETC
		end;
		
		archivo = file of distribucion;
		
		
PROCEDURE buscarDistribucion(var arch:archivo; nombre: string30; var pos:integer);
VAR
	reg:distribucion;
	encontrado:boolean;
BEGIN
	reset(arch);
	pos:= -1;
	encontrado:=false;
	while((not eof(arch)) and (not encontrado)) do begin
		read(arch,reg);
		if(reg.nombre = nombre)then begin
			pos:= filepos(arch) -1;
			encontrado:= true;
		end;
	end;
	close(arch);
END;

{
 AltaDistribucion: módulo que recibe como parámetro el archivo y el registro que contiene los datos de una nueva distribución, y se encarga de agregar la
 distribución  al archivo reutilizando espacio disponible en caso de que exista. (El control de unicidad lo debe realizar utilizando el módulo anterior). 
 En caso de que la distribución que se quiere agregar ya exista se debe informar “ya existe la distribución”.
}

PROCEDURE altaDistribucion(var arch: archivo; d:distribucion);
VAR
	pos:integer;
	cabecera,libre:distribucion;
	x:integer;
BEGIN	
	buscarDistribucion(arch, d.nombre, pos);
	if(pos  = -1)then begin
		reset(arch);
		read(arch, cabecera);
		x:= cabecera.cantidad_desarrolladores;
		if(x <> 0) then begin
			seek(arch, x * (-1)); // Voy a la posición libre
			read(arch, libre); // Leo lo que había en esa posición
			seek(arch, filepos(arch) - 1);
			write(arch,d);
			// Actualizo cabecera con el "siguiente" de la lista libre
			seek(arch, 0);
			cabecera.cantidad_desarrolladores := libre.cantidad_desarrolladores;
			write(arch, cabecera);
		end
		else begin
			seek(arch, filesize(arch));
			write(arch, d);
		end;
		close(arch);
	end
	else
		writeln('Ya existe la distribución');
END;

{
BajaDistribucion: módulo que recibe como parámetro el archivo y el nombre de una distribución, y se encarga de dar de baja lógicamente la distribución dada. 
Para marcar una distribución como borrada se debe utilizar el campo cantidad de desarrolladores para mantener actualizada la lista invertida. 
Para verificar que la distribución a borrar exista debe utilizar el módulo BuscarDistribucion. En caso de no existir se debe informar “Distribución no existente”.
}

PROCEDURE bajaDistribucion(var arch:archivo; nombre:string30);
VAR
	pos:integer;
	cabecera, reg:distribucion;
BEGIN
	buscarDistribucion(arch,nombre,pos);
	if(pos<> -1)then begin
		reset(arch);
		read(arch, cabecera);
		seek(arch, pos);
		read(arch, reg);
		reg.cantidad_desarrolladores:= cabecera.cantidad_desarrolladores;
		//vuelvo para atras una pos
		seek(arch, filepos(arch) -1);
		write(arch, reg);
		
		//escribo en cabecera la posicion del elemento borrado
		seek(arch, 0);
		cabecera.cantidad_desarrolladores:= pos * (-1);
		write(arch, cabecera);
		
		close(arch);
	end
	else
		writeln('Distribucion no existente');
END;

VAR
	arch:archivo;
	pos:integer;
	nombreDistribucion:string30;
BEGIN
	assign(arch, PATH_BASE + 'maestro');
	reset(arch);
	writeln('Ingrese el nombre de distribucion a buscar');
	readln(nombreDistribucion);
	buscarDistribucion(arch,nombreDistribucion, pos);
	
END.
