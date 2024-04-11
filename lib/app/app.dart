import 'package:as_drawingchallenge_flutter/drawing_board/view/drawing_board_page.dart';
import 'package:as_drawingchallenge_flutter/drawing_repository/drawing_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App(this._drawingRepository, {super.key});

  final DrawingRepository _drawingRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _drawingRepository,
      child: const MaterialApp(
        home: DrawingBoardPage(),
      ),
    );
  }
}
