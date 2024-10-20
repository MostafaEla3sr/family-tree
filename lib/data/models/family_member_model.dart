class FamilyMember {
  final int id;
  final String firstName; // Can be nullable
  final String fullName; // Can be nullable
  final String gender; // Can be nullable
  final String isAlive; // Can be nullable
  final int? sequenceNumber; // Mark as nullable
  final int? sonsCount; // Mark as nullable
  List<FamilyMember> children; // List to hold children
  bool isExpanded = false; // Add this line to your FamilyMember model

  FamilyMember({
    required this.id,
    required this.firstName, // Change to String? if can be null
    required this.fullName, // Change to String? if can be null
    required this.gender, // Change to String? if can be null
    required this.isAlive, // Change to String? if can be null
    this.sequenceNumber, // Mark as nullable
    this.sonsCount, // Mark as nullable
    this.children = const [],
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'],
      firstName:
          json['first_name'] ?? '', // Provide a default value or handle null
      fullName:
          json['full_name'] ?? '', // Provide a default value or handle null
      gender: json['gender'] ?? '', // Provide a default value or handle null
      isAlive: json['is_alive'] ?? '', // Provide a default value or handle null
      sequenceNumber: json['sequance_number'], // This can be null
      sonsCount: json['sons_count'], // This can be null
      children: (json['children'] as List?)
              ?.map((child) => FamilyMember.fromJson(child))
              .toList() ??
          [],
    );
  }
}
