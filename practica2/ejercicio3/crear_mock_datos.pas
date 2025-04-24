program crear_mock_datos;

const
  PATH_BASE = '/Users/facundowertmuller/Desktop/FOD/practica2/ejercicio3/';

type
  provinciaMaestro = record
    provincia: string[25];
    cant_alfabetizadas: longint;
    total_encuestados: longint;
  end;

  provinciaDetalle = record  
    base: provinciaMaestro;
    cod_localidad: integer;
  end;

  archivoMaestro = file of provinciaMaestro;
  archivoDetalle = file of provinciaDetalle;

// ------------------------------
// Crear archivo maestro
// ------------------------------
procedure crearMaestro;
var
  mae: archivoMaestro;
  p: provinciaMaestro;
begin
  assign(mae, PATH_BASE + 'maestro');
  rewrite(mae);

  p.provincia := 'Buenos Aires'; p.cant_alfabetizadas := 1000000; p.total_encuestados := 1200000; write(mae, p);
  p.provincia := 'Catamarca';    p.cant_alfabetizadas := 200000;  p.total_encuestados := 220000;  write(mae, p);
  p.provincia := 'Cordoba';      p.cant_alfabetizadas := 500000;  p.total_encuestados := 600000;  write(mae, p);
  p.provincia := 'La Pampa';     p.cant_alfabetizadas := 150000;  p.total_encuestados := 160000;  write(mae, p);
  p.provincia := 'Salta';        p.cant_alfabetizadas := 300000;  p.total_encuestados := 350000;  write(mae, p);

  close(mae);
end;

// ------------------------------
// Crear archivo detalle 1
// ------------------------------
procedure crearDetalle1;
var
  det: archivoDetalle;
  d: provinciaDetalle;
begin
  assign(det, PATH_BASE + 'detalle1');
  rewrite(det);

  d.base.provincia := 'Buenos Aires'; d.base.cant_alfabetizadas := 20000; d.base.total_encuestados := 25000; d.cod_localidad := 101; write(det, d);
  d.base.provincia := 'Cordoba';      d.base.cant_alfabetizadas := 30000; d.base.total_encuestados := 35000; d.cod_localidad := 202; write(det, d);
  d.base.provincia := 'La Pampa';     d.base.cant_alfabetizadas := 10000; d.base.total_encuestados := 12000; d.cod_localidad := 303; write(det, d);

  close(det);
end;

// ------------------------------
// Crear archivo detalle 2
// ------------------------------
procedure crearDetalle2;
var
  det: archivoDetalle;
  d: provinciaDetalle;
begin
  assign(det, PATH_BASE + 'detalle2');
  rewrite(det);

  d.base.provincia := 'Buenos Aires'; d.base.cant_alfabetizadas := 15000; d.base.total_encuestados := 20000; d.cod_localidad := 102; write(det, d);
  d.base.provincia := 'Catamarca';    d.base.cant_alfabetizadas := 10000; d.base.total_encuestados := 12000; d.cod_localidad := 201; write(det, d);

  close(det);
end;

// ------------------------------
// Programa principal
// ------------------------------
begin
  crearMaestro;
  crearDetalle1;
  crearDetalle2;
  writeln('Archivos creados correctamente en ', PATH_BASE);
end.
