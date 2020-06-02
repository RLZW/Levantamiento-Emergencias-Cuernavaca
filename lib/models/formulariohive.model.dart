import 'package:hive/hive.dart';
import 'dart:io';

part 'formulariohive.model.g.dart';

@HiveType(typeId: 1)
class FormularioHive {
  @HiveField(0)
  String numReporte;
  @HiveField(1)
  String horaSalida;
  @HiveField(2)
  String horaArribo;
  @HiveField(3)
  String direccion;
  @HiveField(4)
  String colonia;
  @HiveField(5)
  String numeroUnidad;
  @HiveField(6)
  String reporteProblematica;
  @HiveField(7)
  String nombreQuienReporta;
  @HiveField(8)
  String observaciones;
  @HiveField(9)
  String foto;
  @HiveField(10)
  String posicionX;
  @HiveField(11)
  String posicionY;
  @HiveField(12)
  int delegacion;
  @HiveField(13)
  int tipoFenomeno;
  @HiveField(14)
  int tipoServicio;
  @HiveField(15)
  int departamento;
  @HiveField(16)
  int fecha;
  @HiveField(17)
  List<String> images;

  FormularioHive(
      [this.numReporte,
      this.fecha,
      this.horaSalida,
      this.horaArribo,
      this.direccion,
      this.delegacion,
      this.colonia,
      this.tipoFenomeno,
      this.tipoServicio,
      this.departamento,
      this.numeroUnidad,
      this.reporteProblematica,
      this.nombreQuienReporta,
      this.observaciones,
      this.foto,
      this.posicionX,
      this.posicionY,
      this.images]);
  Map<String, dynamic> toJson() => {
        "geometry": {
          "x": this.posicionX,
          "y": this.posicionY,
          "spatialReference": {"wkid": 4326}
        },
        "attributes": {
          "TIPOFENOMENO": this.tipoFenomeno,
          "NUMREPORTE": this.numReporte,
          "FECHA": this.fecha,
          "HORA": "24",
          "DIRECCION": this.direccion,
          "COLONIA": this.colonia,
          "DELEGACION": this.delegacion,
          "SERVICIO": this.tipoServicio,
          "DEPARTAMENTO": this.departamento,
          "NUMUNIDAD": this.numeroUnidad,
          "LEVANTOREPORTE": "07",
          "REPORTEPROBLEMATICA": this.reporteProblematica,
          "NOMBREQUIENREPORTA": this.nombreQuienReporta,
          "OBSERVACIONES": this.observaciones,
          "CATALOGONSPECTORES": "02",
          "LISTAINSPECTORES": " Juan José Diaz Flores"
        }
      };
}
