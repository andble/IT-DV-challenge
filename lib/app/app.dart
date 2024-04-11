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

  @override
  void initState() {
    super.initState();
    // Simulate fetching data
    _fetchData();
  }

  void _fetchData() {
    // Simulate network request delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
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
            appBar: AppBar(
              title: const Text('Drawing Board'),
            ),
            body: const DrawingBoardPage(),
          );
  }
}
