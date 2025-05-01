import 'package:get_it/get_it.dart';
import 'package:offline_ticket_booking/core/database/database_helper.dart';
import 'package:offline_ticket_booking/data/booking/datasources/local/booking_data_source.dart';
import 'package:offline_ticket_booking/data/booking/repositories/booking_repository_impl.dart';
import 'package:offline_ticket_booking/data/wallet/datasources/local/wallet_data_source.dart';
import 'package:offline_ticket_booking/data/wallet/repositories/wallet_repository_impl.dart';
import 'package:offline_ticket_booking/domain/booking/repositories/booking_repository.dart';
import 'package:offline_ticket_booking/domain/booking/usecases/calculate_amount_use_case.dart';
import 'package:offline_ticket_booking/domain/booking/usecases/calculate_refund_amount_use_case.dart';
import 'package:offline_ticket_booking/domain/booking/usecases/cancel_booking_use_case.dart';
import 'package:offline_ticket_booking/domain/booking/usecases/create_booking_use_case.dart';
import 'package:offline_ticket_booking/domain/booking/usecases/get_bookings_use_case.dart';
import 'package:offline_ticket_booking/domain/booking/usecases/get_ticket_classes_use_case.dart';
import 'package:offline_ticket_booking/domain/wallet/repositories/wallet_repository.dart';
import 'package:offline_ticket_booking/domain/wallet/usecases/get_wallet_balance_use_case.dart';
import 'package:offline_ticket_booking/presentation/book_ticket/bloc/book_ticket_bloc.dart';
import 'package:offline_ticket_booking/presentation/home/bloc/home_bloc.dart';

final injector = GetIt.instance;

Future<void> initializeDependencies() async {
  await _initializeCore();
  await _initializeDataSources();
  await _initializeRepositories();
  await _initializeUseCases();
  await _initializeBlocs();
}

Future<void> _initializeCore() async {
  injector.registerSingleton<DatabaseHelper>(DatabaseHelper());
}

Future<void> _initializeDataSources() async {
  injector.registerSingleton<BookingsDataSource>(
    BookingsDataSourceImpl(databaseHelper: injector()),
  );

  injector.registerSingleton<WalletDataSource>(
    WalletDataSourceImpl(databaseHelper: injector()),
  );
}

Future<void> _initializeRepositories() async {
  injector.registerSingleton<BookingRepository>(
    BookingRepositoryImpl(bookingsDataSource: injector()),
  );

  injector.registerSingleton<WalletRepository>(
    WalletRepositoryImpl(dataSource: injector()),
  );
}

Future<void> _initializeUseCases() async {
  injector.registerSingleton<GetBookingsUseCase>(
    GetBookingsUseCase(bookingRepository: injector()),
  );

  injector.registerSingleton<GetTicketClassesUseCase>(
    GetTicketClassesUseCase(),
  );

  injector.registerSingleton<CalculateAmountUseCase>(CalculateAmountUseCase());
  injector.registerSingleton<CreateBookingUseCase>(
    CreateBookingUseCase(repository: injector(), walletRepository: injector()),
  );

  injector.registerSingleton<CancelBookingUseCase>(
    CancelBookingUseCase(repository: injector(), walletRepository: injector()),
  );

  injector.registerSingleton<GetWalletBalanceUseCase>(
    GetWalletBalanceUseCase(repository: injector()),
  );

  injector.registerSingleton<CalculateRefundAmountUseCase>(
    CalculateRefundAmountUseCase(),
  );
}

Future<void> _initializeBlocs() async {
  injector.registerFactory<BookTicketBloc>(
    () => BookTicketBloc(
      getTicketClassesUseCase: injector(),
      calculateAmountUseCase: injector(),
      createBookingUseCase: injector(),
    ),
  );

  injector.registerFactory<HomeBloc>(
    () => HomeBloc(
      getBookingsUseCase: injector(),
      cancelBookingUseCase: injector(),
      getWalletBalanceUseCase: injector(),
      calculateRefundAmountUseCase: injector(),
    ),
  );
}
