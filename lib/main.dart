import 'package:as_drawingchallenge_flutter/app/app.dart';
import 'package:as_drawingchallenge_flutter/drawing_repository/drawing_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  final storage = await Hive.openBox<dynamic>('drawing');
  final drawingRepository = DrawingRepository(storage);

  runApp(
    App(drawingRepository),
  );
}
