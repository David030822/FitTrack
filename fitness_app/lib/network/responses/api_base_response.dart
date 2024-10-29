import 'package:json_annotation/json_annotation.dart';

part 'api_base_response.g.dart';

@JsonSerializable()
class ApiBaseResponse{
  ApiBaseResponse(this.success,this.message);

  final String message;
  final String success;

  factory ApiBaseResponse.fromJson(Map<String,dynamic> json) => _$ApiBaseResponseFromJson(json);

  Map<String,dynamic> toJson()=> _$ApiBaseResponseToJson(this);

  @override
  String toString() {
    return 'ApiBaseResponse{message: $message, success: $success}';
  }
}