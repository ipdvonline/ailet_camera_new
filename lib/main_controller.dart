import 'package:activity_getmx/activity.dart';
import 'package:activity_getmx/android_intent.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  static const MethodChannel _channel = MethodChannel('ailet_integration');

  RxString message = ''.obs;

  Future<Map<String, dynamic>?> startVisit({
    required String login,
    required String password,
    required String userId,
    required String visitId,
    required String storeId,
  }) async {
    final Map<String, dynamic>? result = await _channel.invokeMethod(
      'startVisit',
      {
        'login': login,
        'password': password,
        'userId': userId,
        'visitId': visitId,
        'storeId': storeId,
      },
    );
    return result;
  }

  Future<Map<String, dynamic>?> getVisitReport({
    required String login,
    required String password,
    required String userId,
    required String visitId,
  }) async {
    final Map<String, dynamic>? result =
        await _channel.invokeMethod('getVisitReport', {
      'login': login,
      'password': password,
      'userId': userId,
      'visitId': visitId,
    });
    return result;
  }

  Future<void> startCameraChannel({
    required String login,
    required String password,
    required String storeId,
    required String visitId,
    String? userId,
    Function(dynamic)? result,
  }) async {
    /* AILET IOS*/
    if (GetPlatform.isIOS) {}

    if (GetPlatform.isAndroid) {
      try {
        final _result = await startVisit(
          login: login,
          password: password,
          userId: userId!,
          visitId: visitId,
          storeId: storeId,
        );

        message.value = _result.toString();

        print('_result=> $_result');
      } on PlatformException catch (erro) {
        message.value = erro.toString();
        print('erro=> ${erro.toString()}');
      }
    }
  }

  Future<void> startCameraPlugin({
    required String login,
    required String password,
    required String storeId,
    required String visitId,
    String? userId,
    Function(dynamic)? result,
  }) async {
    /* AILET IOS*/
    if (GetPlatform.isIOS) {}

    if (GetPlatform.isAndroid) {
      try {
        final activityPlugin = Activity();

        final intent = AndroidIntent(
          //action: 'com.intrtl.app.ACTION_VISIT',
          action: 'com.ailet.ACTION_VISIT',
          package: 'com.ailet.global',
          flags: [],
          arguments: {
            'login': login,
            'password': password,
            'visit_id': visitId,
            'store_id': storeId
          },
        );

        final result = await activityPlugin.startActivityForResult(intent);

        message.value = result.toString();

        print('result=> $result');
      } on PlatformException catch (erro) {
        message.value = erro.toString();
        print('erro=> ${erro.toString()}');
      }
    }
  }

  @override
  void onInit() {
    print('Camera Ailet iniciado');
    super.onInit();
  }

  @override
  void onClose() {
    print('Camera Ailet finalizado');
    super.onClose();
  }
}
