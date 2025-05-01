import 'package:flutter/cupertino.dart';
import 'package:offline_ticket_booking/app.dart';
import 'package:offline_ticket_booking/core/di/injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();

  runApp(MyApp());
}
