# Map

## MapTile

```mermaid
classDiagram
  StatelessWidget <|-- MapTile
  MapTile -- MapTileProps
  MapTile -- Room

  class StatelessWidget

  class MapTile {
    MapTileProps props
    Room room
  }

  class MapTileProps {
    int width
    int height
    double top
    double right
    double bottom
    double left
    MapTileType tileType
    String label
    String? roomId
    List~String~? lessonIds
    int wc
    bool using
    double fontSize
    late Color tileColor
    late Color fontColor
    MapStairType stairType
    DateTime? useEndTime
    Widget? innerWidget
    bool? food
    bool? drink
    int? outlet
  }

  class Room {
    String id
    String name
    String description
    Floor floor
    String email
    List~String~ keywords
    List~RoomSchedule~ schedules
    isInUse(DateTime dateTime) bool
  }
```

### TileType

```swift
enum TileType {
    case classRoom(_ roomID: String)
    case facultyRoom(_ roomID: String)
    case subRoom(_ roomID: String)      // TODO: Rename
    case otherRoom(_ roomID: String)    // TODO: Rename
    case restroom(_ type: RestroomType)
    case stair
    case elevator
    case aisle
    case atrium
}

enum RestroomType {
    case men
    case women
    case wheelchair
}
```
