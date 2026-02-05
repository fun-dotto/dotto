//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/announcement.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'announcements_v1_list200_response.g.dart';

/// AnnouncementsV1List200Response
///
/// Properties:
/// * [announcements] 
@BuiltValue()
abstract class AnnouncementsV1List200Response implements Built<AnnouncementsV1List200Response, AnnouncementsV1List200ResponseBuilder> {
  @BuiltValueField(wireName: r'announcements')
  BuiltList<Announcement> get announcements;

  AnnouncementsV1List200Response._();

  factory AnnouncementsV1List200Response([void updates(AnnouncementsV1List200ResponseBuilder b)]) = _$AnnouncementsV1List200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AnnouncementsV1List200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AnnouncementsV1List200Response> get serializer => _$AnnouncementsV1List200ResponseSerializer();
}

class _$AnnouncementsV1List200ResponseSerializer implements PrimitiveSerializer<AnnouncementsV1List200Response> {
  @override
  final Iterable<Type> types = const [AnnouncementsV1List200Response, _$AnnouncementsV1List200Response];

  @override
  final String wireName = r'AnnouncementsV1List200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AnnouncementsV1List200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'announcements';
    yield serializers.serialize(
      object.announcements,
      specifiedType: const FullType(BuiltList, [FullType(Announcement)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AnnouncementsV1List200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AnnouncementsV1List200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'announcements':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Announcement)]),
          ) as BuiltList<Announcement>;
          result.announcements.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AnnouncementsV1List200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AnnouncementsV1List200ResponseBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

