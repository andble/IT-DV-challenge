import 'dart:async';

import 'package:as_drawingchallenge_flutter/drawing_board/cubit/drawing_board_cubit.dart';
import 'package:as_drawingchallenge_flutter/drawing_board/view/drawing_board_page.dart';
import 'package:as_drawingchallenge_flutter/drawing_repository/drawing_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';

class App extends StatelessWidget {
  const App(this._drawingRepository, {super.key});

  final DrawingRepository _drawingRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _drawingRepository,
      child: MaterialApp(
        home: _HomePage(_drawingRepository),
      ),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage(this._drawingRepository, {super.key});
  final DrawingRepository _drawingRepository;

  @override
  __HomePageState createState() => __HomePageState();
}

class __HomePageState extends State<_HomePage> {
  bool _isLoading =
      true; // Initially set to true to show the circular progress indicator
  Timer? _autoSaveTimer;
  late DrawingRepository repository;

  @override
  void initState() {
    super.initState();
    // Simulate fetching data
    _fetchData();
    _startAutoSave(context);
  }

  void _fetchData() {
    // Simulate network request delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _startAutoSave(context) {
    final controller = context.watch<DrawingController>();
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      //jsonList: controller.getJsonList(),
      context.read<DrawingBoardCubit>().save(
            jsonList: controller.getJsonList(),
          );
    });
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(
            body: Center(
              child:
                  CircularProgressIndicator(), // Display circular progress indicator
            ),
          )
        : Scaffold(
            body: const DrawingBoardPage(),
          );
  }
}
