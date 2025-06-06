
program mock;
type
  producto = record
    codigo: integer;
    nombre, descripcion, ubicacion: string[30];
    costo, venta: real;
  end;

  archivo = file of producto;

var
  arch: archivo;
  p: producto;
  ruta: string;

procedure escribirProducto(var f: archivo; cod: integer; nom, desc, ubi: string; cst, vta: real);
var
  prod: producto;
begin
  prod.codigo := cod;
  prod.nombre := nom;
  prod.descripcion := desc;
  prod.ubicacion := ubi;
  prod.costo := cst;
  prod.venta := vta;
  write(f, prod);
end;

begin
  ruta := 'productos.dat';
  assign(arch, ruta);
  rewrite(arch);

  // Cabecera
  p.codigo := 0;
  p.nombre := ''; p.descripcion := ''; p.ubicacion := '';
  p.costo := 0; p.venta := 0;
  write(arch, p);

  // Producto 1
  escribirProducto(arch, 1, 'Leche', 'Entera 1L', 'A1', 100.5, 150.0);

  // Producto 2
  escribirProducto(arch, 2, 'Pan', 'Frances', 'B2', 50.0, 80.0);

  // Producto 3
  escribirProducto(arch, 3, 'Queso', 'Tybo', 'C3', 300.0, 450.0);

  close(arch);
  writeln('Archivo productos.dat generado con éxito.');
end.
