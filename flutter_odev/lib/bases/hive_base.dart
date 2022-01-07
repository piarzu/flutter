import 'package:hive/hive.dart';
part "hive_base.g.dart";
@HiveType(typeId: 0)
class HiveUser {
  @HiveField(0)
  String username;
  @HiveField(1)
  String profileUrl;
  @HiveField(2)
  String password;


  HiveUser({required this.username,required this.profileUrl,required this.password});

}