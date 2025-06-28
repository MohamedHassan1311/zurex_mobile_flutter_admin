import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zurex_admin/features/change_status/entity/order_status_entity.dart';
import '../../../data/api/end_points.dart';
import '../../../data/error/api_error_handler.dart';
import '../../../data/error/failures.dart';
import '../../../main_repos/base_repo.dart';

class ChangeStatusRepo extends BaseRepo {
  ChangeStatusRepo(
      {required super.dioClient, required super.sharedPreferences});

  Future<Either<ServerFailure, Response>> changeOrderStatus(
      OrderStatusEntity entity) async {
    try {
      Response response = await dioClient.put(
        uri: EndPoints.changeOrderStatus(entity.id),
        data: entity.toJson(),
      );
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }

  Future<Either<ServerFailure, Response>> changeTeamStatus(
      Map<String, dynamic> data) async {
    try {
      Response response = await dioClient.post(
        uri: EndPoints.changeTeamStatus(data["id"]),
        data: {"team_status": data["team_status"]},
      );
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }
}
