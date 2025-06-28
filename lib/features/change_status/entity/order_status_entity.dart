import 'package:zurex_admin/features/order_details/model/order_details_model.dart';
import 'package:zurex_admin/features/team_details/model/team_model.dart';

class OrderStatusEntity {
  int? id;
  StatusModel? status;
  TeamModel? team;

  OrderStatusEntity({
    this.status,
    this.team,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status?.statusCode;
    if (team != null) data['team_id'] = team?.id;
    return data;
  }

  OrderStatusEntity copyWith({
    int? id,
    StatusModel? status,
    TeamModel? team,
  }) {
    this.id = id ?? this.id;
    this.status = status ?? this.status;
    this.team = team ?? this.team;
    return this;
  }
}
