import 'package:hive/hive.dart';

part 'work_session_model.g.dart'; // Run `flutter pub run build_runner build` to generate this file

@HiveType(typeId: 1)
class WorkSessionModel {
  @HiveField(0)
  final int workFrom;

  @HiveField(1)
  final int workTo;

  @HiveField(2)
  // In minutes
  final int breakDuration;

  @HiveField(3)
  // In minutes
  final int breakOccurrence;

  WorkSessionModel( 
      {required this.workFrom,
      required this.workTo,
      required this.breakDuration,
      required this.breakOccurrence});
}
