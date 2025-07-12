class BusStop {

  const BusStop(this.id, this.name, this.routeList, {this.reverse, this.selectable});

  factory BusStop.fromFirebase(Map map) {
    final routeList = (map['route'] as List).map((e) => e.toString()).toList();
    return BusStop(map['id'] as int, map['name'] as String, routeList,
        reverse: map['reverse'] as bool?, selectable: map['selectable'] as bool?);
  }
  final int id;
  final String name;
  final List<String> routeList;
  final bool? reverse;
  final bool? selectable;
}
