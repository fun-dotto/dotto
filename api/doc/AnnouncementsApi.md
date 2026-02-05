# openapi.api.AnnouncementsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**announcementsV0List**](AnnouncementsApi.md#announcementsv0list) | **GET** /announcements | 
[**announcementsV1List**](AnnouncementsApi.md#announcementsv1list) | **GET** /v1/announcements | 


# **announcementsV0List**
> BuiltList<Announcement> announcementsV0List()



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAnnouncementsApi();

try {
    final response = api.announcementsV0List();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AnnouncementsApi->announcementsV0List: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;Announcement&gt;**](Announcement.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **announcementsV1List**
> AnnouncementsV1List200Response announcementsV1List()



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAnnouncementsApi();

try {
    final response = api.announcementsV1List();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AnnouncementsApi->announcementsV1List: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AnnouncementsV1List200Response**](AnnouncementsV1List200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

