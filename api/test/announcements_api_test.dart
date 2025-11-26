import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for AnnouncementsApi
void main() {
  final instance = Openapi().getAnnouncementsApi();

  group(AnnouncementsApi, () {
    // List announcements
    //
    //Future<BuiltList<Announcement>> announcementsList() async
    test('test announcementsList', () async {
      // TODO
    });

  });
}
