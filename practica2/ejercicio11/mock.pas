PROGRAM crear_mock;
CONST
  PATH_BASE = '/Users/facundowertmuller/Desktop/FOD/practica2/ejercicio11/';
  DF = 15;
TYPE
  empleado = record
    departamento, division: string[25];
    numero_empleado, categoria: integer;
    horas_extras: real;
  end;

  archivo = file of empleado;

VAR
  mae: archivo;
  e: empleado;
  i, d, divi, empNum: integer;
  depNombre, divNombre: string;

BEGIN
  assign(mae, PATH_BASE + 'maestro');
  rewrite(mae);

  empNum := 1;
  for i := 1 to 3 do // 3 departamentos
  begin
    depNombre := 'Depto' + Chr(64 + i); // DeptoA, DeptoB, DeptoC
    for d := 1 to 2 do // 2 divisiones por depto
    begin
      divNombre := 'Div' + Chr(64 + d); // DivA, DivB
      for divi := 1 to 4 do // 4 empleados por división
      begin
        e.departamento := depNombre;
        e.division := divNombre;
        e.numero_empleado := empNum;
        e.categoria := Random(DF) + 1;
        e.horas_extras := Random(20) + 1; // entre 1 y 20 hs
        write(mae, e);
        empNum := empNum + 1;
      end;
    end;
  end;

  close(mae);
  writeln('Archivo maestro generado con éxito.');
END.
