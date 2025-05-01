import 'package:offline_ticket_booking/core/use_case/use_case.dart';
import 'package:offline_ticket_booking/domain/wallet/repositories/wallet_repository.dart';

class GetWalletBalanceUseCase extends UseCase<double, GetWalletBalanceUseCaseParams> {
  final WalletRepository repository;

  GetWalletBalanceUseCase({required this.repository});

  @override
  Future<double> execute(GetWalletBalanceUseCaseParams params) {
    return repository.getBalance(id: params.id);
  }
}

class GetWalletBalanceUseCaseParams {
  final int id;

  GetWalletBalanceUseCaseParams({required this.id});
}
