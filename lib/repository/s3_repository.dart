import 'package:dotto/controller/config_controller.dart';
import 'package:minio/minio.dart';

class S3Repository {
  factory S3Repository() {
    return _instance;
  }
  S3Repository._internal() {
    _s3 = Minio(
      endPoint: ConfigState.cloudflareR2Endpoint,
      accessKey: ConfigState.cloudflareR2AccessKeyId,
      secretKey: ConfigState.cloudflareR2SecretAccessKey,
    );
    _bucketName = ConfigState.cloudflareR2BucketName;
  }
  static late Minio _s3;
  static late String _bucketName;
  static final S3Repository _instance = S3Repository._internal();

  static Future<List<String>> getListObjectsKey({required String url}) async {
    final returnStr = <String>[];
    await for (final value in _s3.listObjectsV2(_bucketName, prefix: url, recursive: true)) {
      for (final obj in value.objects) {
        returnStr.add(obj.key!);
      }
    }
    return returnStr;
  }

  static Future<MinioByteStream> getObject({required String url}) async {
    return _s3.getObject(_bucketName, url);
  }
}
