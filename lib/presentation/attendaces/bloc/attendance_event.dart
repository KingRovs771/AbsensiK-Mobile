import 'package:image_picker/image_picker.dart';

abstract class AttendanceEvent {}

class FetchAttendanceData extends AttendanceEvent {}

class ClockInButtonPressed extends AttendanceEvent {
  final XFile photo;
  ClockInButtonPressed({required this.photo});
}

class ClockOutButtonPressed extends AttendanceEvent {}
