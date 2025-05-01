import 'package:auto_route/auto_route.dart';
import 'package:offline_ticket_booking/presentation/book_ticket/screen/book_ticket_screen.dart';
import 'package:offline_ticket_booking/presentation/home/screen/home_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, initial: true),
    AutoRoute(page: BookTicketRoute.page),
  ];
}
