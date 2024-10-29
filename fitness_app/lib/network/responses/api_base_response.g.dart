// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_base_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiBaseResponse _$ApiBaseResponseFromJson(Map<String, dynamic> json) =>
    ApiBaseResponse(
      json['success'] as String,
      json['message'] as String,
    );

Map<String, dynamic> _$ApiBaseResponseToJson(ApiBaseResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
    };
