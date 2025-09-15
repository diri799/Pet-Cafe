import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_model.freezed.dart';
part 'base_model.g.dart';

// Convert Firestore Timestamp to DateTime
DateTime _dateTimeFromTimestamp(Timestamp timestamp) => timestamp.toDate();

// Convert DateTime to Firestore Timestamp
Timestamp _dateTimeToTimestamp(DateTime date) => Timestamp.fromDate(date);

@freezed
class BaseModel with _$BaseModel {
  const factory BaseModel({
    required String id,
    @JsonKey(
      name: 'created_at',
      fromJson: _dateTimeFromTimestamp,
      toJson: _dateTimeToTimestamp,
    )
    required DateTime createdAt,
    @JsonKey(
      name: 'updated_at',
      fromJson: _dateTimeFromTimestamp,
      toJson: _dateTimeToTimestamp,
    )
    required DateTime updatedAt,
  }) = _BaseModel;

  factory BaseModel.fromJson(Map<String, dynamic> json) =>
      _$BaseModelFromJson(json);
}

// Extension to convert between Firestore DocumentSnapshot and our models
extension DocumentSnapshotExt on DocumentSnapshot {
  T toModel<T>(T Function(Map<String, dynamic>) fromJson) {
    final data = this.data() as Map<String, dynamic>;
    return fromJson(data..['id'] = id);
  }
}

// Extension to convert between Firestore QuerySnapshot and our models
extension QuerySnapshotExt on QuerySnapshot {
  List<T> toModelList<T>(T Function(Map<String, dynamic>) fromJson) {
    return docs.map((doc) => doc.toModel(fromJson)).toList();
  }
}

// Extension to convert between our models and Firestore data
extension ModelExt<T extends BaseModel> on T {
  Map<String, dynamic> toDocument() {
    final json = toJson();
    // Remove id from the document data as it's stored as the document ID
    json.remove('id');
    return json;
  }
}
