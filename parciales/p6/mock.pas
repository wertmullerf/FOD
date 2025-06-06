
program mock;
{$APPTYPE CONSOLE}
{$packrecords 1} // Asegura que no haya padding en los records

type
  producto = record
    codigo: integer;
    nombre: string[30];
    precio: integer;
    stock_actual: integer;
    stock_minimo: integer;
  end;

  venta = record
    codigo: integer;
    cantidad: integer;
  end;

  maestro = file of producto;
  detalle = file of venta;

var
  mae: maestro;
  det: array[1..5] of detalle;
  p: producto;
  v: venta;
  i: integer;

procedure crearMaestro;
begin
  assign(mae, 'maestro.dat');
  rewrite(mae);


  p.codigo := 1; p.nombre := 'Chicle'; p.precio := 5000; p.stock_actual := 100; p.stock_minimo := 10; write(mae, p);

  fillchar(p, sizeof(p), 0);
  p.codigo := 2; p.nombre := 'Caramelo'; p.precio := 30; p.stock_actual := 200; p.stock_minimo := 20; write(mae, p);

  fillchar(p, sizeof(p), 0);
  p.codigo := 3; p.nombre := 'Alfajor'; p.precio := 120; p.stock_actual := 150; p.stock_minimo := 15; write(mae, p);

  close(mae);
end;

procedure crearDetalles;
begin
  for i := 1 to 5 do
  begin
    assign(det[i], 'detalle' + chr(48 + i) + '.dat');
    rewrite(det[i]);

    // Generar dos ventas por archivo, códigos existentes en el maestro
    v.codigo := 1; v.cantidad := 1; write(det[i], v);
    v.codigo := 2; v.cantidad := 5; write(det[i], v);

    close(det[i]);
  end;
end;

begin
  crearMaestro;
  crearDetalles;
  writeln('Archivos maestro y detalle1-5.dat generados correctamente.');
end.
