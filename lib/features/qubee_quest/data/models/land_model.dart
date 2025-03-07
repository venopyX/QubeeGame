import '../../domain/entities/land.dart';

class LandModel extends Land {
  LandModel({
    required int id,
    required String name,
    required String description,
    required String imagePath,
    required List<int> letterIds,
    required bool isUnlocked,
    required int requiredPoints,
  }) : super(
          id: id,
          name: name,
          description: description,
          imagePath: imagePath,
          letterIds: letterIds,
          isUnlocked: isUnlocked,
          requiredPoints: requiredPoints,
        );

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