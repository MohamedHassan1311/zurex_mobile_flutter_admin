import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zurex_admin/features/order_details/model/order_details_model.dart';
import '../../../data/api/end_points.dart';
import '../../../data/error/api_error_handler.dart';
import '../../../data/error/failures.dart';
import '../../../main_repos/base_repo.dart';

class CancelOrderRepo extends BaseRepo {
  CancelOrderRepo({required super.dioClient, required super.sharedPreferences});

  Future<Either<ServerFailure, Response>> getCancellationReasons() async {
    try {
      Response response = await dioClient.get(uri: EndPoints.cancelReasons);
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }

  Future<Either<ServerFailure, Response>> cancelRequest(
      {required int id, int? reasonId}) async {
    try {
      Response response = await dioClient.put(
          uri: EndPoints.changeOrderStatus(id),
          data: {
            "status": OrderStatus.cancelled.name,
            "reason_id": reasonId,
            "reason": ""
          });
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
