import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex/features/maps/models/location_model.dart';
import 'package:zurex/features/maps/repo/maps_repo.dart';

import '../../../app/core/app_core.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_notification.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/loading_dialog.dart';
import '../../../data/error/failures.dart';
import '../../../navigation/custom_navigation.dart';

class CheckOnZoneBloc extends Bloc<AppEvent, AppState> {
  final MapsRepo repo;

  CheckOnZoneBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      loadingDialog();

      LocationModel model = (event.arguments as LocationModel);
      Either<ServerFailure, Response> response =
          await repo.checkOnZone((event.arguments as LocationModel));
      CustomNavigator.pop();
      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.red));
        emit(Error());
      }, (success) {
        model.copyWith(addressId: success.data["data"]["address"]["id"]);
        model.onChange?.call(model);
        log("==>model ${model.toJson()}");
        emit(Done());
        AppCore.showSnackBar(
            notification: AppNotification(
          message: getTranslated("location_picked_successfully"),
          backgroundColor: Styles.ACTIVE,
          borderColor: Styles.ACTIVE,
        ));
      });
    } catch (e) {
      CustomNavigator.pop();
      AppCore.showSnackBar(
          notification: AppNotification(
        message: e.toString(),
        backgroundColor: Styles.IN_ACTIVE,
        borderColor: Styles.RED_COLOR,
      ));
      emit(Error());
    }
  }
}
