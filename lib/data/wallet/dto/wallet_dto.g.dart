// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletDto _$WalletDtoFromJson(Map<String, dynamic> json) => WalletDto(
  balance: (json['balance'] as num?)?.toDouble(),
  id: (json['id'] as num?)?.toInt(),
);

Map<String, dynamic> _$WalletDtoToJson(WalletDto instance) => <String, dynamic>{
  'balance': instance.balance,
};
