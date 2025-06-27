import 'package:zurex_admin/data/config/mapper.dart';
import 'package:zurex_admin/main_blocs/user_bloc.dart';
import 'package:zurex_admin/main_models/custom_field_model.dart';

class UserModel extends SingleMapper {
  int? id;
  String? name;
  String? profileImage;
  String? countryCode;
  String? phone;
  String? email;
  UserType? userType;
  double? balance;
  CustomFieldModel? team;

  UserModel({
    this.id,
    this.name,
    this.profileImage,
    this.balance,
    this.countryCode,
    this.phone,
    this.email,
    this.userType,
    this.team,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    balance = json['balance'] != null
        ? double.parse(json["balance"]?.toString() ?? "0")
        : null;
    team =
        json['team'] != null ? CustomFieldModel.fromJson(json["team"]) : null;
    profileImage = json['profile_image'];
    countryCode = json['country_code'];
    phone = json['phone_number'];
    email = json['email'];
    userType = UserType.values.firstWhere(
        (e) => e.name.toUpperCase() == json['type'].toString().toUpperCase());
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['balance'] = balance;
    data['profile_image'] = profileImage;
    data['phone_number'] = phone;
    data['email'] = email;
    data['type'] = userType?.name;
    data['team'] = team?.toJson();

    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return UserModel.fromJson(json);
  }
}
