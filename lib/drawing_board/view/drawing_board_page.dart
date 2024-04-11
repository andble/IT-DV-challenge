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
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              const AppDrawingBoard(),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.black,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _Name(),
                      Padding(
                        padding: EdgeInsets.only(
                          right: 40,
                        ), // Increase right padding
                        child: Row(
                          mainAxisSize: MainAxisSize
                              .min, // Makes the row only as wide as its children
                          children: [
                            _SaveButton(),
                            _DeleteButton(),
                            _ColorSelectionButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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

    final controller = TextEditingController(text: drawingName);

    return IntrinsicWidth(
      stepWidth: 50,
      child: TextField(
        style: const TextStyle(color: Colors.white),
        controller: controller,
        onSubmitted: (name) => {
          context.read<DrawingBoardCubit>().changeName(name),
        },
      ),
    );
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

class _DeleteButton extends StatelessWidget {
  const _DeleteButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        // Delete the drawing from the database
        context.read<DrawingBoardCubit>().delete();
        // Clear the drawing from the drawing board
        context.read<DrawingController>().clear();
      },
      icon: const Icon(Icons.delete),
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
