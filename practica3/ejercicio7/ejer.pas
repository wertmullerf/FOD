PROGRAM ejer;
CONST
	valoralto = 9999;
	//PATH_BASE = '/Users/facundowertmuller/Desktop/FOD/practica3/ejercicio6/';
TYPE 	ave = record
				codigo:integer;
				nombre_especie, famia_ave, descripcion, zona: string[30];
			end;
			
			archivo = file of ave;
			
{Inciso a -> en caso de querer borrar múltiples especies de aves, se podría 
invocar este procedimiento repetidamente }
PROCEDURE borrarPorCodigo(var maestro:archivo; codigoBorrado:integer);
VAR
	borrado:boolean;
	reg:ave;
BEGIN
	reset(maestro);
	borrado:=false;	
	while((not eof(maestro)) and (not borrado))do begin
		read(maestro, reg);
		if(reg.codigo = codigoBorrado)then begin
			reg.codigo:= reg.codigo * (-1);
			seek(maestro, filepos(maestro) - 1);
			write(maestro, reg);
			borrado:= true;
		end;	
	end;
END;

PROCEDURE compactarArchivo(var arch: archivo);
VAR
    reg, ult: ave;
    posActual, posUltimo: integer;
BEGIN
    reset(arch);
    while (filepos(arch) < filesize(arch)) do begin
        posActual := filepos(arch);
        read(arch, reg);

        if (reg.codigo < 0) then begin
            posUltimo := filesize(arch) - 1;

            // Mientras el actual no sea el último, reemplazo
            if (posActual <> posUltimo) then begin
                seek(arch, posUltimo);
                read(arch, ult);
                seek(arch, posActual);
                write(arch, ult);
            end;

            // Siempre corto el archivo al eliminar el último
            seek(arch, posUltimo);
            truncate(arch);

            // Muy importante: me tengo que volver a parar en el lugar del borrado
            seek(arch, posActual);
        end;
    end;
    close(arch);
END;

PROCEDURE leer(var arch: archivo; var dato: ave);
BEGIN
    if not eof(arch) then
        read(arch, dato)
    else
        dato.codigo := valoralto;
END;

PROCEDURE compactarArchivoUnSoloEliminadoFisico(var arch: archivo);
VAR
    reg, ult: ave;
    posActual, posUltimo: integer;
BEGIN
    reset(arch);
    leer(arch, reg);
    posUltimo := filesize(arch) - 1;
    posActual := filepos(arch) - 1;

    while ((reg.codigo <> valoralto) and (posUltimo >= posActual)) do begin
        if (reg.codigo < 0) then begin
            if (posActual <> posUltimo) then begin
                // Verificar que posUltimo sea válido antes de usarlo
                if (posUltimo >= 0) then begin
                    seek(arch, posUltimo);
                    leer(arch, ult);

                    // Buscar el último registro no eliminado
                    while (ult.codigo < 0) and (posUltimo > posActual) do begin
                        posUltimo := posUltimo - 1;
                        if (posUltimo >= 0) then begin
                            seek(arch, posUltimo);
                            leer(arch, ult);
                        end;
                    end;

                    // Reemplazar solo si el último registro es válido
                    if (posUltimo > posActual) and (ult.codigo >= 0) then begin
                        seek(arch, posActual);
                        write(arch, ult);
                    end;
                end;
            end;
            posUltimo := posUltimo - 1; // Mover el límite superior
        end;

        posActual := filepos(arch);
        leer(arch, reg);
    end;

    // Ajustar el tamaño del archivo
    if (posUltimo + 1 >= 0) then begin
        seek(arch, posUltimo + 1);
        truncate(arch);
    end;
    close(arch);
END;


PROCEDURE imprimir(var arch:archivo);
VAR
	reg:ave;
BEGIN
	reset(arch);
	while(not eof(arch))do begin
		read(arch, reg);
		writeln('Codigo: ', reg.codigo, ' Nombre: ', reg.nombre_especie);
	end;
END;
VAR
	maestro:archivo;
	i:integer;
	codigoBorrado:integer;
BEGIN
	assign(maestro, 'maestro');
	for i:= 1 to 3 do begin
	writeln('Ingrese el codigo de ave que desee eliminar');
	readln(codigoBorrado);
	borrarPorCodigo(maestro, codigoBorrado);
	end;

	imprimir(maestro);
	writeln;
	compactarArchivoUnSoloEliminadoFisico(maestro);
	writeln;
	imprimir(maestro);

END.
