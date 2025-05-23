import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zurex_admin/features/change_status/repo/change_status_repo.dart';
import '../../app/theme/theme_provider/theme_provider.dart';
import '../../features/auth/activation_account/repo/activation_account_repo.dart';
import '../../features/auth/deactivate_account/repo/deactivate_account_repo.dart';
import '../../features/auth/forget_password/repo/forget_password_repo.dart';
import '../../features/auth/login/repo/login_repo.dart';
import '../../features/auth/logout/bloc/logout_bloc.dart';
import '../../features/auth/logout/repo/logout_repo.dart';
import '../../features/auth/reset_password/repo/reset_password_repo.dart';
import '../../features/auth/verification/repo/verification_repo.dart';
import '../../features/chat/repo/chat_repo.dart';
import '../../features/chats/bloc/chats_bloc.dart';
import '../../features/chats/repo/chats_repo.dart';
import '../../features/change_password/repo/change_password_repo.dart';
import '../../features/edit_profile/repo/edit_profile_repo.dart';
import '../../features/faqs/repo/faqs_repo.dart';
import '../../features/order_details/repo/order_details_repo.dart';
import '../../features/orders/bloc/orders_bloc.dart';
import '../../features/orders/repo/orders_repo.dart';
import '../../features/who_us/repo/who_us_repo.dart';
import '../../main_blocs/country_states_bloc.dart';
import '../../main_repos/country_states_repo.dart';
import '../../features/language/bloc/language_bloc.dart';
import '../../features/language/repo/language_repo.dart';
import '../../features/maps/repo/maps_repo.dart';
import '../../features/notifications/repo/notifications_repo.dart';
import '../../features/profile/bloc/profile_bloc.dart';
import '../../features/profile/repo/profile_repo.dart';
import '../../features/setting/bloc/setting_bloc.dart';
import '../../features/setting/repo/setting_repo.dart';
import '../../features/contact_with_us/repo/contact_with_us_repo.dart';
import '../../helpers/pickers/repo/picker_helper_repo.dart';
import '../../main_blocs/user_bloc.dart';
import '../../main_page/bloc/dashboard_bloc.dart';
import '../../main_repos/download_repo.dart';
import '../../main_repos/user_repo.dart';
import '../api/end_points.dart';
import '../internet_connection/internet_connection.dart';
import '../local_data/local_database.dart';
import '../dio/dio_client.dart';
import '../dio/logging_interceptor.dart';
import '../../features/splash/repo/splash_repo.dart';
import '../securty/secure_storage.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => LocaleDatabase());
  sl.registerLazySingleton(() => DioClient(
        EndPoints.baseUrl,
        dio: sl(),
        loggingInterceptor: sl(),
        sharedPreferences: sl(),
      ));
  sl.registerLazySingleton(() => InternetConnection(connectivity: sl()));

  /// Repository
  sl.registerLazySingleton(
      () => LocalizationRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => SettingRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => FaqsRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => WhoUsRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(() => DownloadRepo());

  sl.registerLazySingleton(
      () => CountryStatesRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => PickerHelperRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => SplashRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => UserRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => LoginRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => VerificationRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ForgetPasswordRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ResetPasswordRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ChangePasswordRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => LogoutRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ActivationAccountRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ProfileRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => EditProfileRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => MapsRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => DeactivateAccountRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => NotificationsRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ChatsRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ChatRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ContactWithUsRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => OrdersRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => OrderDetailsRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ChangeStatusRepo(sharedPreferences: sl(), dioClient: sl()));


  //provider
  sl.registerLazySingleton(() => LanguageBloc(repo: sl()));
  sl.registerLazySingleton(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerLazySingleton(() => CountryStatesBloc(repo: sl()));
  sl.registerLazySingleton(() => SettingBloc(repo: sl()));
  sl.registerLazySingleton(() => DashboardBloc());
  sl.registerLazySingleton(() => ProfileBloc(repo: sl()));
  sl.registerLazySingleton(() => UserBloc(repo: sl()));sl.registerLazySingleton(
      () => OrdersBloc(repo: sl(), internetConnection: sl()));
  sl.registerLazySingleton(() => ChatsBloc(repo: sl()));

  ///Log out
  sl.registerLazySingleton(() => LogoutBloc(repo: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => SecureStorage(flutterSecureStorage: sl()));
  sl.registerLazySingleton(() => LoggingInterceptor());
}
