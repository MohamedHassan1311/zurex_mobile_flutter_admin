import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zurex_admin/components/custom_simple_dialog.dart';
import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../data/error/failures.dart';
import '../../../../main_blocs/user_bloc.dart';
import '../../../../navigation/custom_navigation.dart';
import '../../../../navigation/routes.dart';
import '../../activation_account/view/activation_dialog.dart';
import '../repo/login_repo.dart';

class LoginBloc extends Bloc<AppEvent, AppState> {
  final rememberMe = BehaviorSubject<bool?>();

  final LoginRepo repo;
  LoginBloc({required this.repo}) : super(Start()) {
    updateRememberMe(false);
    updateUserType(UserType.driver);

    on<Add>(onAdd);
    on<Click>(onClick);
    on<Remember>(onRemember);
  }

  final formKey = GlobalKey<FormState>();
  final FocusNode phoneNode = FocusNode();
  final FocusNode passwordNode = FocusNode();

  TextEditingController phoneTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();

  final userType = BehaviorSubject<UserType>();
  Function(UserType) get updateUserType => userType.sink.add;
  Stream<UserType> get userTypeStream => userType.stream.asBroadcastStream();

  Function(bool?) get updateRememberMe => rememberMe.sink.add;
  Stream<bool?> get rememberMeStream => rememberMe.stream.asBroadcastStream();

  clear() {
    phoneTEC.clear();
    passwordTEC.clear();
    updateUserType(UserType.driver);
    updateRememberMe(false);
  }

  @override
  Future<void> close() {
    updateRememberMe(false);
    return super.close();
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      Map<String, dynamic> data = {
        "phone_number": phoneTEC.text.trim(),
        "password": passwordTEC.text.trim(),
      };

      Either<ServerFailure, Response> response =
          await repo.logIn(data: data, userType: userType.valueOrNull!.name);

      response.fold((fail) {
        if (fail.statusCode == 406) {
          CustomSimpleDialog.parentSimpleDialog(
            canDismiss: false,
            withContentPadding: false,
            customWidget: ActivationDialog(phone: phoneTEC.text.trim()),
          );
        } else {
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: getTranslated("invalid_credentials"),
                  isFloating: true,
                  backgroundColor: Styles.IN_ACTIVE,
                  borderColor: Colors.transparent));
        }

        emit(Error());
      }, (success) async {
        if (rememberMe.valueOrNull == true) {
          await repo.saveCredentials(data);
        } else {
          await repo.forgetCredentials();
        }
        CustomNavigator.push(Routes.dashboard, clean: true, arguments: 0);
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

  Future<void> onRemember(Remember event, Emitter<AppState> emit) async {
    Map<String, dynamic>? data = repo.getCredentials();
    if (data != null) {
      passwordTEC.text = data["password"];
      phoneTEC.text = data["phone"];
      updateRememberMe(data["phone"] != "" && data["password"] != null);
      emit(Done());
    }
  }

  Future<void> onAdd(Add event, Emitter<AppState> emit) async {
    repo.guestMode();
    CustomNavigator.push(Routes.dashboard, clean: true, arguments: 0);
  }
}
