abstract class WalletRepository {
  Future<double> getBalance({required int id});

  Future<void> withdraw({required int id, required double amount});

  Future<void> deposit({required int id, required double amount});
}
