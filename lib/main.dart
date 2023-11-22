import 'package:flutter/material.dart';

import 'src/common/service/db_service.dart';
import 'src/common/widget/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBService.initialize();

  runApp(const App());
}
