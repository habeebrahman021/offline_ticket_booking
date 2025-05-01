import 'package:json_annotation/json_annotation.dart';

part 'wallet_dto.g.dart';

@JsonSerializable()
class WalletDto {
  WalletDto({
    this.balance,
    this.id,
  
  });

  factory WalletDto.fromJson(Map<String, dynamic> json) =>
      _$WalletDtoFromJson(json);

  @JsonKey(includeToJson: false)
  final int? id;
  final double? balance;

  Map<String, dynamic> toJson() => _$WalletDtoToJson(this);
}
