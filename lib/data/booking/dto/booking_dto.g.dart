// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingDto _$BookingDtoFromJson(Map<String, dynamic> json) => BookingDto(
  passengerName: json['passenger_name'] as String?,
  id: (json['id'] as num?)?.toInt(),
  bookingDate: (json['booking_date'] as num?)?.toInt(),
  journeyDate: (json['journey_date'] as num?)?.toInt(),
  distance: (json['distance'] as num?)?.toDouble(),
  amount: (json['amount'] as num?)?.toDouble(),
  classId: (json['class_id'] as num?)?.toInt(),
  className: json['class_name'] as String?,
  status: (json['status'] as num?)?.toInt(),
);

Map<String, dynamic> _$BookingDtoToJson(BookingDto instance) =>
    <String, dynamic>{
      'passenger_name': instance.passengerName,
      'booking_date': instance.bookingDate,
      'journey_date': instance.journeyDate,
      'distance': instance.distance,
      'amount': instance.amount,
      'class_id': instance.classId,
      'class_name': instance.className,
    };
