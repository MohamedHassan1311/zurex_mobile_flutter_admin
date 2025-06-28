import 'package:zurex_admin/main_models/user_model.dart';

import '../../../data/config/mapper.dart';


class TeamModel extends SingleMapper {
  int? id;
  String? name;
  int? numOfOrders;
  int? numOfOrdersAccepted;
  int? numOfOrdersCancelled;
  int? numOfOrdersDelivered;
  int? numOfOrdersOutForDelivery;
  int? numOfOrdersProcessing;
  int? numOfOrdersPending;
  int? numOfOrdersPaidFailed;
  String? zone;
  List<UserModel>? supervisor;
  List<UserModel>? driver;
  List<UserModel>? members;

  TeamModel(
      {this.id,
      this.name,
      this.numOfOrders,
      this.numOfOrdersAccepted,
      this.numOfOrdersCancelled,
      this.numOfOrdersDelivered,
      this.numOfOrdersOutForDelivery,
      this.numOfOrdersProcessing,
      this.numOfOrdersPending,
      this.numOfOrdersPaidFailed,
      this.zone,
      this.supervisor,
      this.driver,
      this.members});

  TeamModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    numOfOrders = json['num_of_orders'];
    numOfOrdersAccepted = json['num_of_orders_accepted'];
    numOfOrdersCancelled = json['num_of_orders_cancelled'];
    numOfOrdersDelivered = json['num_of_orders_delivered'];
    numOfOrdersOutForDelivery = json['num_of_orders_out_for_delivery'];
    numOfOrdersProcessing = json['num_of_orders_processing'];
    numOfOrdersPending = json['num_of_orders_pending'];
    numOfOrdersPaidFailed = json['num_of_orders_paid_failed'];
    zone = json['zone'];
    if (json['supervisor'] != null) {
      supervisor = [];
      json['supervisor'].forEach((v) {
        supervisor!.add(UserModel.fromJson(v));
      });
    }
    if (json['driver'] != null) {
      driver = <UserModel>[];
      json['driver'].forEach((v) {
        driver!.add(UserModel.fromJson(v));
      });
    }
    if (json['members'] != null) {
      members = [];
      json['members'].forEach((v) {
        members!.add(UserModel.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['num_of_orders'] = numOfOrders;
    data['num_of_orders_accepted'] = numOfOrdersAccepted;
    data['num_of_orders_cancelled'] = numOfOrdersCancelled;
    data['num_of_orders_delivered'] = numOfOrdersDelivered;
    data['num_of_orders_out_for_delivery'] = numOfOrdersOutForDelivery;
    data['num_of_orders_processing'] = numOfOrdersProcessing;
    data['num_of_orders_pending'] = numOfOrdersPending;
    data['num_of_orders_paid_failed'] = numOfOrdersPaidFailed;
    data['zone'] = zone;
    if (supervisor != null) {
      data['supervisor'] = supervisor!.map((v) => v.toJson()).toList();
    }
    if (driver != null) {
      data['driver'] = driver!.map((v) => v.toJson()).toList();
    }
    if (members != null) {
      data['members'] = members!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return TeamModel.fromJson(json);
  }
}

enum TeamStatus{pending, picked_up, arrived_start_work, delivered}
