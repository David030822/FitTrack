// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SplashResponse _$SplashResponseFromJson(Map<String, dynamic> json) =>
    SplashResponse(
      json['success'] as String,
      json['message'] as String,
      userData: json['user'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$SplashResponseToJson(SplashResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'user': instance.userData,
    };
