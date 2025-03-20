import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../data/error/failures.dart';
import '../../../../navigation/custom_navigation.dart';
import '../../../../navigation/routes.dart';
import '../model/verification_model.dart';
import '../repo/verification_repo.dart';

class VerificationBloc extends Bloc<AppEvent, AppState> {
  final VerificationRepo repo;
  VerificationBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
    on<Resend>(onResend);
  }

  TextEditingController codeTEC = TextEditingController();

  clear() {
    codeTEC.clear();
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      VerificationModel data = event.arguments as VerificationModel;
      data.code = codeTEC.text.trim();

      Either<ServerFailure, Response> response = await repo.verifyAccount(data);

      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.red));
        emit(Error());
      }, (success) {
        AppCore.showSnackBar(
          notification: AppNotification(
            message: success.data["message"],
            backgroundColor: Styles.ACTIVE,
            borderColor: Styles.ACTIVE,
          ),
        );
        CustomNavigator.push(Routes.resetPassword, arguments: data);

        clear();
        emit(Done());
      });
    } catch (e) {
      AppCore.showSnackBar(
        notification: AppNotification(
          message: e.toString(),
          backgroundColor: Styles.IN_ACTIVE,
          borderColor: Styles.RED_COLOR,
        ),
      );
      emit(Error());
    }
  }

  Future<void> onResend(Resend event, Emitter<AppState> emit) async {
    await repo.resendCode(event.arguments as VerificationModel);
  }
}
