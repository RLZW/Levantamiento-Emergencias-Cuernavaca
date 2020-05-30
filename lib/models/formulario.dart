class Formulario {
  String numReporte,
      fecha,
      horaSalida,
      horaArribo,
      direccion,
      colonia,
      tipoFenomeno,
      tipoServicio,
      departamento,
      numeroUnidad,
      reporteProblematica,
      nombreQuienReporta,
      observaciones,
      foto,
      ubicacion,
      delegacion,
      posicionX,
      posicionY;

  Formulario([
    this.numReporte,
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
    this.ubicacion,
  ]);

  Map<String, dynamic> toJson() => {};
}
