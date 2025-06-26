import 'package:zurex_admin/main_models/user_model.dart';

import '../../../data/config/mapper.dart';
import '../../../main_models/meta.dart';
import '../../team_details/model/team_model.dart';

class OrdersModel extends SingleMapper {
  String? message;
  int? statusCode;
  List<TeamModel>? data;
  Meta? meta;

  OrdersModel({
    this.message,
    this.statusCode,
    this.data,
    this.meta,
  });

  @override
  Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
        "pagination": meta?.toJson(),
        "data": data != null
            ? List<dynamic>.from(data!.map((x) => x.toJson()))
            : [],
      };

  OrdersModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['status_code'];
    meta =
        json['pagination'] != null ? Meta.fromJson(json['pagination']) : null;

    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(TeamModel.fromJson(v));
      });
    }
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return OrdersModel.fromJson(json);
  }
}

