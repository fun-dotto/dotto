import 'package:minio/minio.dart';

class S3Repository {
  static late Minio _s3;
  static late String _bucketName;
  S3Repository._internal() {
    _s3 = Minio(
      endPoint: String.fromEnvironment('CLOUDFLARE_R2_ENDPOINT'),
      accessKey: String.fromEnvironment('CLOUDFLARE_R2_ACCESS_KEY_ID'),
      secretKey: String.fromEnvironment('CLOUDFLARE_R2_SECRET_ACCESS_KEY'),
      useSSL: true,
    );
    _bucketName = String.fromEnvironment('CLOUDFLARE_R2_BUCKET_NAME');
  }
  static final S3Repository _instance = S3Repository._internal();
  factory S3Repository() {
    return _instance;
  }

  static Future<List<String>> getListObjectsKey({required String url}) async {
    List<String> returnStr = [];
    await for (var value in _s3.listObjectsV2(_bucketName, prefix: url, recursive: true)) {
      for (var obj in value.objects) {
        returnStr.add(obj.key!);
      }
    }
    return returnStr;
  }

  static Future<MinioByteStream> getObject({required String url}) async {
    return _s3.getObject(_bucketName, url);
  }
}
