import 'package:offline_ticket_booking/data/wallet/datasources/local/wallet_data_source.dart';
import 'package:offline_ticket_booking/domain/wallet/repositories/wallet_repository.dart';

class WalletRepositoryImpl extends WalletRepository {
  final WalletDataSource dataSource;

  WalletRepositoryImpl({required this.dataSource});

  @override
  Future<double> getBalance({required int id}) async {
    final result = await dataSource.getBalance(id: id);
    return result.balance ?? 0;
  }

  @override
  Future<void> deposit({required int id, required double amount}) {
    return dataSource.deposit(id: id, amount: amount);
  }

  @override
  Future<void> withdraw({required int id, required double amount}) {
    return dataSource.withdraw(id: id, amount: amount);
  }
}
