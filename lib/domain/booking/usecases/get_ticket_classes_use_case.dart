import 'package:offline_ticket_booking/core/use_case/use_case.dart';
import 'package:offline_ticket_booking/domain/booking/entities/ticket_class.dart';

class GetTicketClassesUseCase extends UseCase<List<TicketClass>, NoParams> {
  @override
  Future<List<TicketClass>> execute(NoParams params) {
    final list = <TicketClass>[];
    list.add(TicketClass(id: 1, name: 'General', amount: 10, minAmount: 50));
    list.add(TicketClass(id: 2, name: 'CC', amount: 20, minAmount: 100));
    list.add(TicketClass(id: 3, name: 'Sleeper', amount: 30, minAmount: 150));
    list.add(TicketClass(id: 4, name: 'AC', amount: 50, minAmount: 250));
    return Future.value(list);
  }
}
