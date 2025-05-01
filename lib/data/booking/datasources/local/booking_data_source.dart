import 'package:offline_ticket_booking/core/database/database_helper.dart';
import 'package:offline_ticket_booking/core/utils/constants.dart';
import 'package:offline_ticket_booking/data/booking/dto/booking_dto.dart';

abstract class BookingsDataSource {
  Future<List<BookingDto>> getBookings();

  Future<void> createBooking(BookingDto dto);

  Future<int> cancelBooking(int id);
}

class BookingsDataSourceImpl implements BookingsDataSource {
  final DatabaseHelper databaseHelper;

  BookingsDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<BookingDto>> getBookings() async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.tblBooking,
    );
    return List.generate(maps.length, (i) => BookingDto.fromJson(maps[i]));
  }

  @override
  Future<void> createBooking(BookingDto dto) async {
    final db = await databaseHelper.database;
    await db.insert(DatabaseConstants.tblBooking, dto.toJson());
  }

  @override
  Future<int> cancelBooking(int id) async {
    final db = await databaseHelper.database;
    return db.update(
      DatabaseConstants.tblBooking,
      {DatabaseConstants.colStatus: 0},
      where: '${DatabaseConstants.colBookingId} = ?',
      whereArgs: [id],
    );
  }
}
