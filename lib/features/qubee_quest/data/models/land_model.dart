import '../../domain/entities/land.dart';

class LandModel extends Land {
  LandModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imagePath,
    required super.letterIds,
    required super.isUnlocked,
    required super.requiredPoints,
  });

  factory LandModel.fromJson(Map<String, dynamic> json) {
    return LandModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imagePath: json['imagePath'],
      letterIds: List<int>.from(json['letterIds']),
      isUnlocked: json['isUnlocked'],
      requiredPoints: json['requiredPoints'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'letterIds': letterIds,
      'isUnlocked': isUnlocked,
      'requiredPoints': requiredPoints,
    };
  }
}