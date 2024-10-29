import 'package:fitness_app/network/responses/api_base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'splash_response.g.dart';

@JsonSerializable()
class SplashResponse extends ApiBaseResponse {
  SplashResponse(String success,String message,{required this.userData}) : super(success,message);

  @JsonKey(name: "user")
  final Map<String,dynamic> userData;
  factory SplashResponse.fromJson(Map<String,dynamic> json)=> _$SplashResponseFromJson(json);

  @override
  Map<String,dynamic> toJson()=> _$SplashResponseToJson(this);

}