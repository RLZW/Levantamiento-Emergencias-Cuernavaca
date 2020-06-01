import 'dart:io';
import 'package:hive/hive.dart';

class Formulario {
  String numReporte,
      horaSalida,
      horaArribo,
      direccion,
      colonia,
      numeroUnidad,
      reporteProblematica,
      nombreQuienReporta,
      observaciones,
      foto,
      posicionX,
      posicionY;
  int delegacion, tipoFenomeno, tipoServicio, departamento, fecha;
  List<File> images;

  Formulario(
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
  Map<String, dynamic> toJsonExtended() => {
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
        },
        "images": this.images,
      };
}
