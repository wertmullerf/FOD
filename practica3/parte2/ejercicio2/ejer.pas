PROGRAM ejer;
CONST
	PATH_BASE= '/Users/facundowertmuller/Desktop/FOD/practica3/parte2/ejercicio2/';
TYPE mesa = record
			codigo_localidad,nro_mesa,cant_votos:integer;
		end;
		
		archivo = file of mesa;
		lista = ^nodo;
		nodo = record
			dato:mesa;
			sig:lista;
		end;
		
procedure actualizarLista(var l: lista; reg: mesa);
var
    aux: lista;
begin
    aux := l;

    // Buscar si ya existe la localidad
    while (aux <> nil) and (aux^.dato.codigo_localidad <> reg.codigo_localidad) do
        aux := aux^.sig;

    if (aux <> nil) then
        // Si existe, sumo los votos
        aux^.dato.cant_votos := aux^.dato.cant_votos + reg.cant_votos
    else
    begin
        // No existe, creo un nuevo nodo adelante
        new(aux);
        aux^.dato.codigo_localidad := reg.codigo_localidad;
        aux^.dato.nro_mesa := reg.nro_mesa; // dummy, no importa
        aux^.dato.cant_votos := reg.cant_votos;
        aux^.sig := l;
        l := aux;
    end;
end;

PROCEDURE agruparData(var arch:archivo; var l:lista);
VAR	
	reg:mesa;
BEGIN
	reset(arch);
	while(not eof(arch))do begin
		read(arch, reg);
		actualizarLista(l, reg);
	end;
	
	close(arch);
END;


PROCEDURE imprimir(l:lista);
VAR
	acc:integer;
BEGIN
	acc:=0;
	while(l<>nil)do begin
		writeln('CODIGO: ', l^.dato.codigo_localidad, ' -- CANTIDAD: ', l^.dato.cant_votos);
		acc:= acc + l^.dato.cant_votos;
		l:=l^.sig;
	end;
	writeln;
	writeln('Total de votos: ', acc);
END;
VAR
	l:lista;
	arch:archivo;
BEGIN
	assign(arch, PATH_BASE + 'data');
	l:= nil;
	agruparData(arch, l);
	imprimir(l);
END.
		 
