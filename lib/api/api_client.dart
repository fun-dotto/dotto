import 'package:dio/dio.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';

enum Environment {
  development,
  staging,
  qa,
  production;

  String get basePath => switch (this) {
    Environment.development =>
      'https://app-bff-api-dev-107577467292.asia-northeast1.run.app',
    Environment.staging =>
      'https://app-bff-api-stg-107577467292.asia-northeast1.run.app',
    Environment.qa =>
      'https://app-bff-api-qa-107577467292.asia-northeast1.run.app',
    Environment.production =>
      'https://app-bff-api-107577467292.asia-northeast1.run.app',
  };
}

final environmentProvider = Provider<Environment>(
  (ref) => Environment.production,
);

final apiClientProvider = Provider<Openapi>(
  (ref) => Openapi(
    basePathOverride: ref.read(environmentProvider).basePath,
    interceptors: [
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final appCheckToken = await FirebaseAppCheck.instance.getToken();
          if (appCheckToken != null) {
            options.headers['X-Firebase-AppCheck'] = 'Bearer $appCheckToken';
          }
          final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
          if (idToken != null) {
            options.headers['Authorization'] = 'Bearer $idToken';
          }
          return handler.next(options);
        },
      ),
    ],
  ),
);
