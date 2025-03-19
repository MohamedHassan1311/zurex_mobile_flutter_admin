import '../../../data/config/mapper.dart';

class CancelReasonsModel extends SingleMapper {
  String? message;
  int? statusCode;
  List<CancelReasonModel>? data;

  CancelReasonsModel({
    this.message,
    this.statusCode,
    this.data,
  });

  @override
  Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
        "data": data != null
            ? List<dynamic>.from(data!.map((x) => x.toJson()))
            : [],
      };

  CancelReasonsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['status_code'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(CancelReasonModel.fromJson(v));
      });
    }
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return CancelReasonsModel.fromJson(json);
  }
}

class CancelReasonModel extends SingleMapper {
  int? id;
  String? reason;

  CancelReasonModel({
    this.id,
    this.reason,
  });

  CancelReasonModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    reason = json["reason"];
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "reason": reason,
      };

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return CancelReasonModel.fromJson(json);
  }
}
