import 'dart:convert';
import 'dart:io';

class Formulario {
  String numReporte,
      horaSalida,
      horaArribo,
      horaTermino,
      direccion,
      colonia,
      numeroUnidad,
      reporteProblematica,
      nombreQuienReporta,
      observaciones,
      listainspectores,
      listainspectoresbom,
      foto,
      posicionX,
      posicionY;
  int delegacion,
      tipoFenomeno,
      tipoServicio,
      departamento,
      fecha,
      levantoreporte, //ID DEL QUE LEVANTO
      levantoreportebom,
      catalogoinspectores, //ID DEL QUE APOYO
      catalogoinspectoresbom;
  List<File> images;

  Formulario(
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
          "x": double.parse(this.posicionX),
          "y": double.parse(this.posicionY),
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

  Map<String, dynamic> toJsonBomberos() => {
        "geometry": {
          "x": double.parse(this.posicionX),
          "y": double.parse(this.posicionY),
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
          "LEVANTOREPORTEBOM": this.levantoreportebom,
          "CATALOGONSPECTORESBOMB": this.catalogoinspectoresbom,
          "NUMUNIDAD": this.numeroUnidad,
          "REPORTEPROBLEMATICA": this.reporteProblematica,
          "NOMBREQUIENREPORTA": this.nombreQuienReporta,
          "OBSERVACIONES": this.observaciones,
          "LISTAINSPECTORESBOMB": this.listainspectoresbom,
        }
      };
}
