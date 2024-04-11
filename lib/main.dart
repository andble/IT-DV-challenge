import 'package:as_drawingchallenge_flutter/app/app.dart';
import 'package:as_drawingchallenge_flutter/drawing_repository/drawing_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  //final storage = await Hive.openBox<dynamic>('drawing');
  //final drawingRepository = DrawingRepository(storage);

  Future<Box<dynamic>> waitedOpenBox() async {
    await Future.delayed(const Duration(seconds: 2));
    return Hive.openBox<dynamic>('drawing');
  }

  final appBuilder = FutureBuilder(
    future: waitedOpenBox(),
    builder: (context, AsyncSnapshot<Box<dynamic>> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // While waiting for data, display a loading indicator
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        // If an error occurs, display an error message
        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
          ),
          body: Center(
            child: Text('Error: ${snapshot.error}'),
          ),
        );
      } else {
        return App(DrawingRepository(snapshot.data!));
      }
    },
  );

  runApp(
    //App(drawingRepository),
    appBuilder,
  );
}
