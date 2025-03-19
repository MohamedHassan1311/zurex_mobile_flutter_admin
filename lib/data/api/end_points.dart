import 'package:flutter_dotenv/flutter_dotenv.dart';

class EndPoints {
  static String domain = dotenv.env['DOMAIN_DEV'] ?? "";
  static String baseUrl = dotenv.env['BASE_URL_DEV'] ?? "";
  static String apiKey = dotenv.env['API_KEY'] ?? "";
  static chatPort(id) => '${dotenv.env['CHAT_PORT']}$id';
  static String googleMapsBaseUrl = dotenv.env['GOOGLE_MAPS_BASE_URL'] ?? "";
  static const String generalTopic = 'zurex';
  static specificTopic(id) => '$id';

  ///Auth
  static const String socialMediaAuth = 'social-login';
  static const String forgetPassword = 'forgot-password';
  static const String resetPassword = 'reset-password';
  static const String changePassword = 'change-password';
  static const String register = 'register';
  static const String logIn = 'login';
  static const String resend = 'resend-otp';
  static const String verifyOtp = 'verify-otp';
  static const String suspendAccount = 'suspend-account';
  static const String reactivateAccount = 'reactivate-account';

  ///User Profile
  static const String editProfile = 'update-profile';
  static const String profile = 'me';
  static const String bankInfo = 'bank_info';

  ///Home
  static const String banners = 'banners';

  ///Expertises
  static const String myCars = 'user-cars';
  static carDetails(id) => 'user-cars/$id';
  static deleteCar(id) => 'user-cars/$id';
  static const String carType = 'car-types';
  static const String carModel = 'car-models';
  static const String carYear = 'year';

  static const String addCar = 'car-data';
  static const String addCarInfo = 'car-data-info';

  ///Categories && Products
  static const String categories = 'product-categories';
  static const String products = 'products';
  static productDetails(id) => 'products/$id';

  ///Chats
  static const String createChat = 'chats';
  static const String chats = 'chats';
  static deleteChat(id) => 'chats/$id';
  static chatDetails(id) => 'chats/$id';
  static chatMessages(id) => 'chat-messages/$id';
  static const String uploadFile = 'upload-file';

  ///Notification
  static const String notifications = 'notifications';
  static readNotification(id) => 'notifications/$id';
  static deleteNotification(id) => 'notifications/$id';

  ///Cart
  static const String cart = 'get-cart';
  static const String addToCart = 'add-to-cart';
  static const String updateCart = 'update-cart';
  static const String removeFromCart = 'update-cart';
  static const String emptyCart = 'empty-cart';
  static const checkOut = 'check-out';
  static const applyCoupon = 'cart/apply-coupon';
  static const orderSchedule = 'delivery-times/get-delivery-time';
  static const checkOnZone = 'zones/checkIfUserExistInZone';
  static const paymentMethod = 'payment-types';

  ///Orders
  static const String orders = 'orders';
  static orderDetails(id) => 'orders/$id';
  static const String cancelReasons = 'cancel-reason';
  static changeOrderStatus(id) => 'orders/$id/changeOrderStatus';

  ///Transactions
  static const String transactions = 'transactions';
  static const String sendFeedback = 'feedbacks';

  ///Setting
  static const String settings = 'settings';
  static const String faqs = 'faqs';
  static const String whoUs = 'who-us';
  static const String contactUs = 'contact-us';
  static const String countryStates = 'country-states';

  ///Share
  static shareRoute(route, id) => "$baseUrl$route/?id=$id";

  ///Upload File Service
  static const String uploadFileService = 'store_attachment';

  /// maps
  static const String geoCodeUrl = '/maps/api/geocode/';
  static const String autoComplete = '/maps/api/place/autocomplete/';
//https://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&key=AIzaSyB_l2x6zgnLTF4MKxX3S4Df9urLN6vLNP0
//'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=n,&key=AIzaSyB_l2x6zgnLTF4MKxX3S4Df9urLN6vLNP0
}
