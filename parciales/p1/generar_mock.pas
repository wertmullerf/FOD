program generar_datos;
uses SysUtils;

const
  PATH_BASE = '/Users/facundowertmuller/Desktop/FOD/parciales/p1/';
  CANT_DETALLES = 10;

type
  base = record
    codigo: integer;
    casos: integer;
  end;

  regMaestro = record
    b: base;
    nombre_municipio: string[30];
  end;

  archivo = file of regMaestro;
  detalle = file of base;

const
  municipios: array[1..10] of string = (
    'La Plata', 'Berisso', 'Ensenada', 'Quilmes', 'Avellaneda',
    'Lanus', 'Lomas de Zamora', 'Almirante Brown', 'Florencio Varela', 'Berazategui'
  );

var
  maestro: archivo;
  detalles: array[1..CANT_DETALLES] of detalle;
  i, j, cod, casos: integer;
  regM: regMaestro;
  regD: base;
  nombreArchivo: string;
  codigosOrdenados: array[1..10] of integer;

procedure ordenarCodigos();
var
  i, j, aux: integer;
begin
  for i := 1 to 10 do
    codigosOrdenados[i] := 100 + i; // códigos 101 a 110

  // burbujeo por si en algún momento se desordenan
  for i := 1 to 9 do
    for j := i + 1 to 10 do
      if codigosOrdenados[i] > codigosOrdenados[j] then begin
        aux := codigosOrdenados[i];
        codigosOrdenados[i] := codigosOrdenados[j];
        codigosOrdenados[j] := aux;
      end;
end;

procedure ordenarBase(var arr: array of base; n: integer);
var
  i, j: integer;
  temp: base;
begin
  for i := 0 to n - 2 do
    for j := i + 1 to n - 1 do
      if arr[i].codigo > arr[j].codigo then begin
        temp := arr[i];
        arr[i] := arr[j];
        arr[j] := temp;
      end;
end;

var
  datos: array[0..14] of base;
  cantReg: integer;
begin
  ordenarCodigos();

  // Generar maestro ordenado
  assign(maestro, PATH_BASE + 'maestro.dat');
  rewrite(maestro);
  for i := 1 to 10 do begin
    regM.b.codigo := codigosOrdenados[i];
    regM.b.casos := Random(11);  // casos entre 0 y 10
    regM.nombre_municipio := municipios[i];
    write(maestro, regM);
  end;
  close(maestro);

  // Generar cada archivo detalle ordenado
  for i := 1 to CANT_DETALLES do begin
    str(i, nombreArchivo);
    assign(detalles[i], PATH_BASE + 'p1detalle' + nombreArchivo + '.dat');
    rewrite(detalles[i]);

    cantReg := 5 + Random(6); // entre 5 y 10 registros

    for j := 0 to cantReg - 1 do begin
      datos[j].codigo := 101 + Random(10); // códigos entre 101 y 110
      datos[j].casos := 1 + Random(10);
    end;

    ordenarBase(datos, cantReg);

    for j := 0 to cantReg - 1 do
      write(detalles[i], datos[j]);

    close(detalles[i]);
  end;

  writeln('Archivos maestro y detalles generados correctamente.');
end.
