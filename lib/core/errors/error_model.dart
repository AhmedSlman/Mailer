import 'package:json_annotation/json_annotation.dart';
part 'error_model.g.dart';

@JsonSerializable()
class ErrorModel {
  @JsonKey(name: 'msg')
  final String message;
  @JsonKey(name: 'key')
  final String? key;

  final List<dynamic>? data;

  ErrorModel({
    required this.message,
    this.key,
    this.data,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ErrorModelFromJson(json);
}
