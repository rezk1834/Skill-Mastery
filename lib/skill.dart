import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Skill {
  @HiveField(0)
  String name;
  @HiveField(1)
  int hoursSpent;
  @HiveField(2)
  int minutesSpent;
  @HiveField(3)
  int colorValue;
  @HiveField(4)
  DateTime startDate;
  @HiveField(5)
  String notes;
  @HiveField(6)
  int key;

  Skill(this.name, this.hoursSpent, this.minutesSpent, this.colorValue, this.startDate, this.notes, this.key);
}

@HiveType(typeId: 0)
class SkillAdapter extends TypeAdapter<Skill> {
  @override
  final typeId = 0;

  @override
  Skill read(BinaryReader reader) {
    return Skill(
      reader.readString(),
      reader.readInt(),
      reader.readInt(),
      reader.readInt(),
      reader.read() as DateTime,
      reader.readString(),
      reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, Skill obj) {
    writer.writeString(obj.name);
    writer.writeInt(obj.hoursSpent);
    writer.writeInt(obj.minutesSpent);
    writer.writeInt(obj.colorValue);
    writer.write(obj.startDate);
    writer.writeString(obj.notes);
    writer.writeInt(obj.key);
  }
}
