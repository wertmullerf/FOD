program generarMockData;
const
    PATH_BASE = '/Users/facundowertmuller/Desktop/FOD/practica3/parte2/ejercicio2/';
type
    mesa = record
        codigo_localidad: integer;
        nro_mesa: integer;
        cant_votos: integer;
    end;
    archivo = file of mesa;

var
    arch: archivo;
    reg: mesa;
    i: integer;
begin
    assign(arch, PATH_BASE + 'data');
    rewrite(arch);

    // Generamos 10 mesas de ejemplo
    for i := 1 to 10 do
    begin
        reg.codigo_localidad := Random(3) + 1;  // Localidades del 1 al 3
        reg.nro_mesa := i;                     // Número de mesa correlativo
        reg.cant_votos := Random(300) + 1;      // Votos entre 1 y 300
        write(arch, reg);
    end;

    close(arch);
    writeln('Archivo de prueba generado correctamente.');
end.
