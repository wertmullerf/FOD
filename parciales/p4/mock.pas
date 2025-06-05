program generar_mock_prestamos;
uses SysUtils;

const
  PATH_BASE = '/Users/facundowertmuller/Desktop/FOD/parciales/';

type
  fechaReg = record
    dia: 1..31;
    mes: 1..12;
    anio: integer;
  end;

  prestamo = record
    num_sucursal, num_prestamo: integer;
    dni: string[30];
    fecha: fechaReg;
    monto: real;
  end;

  archivo = file of prestamo;

var
  f: archivo;
  reg: prestamo;

procedure agregarPrestamo(suc: integer; dni: string; nro: integer; d, m, a: integer; monto: real);
begin
  reg.num_sucursal := suc;
  reg.dni := dni;
  reg.num_prestamo := nro;
  reg.fecha.dia := d;
  reg.fecha.mes := m;
  reg.fecha.anio := a;
  reg.monto := monto;
  write(f, reg);
end;

begin
  assign(f, PATH_BASE + 'prestamos.dat');
  rewrite(f);

  // Sucursal 1 - Empleado E01 - Año 2022 y 2023
  agregarPrestamo(1, 'E01', 1, 10, 1, 2022, 10000);
  agregarPrestamo(1, 'E01', 2, 15, 2, 2022, 11000);
  agregarPrestamo(1, 'E01', 3, 20, 3, 2023, 12000);
  agregarPrestamo(1, 'E01', 4, 25, 4, 2023, 13000);

  // Sucursal 1 - Empleado E02 - Año 2022
  agregarPrestamo(1, 'E02', 5, 5, 5, 2022, 9000);
  agregarPrestamo(1, 'E02', 6, 6, 6, 2022, 9500);

  // Sucursal 2 - Empleado E03 - Año 2022
  agregarPrestamo(2, 'E03', 7, 1, 7, 2022, 8000);
  agregarPrestamo(2, 'E03', 8, 2, 8, 2022, 8500);

  // Sucursal 2 - Empleado E04 - Año 2023
  agregarPrestamo(2, 'E04', 9, 3, 9, 2023, 7000);
  agregarPrestamo(2, 'E04',10, 4,10, 2023, 7500);
  agregarPrestamo(2, 'E04',11, 5,11, 2023, 7700);

  close(f);
  writeln('Archivo prestamos.dat generado correctamente.');
end.
