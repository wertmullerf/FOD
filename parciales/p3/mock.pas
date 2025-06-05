program generar_mock_mail;
uses SysUtils;

const
  PATH = '/Users/facundowertmuller/Desktop/FOD/parciales/p3/';

type
  log = record
    numero_usuario, cantidad_mails: integer;
    nombre_usuario, nombre, apellido: string[30];
  end;

  detalleReg = record
    numero_usuario, cuenta_destino: integer;
    cuerpo: string[30];
  end;

  maestro = file of log;
  archivoDetalle = file of detalleReg;

var
  archMaestro: maestro;
  archDetalle: archivoDetalle;
  regM: log;
  regD: detalleReg;

begin
  // Crear archivo maestro logsmall.dat
  assign(archMaestro, PATH + 'logsmall.dat');
  rewrite(archMaestro);

  regM.numero_usuario := 101;
  regM.cantidad_mails := 0;
  regM.nombre_usuario := 'lucas123';
  regM.nombre := 'Lucas';
  regM.apellido := 'Pérez';
  write(archMaestro, regM);

  regM.numero_usuario := 102;
  regM.cantidad_mails := 0;
  regM.nombre_usuario := 'meli2024';
  regM.nombre := 'Melina';
  regM.apellido := 'Gómez';
  write(archMaestro, regM);

  regM.numero_usuario := 103;
  regM.cantidad_mails := 0;
  regM.nombre_usuario := 'juampi88';
  regM.nombre := 'Juan Pablo';
  regM.apellido := 'Fernández';
  write(archMaestro, regM);

  regM.numero_usuario := 104;
  regM.cantidad_mails := 0;
  regM.nombre_usuario := 'carlita';
  regM.nombre := 'Carla';
  regM.apellido := 'Rodríguez';
  write(archMaestro, regM);

  regM.numero_usuario := 105;
  regM.cantidad_mails := 0;
  regM.nombre_usuario := 'tomi.dev';
  regM.nombre := 'Tomás';
  regM.apellido := 'Lopez';
  write(archMaestro, regM);

  close(archMaestro);

  // Crear archivo detalle 6junio2017.dat
  assign(archDetalle, PATH + '6junio2017.dat');
  rewrite(archDetalle);

  regD.numero_usuario := 101;
  regD.cuenta_destino := 999;
  regD.cuerpo := 'Hola Lucas!';
  write(archDetalle, regD);

  regD.numero_usuario := 101;
  regD.cuenta_destino := 888;
  regD.cuerpo := 'Reunión mañana';
  write(archDetalle, regD);

  regD.numero_usuario := 102;
  regD.cuenta_destino := 777;
  regD.cuerpo := 'Reporte de ventas';
  write(archDetalle, regD);

  regD.numero_usuario := 104;
  regD.cuenta_destino := 666;
  regD.cuerpo := 'Recordatorio de evento';
  write(archDetalle, regD);

  regD.numero_usuario := 104;
  regD.cuenta_destino := 555;
  regD.cuerpo := 'Cambio de horario';
  write(archDetalle, regD);

  regD.numero_usuario := 104;
  regD.cuenta_destino := 444;
  regD.cuerpo := 'Reunión cancelada';
  write(archDetalle, regD);

  regD.numero_usuario := 105;
  regD.cuenta_destino := 333;
  regD.cuerpo := 'Bienvenido al sistema';
  write(archDetalle, regD);

  close(archDetalle);

  writeln('Archivos logsmall.dat y 6junio2017.dat generados correctamente.');
end.
