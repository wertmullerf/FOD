PROGRAM parcial;
TYPE producto = record
		codigo:integer; //UNICO
		nombre, descripcion,ubicacion: String[30];
		costo, venta:real;
	end;
	
	archivo = file of producto;

PROCEDURE imprimirProductos(var arch: archivo);
VAR
  reg: producto;
  i: integer;
BEGIN
	reset(arch);
	i:=0;
    while not eof(arch) do begin
      read(arch, reg);
      writeln('Posicion ', i, ' - Codigo: ', reg.codigo, ' | Nombre: ', reg.nombre);
      i := i + 1;
	end;
	close(arch);
END;

PROCEDURE existeProducto(var arch: archivo; cod: integer; var pos: integer);
VAR
  reg: producto;
  i: integer;
BEGIN
	reset(arch);
	pos := -1; // valor por defecto (no encontrado)
	i := 1;    // empieza en 1 porque la cabecera está en 0
	seek(arch, 1);
	while (not eof(arch)) and (pos = -1) do begin
		read(arch, reg);
		if (reg.codigo = cod) then
			pos := i;
		i := i + 1;
    end;
	close(arch);
END;
	
//Utilizo el registro 0 y campo codigo del archivo como cabecera

PROCEDURE leerProducto(var arch: archivo; var p:producto; var pude:boolean);
VAR
	pos:integer;
BEGIN
	writeln('Ingrese el codigo de producto');
	readln(p.codigo);
	existeProducto(arch, p.codigo,pos);
	if(pos = -1)then begin
		writeln('Ingrese el nombre'); 
		readln(p.nombre); 
		p.descripcion := 'zzz'; p.ubicacion:= 'zzz';
		writeln('Ingrese el costo'); 
		readln(p.costo);
		writeln('Ingrese el precio de venta');
		readln(p.venta);
		pude:=true;
	end
	else
		pude:=false;
END;
PROCEDURE agregarNovela(var arch:archivo);
VAR		
	cabecera, nuevo, libre: producto;
	x: integer;
	puedo: boolean;
BEGIN
	leerProducto(arch, nuevo, puedo);
	if(puedo)then begin
		reset(arch);
		read(arch, cabecera);
		x:= cabecera.codigo;
		if(x<>0)then begin
			seek(arch, x * (-1));
			read(arch, libre);
			seek(arch, filepos(arch)-1);
			write(arch, nuevo); //--> producto leido
			seek(arch,0);
			cabecera.codigo:= libre.codigo;
			write(arch,cabecera);
		end
		else begin
			seek(arch, filesize(arch));
			write(arch, nuevo);
		end;
		close(arch);
		imprimirProductos(arch);
	end
	else
		writeln('Producto ya existente');
END;


PROCEDURE quitarProducto(var arch:archivo);
VAR
	x,num,pos:integer;
	cabecera,reg:producto;
BEGIN
	writeln('Ingrese el numero a eliminar');
	readln(num);
	existeProducto(arch, num,pos); //suponiendo que si existe retorna la posicion sino -1
	if(pos <> -1)then begin
		reset(arch);
		read(arch, cabecera);
		x:= cabecera.codigo;
		seek(arch, pos);
		read(arch, reg);
		reg.codigo := x;
		seek(arch, pos);
		write(arch, reg);
		seek(arch,0);
		cabecera.codigo:= pos * (-1);
		write(arch,cabecera);
		imprimirProductos(arch);
	end
	else
		writeln('Producto no existente');
END;


VAR
  arch: archivo;
  opc: char;
BEGIN
  assign(arch, 'productos.dat');
  
  repeat
    writeln;
    writeln('MENU:');
    writeln('A - Agregar producto');
    writeln('B - Quitar producto');
    writeln('X - Salir');
    readln(opc);
    opc := upcase(opc);
    
    case opc of
      'A': agregarNovela(arch);  // Considerá cambiar el nombre a agregarProducto
      'B': quitarProducto(arch);
      
    end;
  until opc = 'X';
END.
