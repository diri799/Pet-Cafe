// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BaseModelImpl _$$BaseModelImplFromJson(Map<String, dynamic> json) =>
    _$BaseModelImpl(
      id: json['id'] as String,
      createdAt: _dateTimeFromTimestamp(json['created_at'] as Timestamp),
      updatedAt: _dateTimeFromTimestamp(json['updated_at'] as Timestamp),
    );

Map<String, dynamic> _$$BaseModelImplToJson(_$BaseModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': _dateTimeToTimestamp(instance.createdAt),
      'updated_at': _dateTimeToTimestamp(instance.updatedAt),
    };
