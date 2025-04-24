PROGRAM generar_mock_datos;
CONST
  PATH_BASE = '/Users/facundowertmuller/Desktop/FOD/practica3/ejercicio6/';
TYPE
  prenda = record
    cod_prenda, stock: integer;
    descripcion, colores, tipo_prenda: string[25];
    precio_unitario: real;
  end;

VAR
  maestro: file of prenda;
  detalle: file of integer;
  p: prenda;
  cod_baja: integer;

BEGIN
  // Generar archivo maestro
  assign(maestro, PATH_BASE + 'maestro');
  rewrite(maestro);

  // Prenda 1
  p.cod_prenda := 101;
  p.stock := 10;
  p.descripcion := 'Remera lisa';
  p.colores := 'Rojo, Azul';
  p.tipo_prenda := 'Remera';
  p.precio_unitario := 1500.50;
  write(maestro, p);

  // Prenda 2
  p.cod_prenda := 202;
  p.stock := 20;
  p.descripcion := 'Jean clásico';
  p.colores := 'Azul';
  p.tipo_prenda := 'Pantalón';
  p.precio_unitario := 5000;
  write(maestro, p);

  // Prenda 3
  p.cod_prenda := 303;
  p.stock := 15;
  p.descripcion := 'Campera inflable';
  p.colores := 'Negro';
  p.tipo_prenda := 'Campera';
  p.precio_unitario := 12000;
  write(maestro, p);

  // Prenda 4
  p.cod_prenda := 404;
  p.stock := 8;
  p.descripcion := 'Zapatilla urbana';
  p.colores := 'Blanco, Negro';
  p.tipo_prenda := 'Calzado';
  p.precio_unitario := 9500;
  write(maestro, p);

  close(maestro);

  // Generar archivo de detalle (bajas)
  assign(detalle, PATH_BASE + 'detalle');
  rewrite(detalle);

  cod_baja := 202; write(detalle, cod_baja); // Baja Jean clásico
  cod_baja := 404; write(detalle, cod_baja); // Baja Zapatilla urbana

  close(detalle);
END.
