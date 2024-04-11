import 'package:as_drawingchallenge_flutter/drawing_board/drawing_board.dart';
import 'package:as_drawingchallenge_flutter/drawing_repository/drawing_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:provider/provider.dart';

class DrawingBoardPage extends StatelessWidget {
  const DrawingBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DrawingBoardCubit(
        context.read<DrawingRepository>(),
      )..loadDrawing(),
      child: const DrawingBoardView(),
    );
  }
}

class DrawingBoardView extends StatefulWidget {
  const DrawingBoardView({super.key});

  @override
  State<DrawingBoardView> createState() => _DrawingBoardViewState();
}

class _DrawingBoardViewState extends State<DrawingBoardView> {
  late final DrawingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DrawingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: _controller,
      child: const Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
          child: Stack(
            children: [
              AppDrawingBoard(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Name(),
                  _SaveButton(),
                  _ColorSelectionButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Name extends StatelessWidget {
  const _Name();

  @override
  Widget build(BuildContext context) {
    final drawingName = context.select(
      (DrawingBoardCubit cubit) => cubit.state.drawing.name,
    );

    return Text(drawingName);
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DrawingController>();

    return IconButton(
      onPressed: () {
        context.read<DrawingBoardCubit>().save(
              jsonList: controller.getJsonList(),
            );
      },
      icon: const Icon(Icons.save),
    );
  }
}

class _EditText extends StatelessWidget {
  const _EditText();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DrawingController>();

    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.text_snippet),
    );
  }
}

class _ColorSelectionButton extends StatelessWidget {
  const _ColorSelectionButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        ColorSelectionDialog.show(
          context: context,
          drawingBoardCubit: context.read<DrawingBoardCubit>(),
        );
      },
      icon: const Icon(Icons.palette),
    );
  }
}
