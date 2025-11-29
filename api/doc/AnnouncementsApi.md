# openapi.api.AnnouncementsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**announcementsList**](AnnouncementsApi.md#announcementslist) | **GET** /announcements | 


# **announcementsList**
> BuiltList<Announcement> announcementsList()



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAnnouncementsApi();

try {
    final response = api.announcementsList();
    print(response);
} catch on DioException (e) {
    print('Exception when calling AnnouncementsApi->announcementsList: $e\n');
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

