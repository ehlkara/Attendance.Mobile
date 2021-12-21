

import 'package:education_systems_mobile/core/utilities/enum.dart';

class UserTypeEnum extends Enum<int> {
  const UserTypeEnum(int value) : super(value);

  static const UserTypeEnum Student = const UserTypeEnum(1);
  static const UserTypeEnum Professor = const UserTypeEnum(2);
}
