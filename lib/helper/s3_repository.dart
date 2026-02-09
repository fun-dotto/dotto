import 'package:dotto/domain/config.dart';
import 'package:minio/minio.dart';
import 'package:minio/models.dart';

final class S3Repository {
  factory S3Repository() {
    return _instance;
  }
  S3Repository._internal() {
    _s3 = Minio(
      endPoint: Config.cloudflareR2Endpoint,
      accessKey: Config.cloudflareR2AccessKeyId,
      secretKey: Config.cloudflareR2SecretAccessKey,
    );
    _bucketName = Config.cloudflareR2BucketName;
  }
  static final S3Repository _instance = S3Repository._internal();

  late Minio _s3;
  late String _bucketName;

  Future<List<String>> getListObjectsKey({required String url}) async {
    final returnStr = <String>[];
    await for (final value in _s3.listObjectsV2(_bucketName, prefix: url, recursive: true)) {
      for (final obj in value.objects) {
        returnStr.add(obj.key!);
      }
    }
    return returnStr;
  }

  Future<MinioByteStream> getObject({required String url}) async {
    return _s3.getObject(_bucketName, url);
  }

  Stream<ListObjectsResult> listObjectsV2({String prefix = '', String? startAfter}) async* {
    MinioInvalidBucketNameError.check(_bucketName);
    MinioInvalidPrefixError.check(prefix);
    const delimiter = '';

    bool? isTruncated = false;
    String? continuationToken;

    do {
      final resp = await _s3.listObjectsV2Query(_bucketName, prefix, continuationToken, delimiter, null, startAfter);
      isTruncated = resp.isTruncated;
      continuationToken = resp.nextContinuationToken;
      yield ListObjectsResult(objects: resp.contents!, prefixes: resp.commonPrefixes.map((e) => e.prefix!).toList());
    } while (isTruncated!);
  }
}
