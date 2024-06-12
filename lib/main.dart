import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_plan_app/src/application.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const Application());
}


