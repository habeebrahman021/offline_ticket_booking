import 'package:json_annotation/json_annotation.dart';

part 'booking_dto.g.dart';

@JsonSerializable()
class BookingDto {
  BookingDto({
    this.passengerName,
    this.id,
    this.bookingDate,
    this.journeyDate,
    this.distance,
    this.amount,
    this.classId,
    this.className,
    this.status,
  });

  factory BookingDto.fromJson(Map<String, dynamic> json) =>
      _$BookingDtoFromJson(json);

  @JsonKey(includeToJson: false)
  final int? id;
  @JsonKey(name: 'passenger_name')
  final String? passengerName;
  @JsonKey(name: 'booking_date')
  final int? bookingDate;
  @JsonKey(name: 'journey_date')
  final int? journeyDate;
  final double? distance;
  final double? amount;
  @JsonKey(name: 'class_id')
  final int? classId;
  @JsonKey(name: 'class_name')
  final String? className;
  @JsonKey(name: 'status', includeToJson: false)
  final int? status;

  Map<String, dynamic> toJson() => _$BookingDtoToJson(this);
}
