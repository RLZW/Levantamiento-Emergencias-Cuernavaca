// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'formulariohive.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FormularioHiveAdapter extends TypeAdapter<FormularioHive> {
  @override
  final typeId = 1;

  @override
  FormularioHive read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FormularioHive(
      fields[0] as String,
      fields[16] as int,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[12] as int,
      fields[4] as String,
      fields[13] as int,
      fields[14] as int,
      fields[15] as int,
      fields[5] as String,
      fields[6] as String,
      fields[7] as String,
      fields[8] as String,
      fields[9] as String,
      fields[10] as String,
      fields[11] as String,
      (fields[17] as List)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, FormularioHive obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.numReporte)
      ..writeByte(1)
      ..write(obj.horaSalida)
      ..writeByte(2)
      ..write(obj.horaArribo)
      ..writeByte(3)
      ..write(obj.direccion)
      ..writeByte(4)
      ..write(obj.colonia)
      ..writeByte(5)
      ..write(obj.numeroUnidad)
      ..writeByte(6)
      ..write(obj.reporteProblematica)
      ..writeByte(7)
      ..write(obj.nombreQuienReporta)
      ..writeByte(8)
      ..write(obj.observaciones)
      ..writeByte(9)
      ..write(obj.foto)
      ..writeByte(10)
      ..write(obj.posicionX)
      ..writeByte(11)
      ..write(obj.posicionY)
      ..writeByte(12)
      ..write(obj.delegacion)
      ..writeByte(13)
      ..write(obj.tipoFenomeno)
      ..writeByte(14)
      ..write(obj.tipoServicio)
      ..writeByte(15)
      ..write(obj.departamento)
      ..writeByte(16)
      ..write(obj.fecha)
      ..writeByte(17)
      ..write(obj.images);
  }
}
