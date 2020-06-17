// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'formulariohive.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FormularioHiveAdapter extends TypeAdapter<FormularioHive> {
  @override
  final typeId = 3;

  @override
  FormularioHive read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FormularioHive(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
      fields[7] as String,
      fields[8] as String,
      fields[9] as String,
      fields[12] as int,
      fields[13] as double,
      fields[14] as double,
      fields[15] as int,
      fields[16] as int,
      fields[17] as int,
      fields[18] as int,
      fields[19] as int,
      (fields[24] as List)?.cast<String>(),
      fields[20] as int,
      fields[21] as int,
      fields[22] as int,
      fields[23] as int,
      fields[10] as String,
      fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FormularioHive obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.numReporte)
      ..writeByte(1)
      ..write(obj.horaSalida)
      ..writeByte(2)
      ..write(obj.horaArribo)
      ..writeByte(3)
      ..write(obj.horaTermino)
      ..writeByte(4)
      ..write(obj.direccion)
      ..writeByte(5)
      ..write(obj.colonia)
      ..writeByte(6)
      ..write(obj.numeroUnidad)
      ..writeByte(7)
      ..write(obj.reporteProblematica)
      ..writeByte(8)
      ..write(obj.nombreQuienReporta)
      ..writeByte(9)
      ..write(obj.observaciones)
      ..writeByte(10)
      ..write(obj.listainspectores)
      ..writeByte(11)
      ..write(obj.listainspectoresbom)
      ..writeByte(12)
      ..write(obj.foto)
      ..writeByte(13)
      ..write(obj.posicionX)
      ..writeByte(14)
      ..write(obj.posicionY)
      ..writeByte(15)
      ..write(obj.delegacion)
      ..writeByte(16)
      ..write(obj.tipoFenomeno)
      ..writeByte(17)
      ..write(obj.tipoServicio)
      ..writeByte(18)
      ..write(obj.departamento)
      ..writeByte(19)
      ..write(obj.fecha)
      ..writeByte(20)
      ..write(obj.levantoreporte)
      ..writeByte(21)
      ..write(obj.levantoreportebom)
      ..writeByte(22)
      ..write(obj.catalogoinspectores)
      ..writeByte(23)
      ..write(obj.catalogoinspectoresbom)
      ..writeByte(24)
      ..write(obj.images);
  }
}
