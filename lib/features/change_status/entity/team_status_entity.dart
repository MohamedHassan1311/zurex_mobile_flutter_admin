import 'package:zurex_admin/features/team_details/model/team_model.dart';

class TeamStatusEntity {
  int? id;
  TeamStatus? status;

  TeamStatusEntity({
    this.id,
    this.status,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status?.name;
    return data;
  }

  TeamStatusEntity copyWith({
    int? id,
    TeamStatus? status,
  }) {
    this.id = id ?? this.id;
    this.status = status ?? this.status;
    return this;
  }
}
