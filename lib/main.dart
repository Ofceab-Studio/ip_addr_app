import 'package:flutter/material.dart';
import 'package:ip_addr_show/di.dart';
import 'root.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();

  runApp(const Root());
}
