

import 'package:education_systems_mobile/core/utilities/enum.dart';

class StatusTypeEnum extends Enum<int> {
  const StatusTypeEnum(int value) : super(value);

  static const StatusTypeEnum Attendance = const StatusTypeEnum(1);
  static const StatusTypeEnum Present = const StatusTypeEnum(2);
  static const StatusTypeEnum Absent = const StatusTypeEnum(3);
}
