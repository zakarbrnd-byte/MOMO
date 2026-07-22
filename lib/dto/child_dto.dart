import '../models/child.dart';
import 'json_converters.dart';

/// Wire format for [Child]. Nested under [UserDto].
class ChildDto {
  const ChildDto({
    this.id,
    this.displayName,
    this.ageLabel,
  });

  final String? id;
  final String? displayName;
  final String? ageLabel;

  factory ChildDto.fromJson(Map<String, dynamic> json) {
    return ChildDto(
      id: JsonConverters.nullableStringFromJson(json['id']),
      displayName: JsonConverters.nullableStringFromJson(json['displayName']),
      ageLabel: JsonConverters.nullableStringFromJson(json['ageLabel']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (displayName != null) 'displayName': displayName,
      if (ageLabel != null) 'ageLabel': ageLabel,
    };
  }

  Child toDomain() {
    return Child(
      id: id,
      displayName: displayName,
      ageLabel: ageLabel,
    );
  }

  factory ChildDto.fromDomain(Child child) {
    return ChildDto(
      id: child.id,
      displayName: child.displayName,
      ageLabel: child.ageLabel,
    );
  }
}
