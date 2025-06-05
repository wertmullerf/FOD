program generar_mock_pedidos;
uses SysUtils;

const
  PATH_BASE = '/Users/facundowertmuller/Desktop/FOD/parciales/p2/';
  DF = 3;

type
  producto = record
    codigo: integer;
    nombre: string[30];
    descripcion: string[30];
    codigo_barra: string[30];
    categoria: string[30];
    stock_actual: integer;
    stock_minimo: integer;
  end;

  pedido = record
    codigo: integer;
    cantidad: integer;
    descripcion: string[30];
  end;

  archivoMaestro = file of producto;
  archivoDetalle = file of pedido;

const
  nombres: array[1..5] of string[30] = (
    'Hamburguesa', 'Papas Fritas', 'Coca Cola', 'Agua', 'Helado'
  );
  descripciones: array[1..5] of string[30] = (
    'Clásica', 'Porción mediana', 'Botella 500ml', 'Botella 500ml', 'Vainilla'
  );
  codigos_barra: array[1..5] of string[30] = (
    '123456789012', '123456789013', '123456789014', '123456789015', '123456789016'
  );
  categorias: array[1..5] of string[30] = (
    'Comida', 'Comida', 'Bebida', 'Bebida', 'Postre'
  );

var
  maestro: archivoMaestro;
  detalles: array[1..DF] of archivoDetalle;
  regM: producto;
  regD: pedido;
  i, j: integer;
  cod: integer;
  cant: integer;
  nombre_archivo: string;

begin
  // Crear maestro ordenado por código
  assign(maestro, PATH_BASE + 'maestro.dat');
  rewrite(maestro);
  for i := 1 to 5 do begin
    regM.codigo := 100 + i;
    regM.nombre := nombres[i];
    regM.descripcion := descripciones[i];
    regM.codigo_barra := codigos_barra[i];
    regM.categoria := categorias[i];
    regM.stock_actual := 20 + i * 2;
    regM.stock_minimo := 5 + i;
    write(maestro, regM);
  end;
  close(maestro);

  // Crear detalles
  for i := 1 to DF do begin
    str(i, nombre_archivo);
    assign(detalles[i], PATH_BASE + 'detalle' + nombre_archivo + '.dat');
    rewrite(detalles[i]);

    for j := 1 to 3 do begin
      regD.codigo := 100 + j; // códigos 101, 102, 103
      regD.cantidad := 5 + i + j; // variar por archivo
      regD.descripcion := nombres[j];
      write(detalles[i], regD);
    end;

    close(detalles[i]);
  end;

  writeln('Archivos generados correctamente.');
end.
