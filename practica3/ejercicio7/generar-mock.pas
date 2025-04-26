program generarMock;

//const
  //PATH_BASE = '/Users/facundowertmuller/Desktop/FOD/practica3/ejercicio6/';

type
  ave = record
    codigo: integer;
    nombre_especie, famia_ave, descripcion, zona: string[30];
  end;

  archivo = file of ave;

var
  arch: archivo;
  reg: ave;

procedure cargarAve(var a: ave; c: integer; ne, fa, d, z: string);
begin
  a.codigo := c;
  a.nombre_especie := ne;
  a.famia_ave := fa;
  a.descripcion := d;
  a.zona := z;
end;

begin
  assign(arch, 'maestro');
  rewrite(arch); // Crea o sobreescribe el archivo

  cargarAve(reg, 1, 'Aguila', 'Accipitridae', 'Ave rapaz de gran tamaño', 'Montañas');
  write(arch, reg);

  cargarAve(reg, 2, 'Colibri', 'Trochilidae', 'Ave pequeña de rápido vuelo', 'Selva');
  write(arch, reg);

  cargarAve(reg, 3, 'Pinguino', 'Spheniscidae', 'Ave no voladora', 'Antártida');
  write(arch, reg);

  cargarAve(reg, 4, 'Flamenco', 'Phoenicopteridae', 'Ave zancuda de color rosado', 'Lagunas saladas');
  write(arch, reg);

  cargarAve(reg, 5, 'Loro', 'Psittacidae', 'Ave parlanchina de colores vivos', 'Bosques tropicales');
  write(arch, reg);

  close(arch);
  writeln('Archivo maestro generado correctamente.');
end.
