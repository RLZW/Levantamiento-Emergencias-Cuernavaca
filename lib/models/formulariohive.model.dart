import 'package:hive/hive.dart';
import 'dart:io';

part 'formulariohive.model.g.dart';

@HiveType(typeId: 3)
class FormularioHive {
  @HiveField(0)
  String numReporte;
  @HiveField(1)
  String horaSalida;
  @HiveField(2)
  String horaArribo;
  @HiveField(3)
  String horaTermino;
  @HiveField(4)
  String direccion;
  @HiveField(5)
  String colonia;
  @HiveField(6)
  String numeroUnidad;
  @HiveField(7)
  String reporteProblematica;
  @HiveField(8)
  String nombreQuienReporta;
  @HiveField(9)
  String observaciones;
  @HiveField(10)
  String listainspectores;
  @HiveField(11)
  String listainspectoresbom;
  @HiveField(12)
  int foto;
  @HiveField(13)
  double posicionX;
  @HiveField(14)
  double posicionY;
  @HiveField(15)
  int delegacion;
  @HiveField(16)
  int tipoFenomeno;
  @HiveField(17)
  int tipoServicio;
  @HiveField(18)
  int departamento;
  @HiveField(19)
  int fecha;
  @HiveField(20)
  int levantoreporte;
  @HiveField(21)
  int levantoreportebom;
  @HiveField(22)
  int catalogoinspectores;
  @HiveField(23)
  int catalogoinspectoresbom;
  @HiveField(24)
  List<String> images;

  FormularioHive(
    this.numReporte,
    this.horaSalida,
    this.horaArribo,
    this.horaTermino,
    this.direccion,
    this.colonia,
    this.numeroUnidad,
    this.reporteProblematica,
    this.nombreQuienReporta,
    this.observaciones,
    this.foto,
    this.posicionX,
    this.posicionY,
    this.delegacion,
    this.tipoFenomeno,
    this.tipoServicio,
    this.departamento,
    this.fecha,
    this.images, [
    this.levantoreporte, //NORMAL
    this.levantoreportebom,
    this.catalogoinspectores, //APYO
    this.catalogoinspectoresbom,
    this.listainspectores, //STRING
    this.listainspectoresbom,
  ]);
  Map<String, dynamic> toJson() => {
        "geometry": {
          "x": double.parse(this.posicionX.toString()),
          "y": double.parse(this.posicionY.toString()),
          "spatialReference": {"wkid": 4326}
        },
        "attributes": {
          "NUMREPORTE": this.numReporte, //NUMREPORTE
          "FECHA": this.fecha, //FECHA
          "HORASALIDAUNIDAD": this.horaSalida, //HORASALIDA
          "HORAARRIBO": this.horaArribo,
          "HORATERMINO": this.horaTermino, //
          "DIRECCION": this.direccion,
          "COLONIA": this.colonia,
          "DELEGACION": this.delegacion,
          "TIPOFENOMENO": this.tipoServicio,
          "SERVICIO": this.tipoServicio,
          "DEPARTAMENTO": this.departamento,
           "LEVANTOREPORTE": (this.levantoreporte != null) ? '0'+this.levantoreporte.toString() : null ,
          "LEVANTOREPORTEBOM": (this.levantoreportebom != null) ? '0'+this.levantoreportebom.toString() : null,
          "CATALOGONSPECTORES": (this.catalogoinspectores != null) ? '0'+this.catalogoinspectores.toString() : null,
          "CATALOGONSPECTORESBOMB": (this.catalogoinspectoresbom) != null ? '0'+this.catalogoinspectoresbom.toString() : null,
          "NUMUNIDAD": this.numeroUnidad,
          "REPORTEPROBLEMATICA": this.reporteProblematica,
          "NOMBREQUIENREPORTA": this.nombreQuienReporta,
          "OBSERVACIONES": this.observaciones,
          "LISTAINSPECTORES": this.listainspectores,
          "LISTAINSPECTORESBOMB": this.listainspectoresbom,
        }
      };
}
