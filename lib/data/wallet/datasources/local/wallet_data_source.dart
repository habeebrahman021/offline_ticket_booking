import 'package:offline_ticket_booking/core/database/database_helper.dart';
import 'package:offline_ticket_booking/core/utils/constants.dart';
import 'package:offline_ticket_booking/data/wallet/dto/wallet_dto.dart';

abstract class WalletDataSource {
  Future<WalletDto> getBalance({required int id});

  Future<void> deposit({required int id, required double amount});

  Future<void> withdraw({required int id, required double amount});
}

class WalletDataSourceImpl implements WalletDataSource {
  final DatabaseHelper databaseHelper;

  WalletDataSourceImpl({required this.databaseHelper});

  @override
  Future<WalletDto> getBalance({required int id}) async {
    final db = await databaseHelper.database;
    final result = await db.query(
      DatabaseConstants.tblWallet,
      where: '${DatabaseConstants.colWalletId} = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return WalletDto.fromJson(result.first);
    } else {
      throw Exception('No wallet found for id: $id');
    }
  }

  @override
  Future<void> deposit({required int id, required double amount}) async {
    final db = await databaseHelper.database;

    // Step 1: Get the current balance
    final result = await db.query(
      DatabaseConstants.tblWallet,
      columns: [DatabaseConstants.colBalance],
      where: '${DatabaseConstants.colWalletId} = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) {
      throw Exception('No wallet found for id: $id');
    }

    final currentBalance = result.first[DatabaseConstants.colBalance] as double;

    // Step 2: Calculate the new balance
    final newBalance = currentBalance + amount;

    // Step 3: Update the wallet with the new balance
    await db.update(
      DatabaseConstants.tblWallet,
      {DatabaseConstants.colBalance: newBalance},
      where: '${DatabaseConstants.colWalletId} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> withdraw({required int id, required double amount}) async {
    final db = await databaseHelper.database;

    // Step 1: Get the current balance
    final result = await db.query(
      DatabaseConstants.tblWallet,
      columns: [DatabaseConstants.colBalance],
      where: '${DatabaseConstants.colWalletId} = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) {
      throw Exception('No wallet found for id: $id');
    }

    final currentBalance = result.first[DatabaseConstants.colBalance] as double;

    // Step 2: Calculate the new balance
    final newBalance = currentBalance - amount;

    // Step 3: Update the wallet with the new balance
    await db.update(
      DatabaseConstants.tblWallet,
      {DatabaseConstants.colBalance: newBalance},
      where: '${DatabaseConstants.colWalletId} = ?',
      whereArgs: [id],
    );
  }
}
