// IGNORE
// ignore_for_file: depend_on_referenced_packages
import 'package:offline_ticket_booking/core/utils/constants.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'app_database.db');

    return openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {},
      onCreate: (db, version) async {
        await _createTables(db);
      },
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tblBooking} (
        ${DatabaseConstants.colBookingId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DatabaseConstants.colPassengerName} TEXT NOT NULL,
        ${DatabaseConstants.colDistance} REAL NOT NULL,
        ${DatabaseConstants.colAmount} REAL NOT NULL,
        ${DatabaseConstants.colJourneyDate} INTEGER NOT NULL,
        ${DatabaseConstants.colBookingDate} INTEGER NOT NULL,
        ${DatabaseConstants.colClassId} INTEGER NOT NULL,
        ${DatabaseConstants.colClassName} TEXT NOT NULL,
        ${DatabaseConstants.colStatus} INT NOT NULL DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tblWallet} (
        ${DatabaseConstants.colWalletId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DatabaseConstants.colBalance} REAL NOT NULL 
      )
    ''');

    await db.execute('''
      INSERT INTO ${DatabaseConstants.tblWallet} 
      (${DatabaseConstants.colWalletId}, ${DatabaseConstants.colBalance}) VALUES (1, 1000)
    ''');
  }

  Future<void> closeDB() async {
    final db = await database;
    await db.close();
  }
}
