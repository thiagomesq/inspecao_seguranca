import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum UserType {
  master('master', 'Master'),
  admin('admin', 'Admin'),
  user('user', 'Usuário');

  final String value;
  final String label;

  const UserType(this.value, this.label);
}
