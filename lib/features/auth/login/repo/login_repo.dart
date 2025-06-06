import 'dart:convert';
import 'package:zurex_admin/main_models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import '../../../../app/core/app_storage_keys.dart';
import '../../../../data/api/end_points.dart';
import '../../../../data/error/api_error_handler.dart';
import '../../../../data/error/failures.dart';
import '../../../../main_repos/base_repo.dart';

class LoginRepo extends BaseRepo {
  LoginRepo({required super.sharedPreferences, required super.dioClient});

  saveUserData(json) {
    if (!kDebugMode) {
      subscribeToTopic(id: "${json["id"]}", userType: json["type"]);
    }
    sharedPreferences.setString(AppStorageKey.userId, "${json["id"]}");
    sharedPreferences.setString(AppStorageKey.userData, jsonEncode(json));
    sharedPreferences.setBool(AppStorageKey.isLogin, true);
  }

  saveUserToken(token) {
    sharedPreferences.setString(AppStorageKey.token, token);
    dioClient.updateHeader(token);
  }

  Future subscribeToTopic(
      {required String id, required String userType}) async {
    FirebaseMessaging.instance
        .subscribeToTopic(EndPoints.specificTopic(id))
        .then((v) async {
      FirebaseMessaging.instance
          .subscribeToTopic("${EndPoints.isProductionEnv ? "" : "t_"}$userType")
          .then((v) async {
        await sharedPreferences.setBool(AppStorageKey.isSubscribe, true);
      });
    });
  }

  saveCredentials(credentials) {
    sharedPreferences.setString(
        AppStorageKey.credentials, jsonEncode(credentials));
  }

  getCredentials() {
    if (sharedPreferences.containsKey(AppStorageKey.credentials)) {
      return jsonDecode(sharedPreferences.getString(
            AppStorageKey.credentials,
          ) ??
          "{}");
    }
  }

  forgetCredentials() {
    sharedPreferences.remove(AppStorageKey.credentials);
  }

  Future<Either<ServerFailure, Response>> logIn(
      {required Map<String, dynamic> data}) async {
    try {
      Response response = await dioClient.post(
          uri: EndPoints.logIn, data: FormData.fromMap(data));

      if (response.statusCode == 200) {
        if (response.data['data'] != null &&
            response.data['data']["user"] != null &&
            response.data['data']["token"] != null) {
          saveUserData(response.data["data"]["user"]);
          saveUserToken(response.data['data']["token"]);
        }
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }

  guestMode() {
    UserModel user = UserModel();
    sharedPreferences.setString(
        AppStorageKey.userData, jsonEncode(user.toJson()));
  }
}
