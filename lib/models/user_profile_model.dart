class UserDevice {
  final String deviceName;
  final String location;
  final String lastActive;
  final bool isCurrentDevice;

  UserDevice({
    required this.deviceName,
    required this.location,
    required this.lastActive,
    this.isCurrentDevice = false,
  });
}

class RoutineItem {
  final int id;
  final String name;
  final String timeRange;
  final String category;
  final bool isEnabled;

  RoutineItem({
    required this.id,
    required this.name,
    required this.timeRange,
    required this.category,
    this.isEnabled = true,
  });

  RoutineItem copyWith({
    int? id,
    String? name,
    String? timeRange,
    String? category,
    bool? isEnabled,
  }) {
    return RoutineItem(
      id: id ?? this.id,
      name: name ?? this.name,
      timeRange: timeRange ?? this.timeRange,
      category: category ?? this.category,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
