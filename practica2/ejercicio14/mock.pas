PROGRAM generar_mock;
CONST
    PATH_BASE = '/Users/facundowertmuller/Desktop/FOD/practica2/ejercicio14/'; // Modificá esto si querés
TYPE
    vuelo = record
        destino, fecha, hora: string;
        cantidad: integer;
    end;

    archivo = file of vuelo;

VAR
    mae, det1, det2: archivo;
    reg: vuelo;
BEGIN
    // Generar archivo maestro
    assign(mae, PATH_BASE + 'maestro');
    rewrite(mae);

    reg.destino := 'Bariloche'; reg.fecha := '2024-05-01'; reg.hora := '08:00'; reg.cantidad := 100;
    write(mae, reg);
    reg.destino := 'Cordoba'; reg.fecha := '2024-05-01'; reg.hora := '09:30'; reg.cantidad := 120;
    write(mae, reg);
    reg.destino := 'Mendoza'; reg.fecha := '2024-05-02'; reg.hora := '14:00'; reg.cantidad := 80;
    write(mae, reg);
    close(mae);

    // Generar archivo detalle 1
    assign(det1, PATH_BASE + 'detall1');
    rewrite(det1);

    reg.destino := 'Bariloche'; reg.fecha := '2024-05-01'; reg.hora := '08:00'; reg.cantidad := 2;
    write(det1, reg);
    reg.destino := 'Cordoba'; reg.fecha := '2024-05-01'; reg.hora := '09:30'; reg.cantidad := 1;
    write(det1, reg);
    close(det1);

    // Generar archivo detalle 2
    assign(det2, PATH_BASE + 'detall2');
    rewrite(det2);

    reg.destino := 'Bariloche'; reg.fecha := '2024-05-01'; reg.hora := '08:00'; reg.cantidad := 3;
    write(det2, reg);
    reg.destino := 'Mendoza'; reg.fecha := '2024-05-02'; reg.hora := '14:00'; reg.cantidad := 4;
    write(det2, reg);
    close(det2);

    writeln('Archivos generados correctamente.');
END.
