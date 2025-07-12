import 'package:dotto/controller/config_controller.dart';
import 'package:minio/minio.dart';
import 'package:minio/models.dart';

final class S3 {
  S3._();
  Minio? _minio;

  static final instance = S3._();
  Minio getMinio() {
    _minio ??= Minio(
      endPoint: ConfigState.cloudflareR2Endpoint,
      accessKey: ConfigState.cloudflareR2AccessKeyId,
      secretKey: ConfigState.cloudflareR2SecretAccessKey,
    );
    return _minio!;
  }

  Stream<ListObjectsResult> listObjectsV2(
    String bucket, {
    String prefix = '',
    String? startAfter,
  }) async* {
    MinioInvalidBucketNameError.check(bucket);
    MinioInvalidPrefixError.check(prefix);
    const delimiter = '';

    bool? isTruncated = false;
    String? continuationToken;

    do {
      final resp = await _minio!.listObjectsV2Query(
        bucket,
        prefix,
        continuationToken,
        delimiter,
        null,
        startAfter,
      );
      isTruncated = resp.isTruncated;
      continuationToken = resp.nextContinuationToken;
      yield ListObjectsResult(
        objects: resp.contents!,
        prefixes: resp.commonPrefixes.map((e) => e.prefix!).toList(),
      );
    } while (isTruncated!);
  }

  Future<List<String>> getListObjectsKey({required String url}) async {
    instance.getMinio();
    final returnStr = <String>[];
    await for (final value in listObjectsV2('kakomon', prefix: url)) {
      for (final obj in value.objects) {
        returnStr.add(obj.key!);
      }
    }
    return returnStr;
  }

  Future<MinioByteStream> getObject({required String url}) async {
    instance.getMinio();
    return _minio!.getObject('kakomon', url);
  }
}
