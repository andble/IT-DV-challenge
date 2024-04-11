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
    autosave(context);
    return BlocProvider(
      create: (context) => DrawingBoardCubit(
        context.read<DrawingRepository>(),
      )..loadDrawing(),
      child: const DrawingBoardView(),
    );
  }
}

void autosave(BuildContext context) {}

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
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(
              10,
            ), // Optional: Add padding to the container
            decoration: BoxDecoration(
              // Adding BoxDecoration for rounded edges
              color: Color.fromARGB(255, 231, 212, 212),
              borderRadius: BorderRadius.circular(15), // Add rounded edges
            ),
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

    return SizedBox(
      width: 200, // Adjust the width as needed
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 50, 0),
        child: TextField(
          onChanged: (newName) {
            context.read<DrawingBoardCubit>().updateName(newName);
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            hintText: 'Name',
            filled: true,
            fillColor: Colors.white,
            labelText: drawingName.isEmpty ? 'Drawing Name' : drawingName,
          ),
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DrawingController>();

    return ElevatedButton(
      onPressed: () {
        context.read<DrawingBoardCubit>().save(
              jsonList: controller.getJsonList(),
            );
      },
      child: const Icon(Icons.save),
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
    return ElevatedButton(
      onPressed: () {
        ColorSelectionDialog.show(
          context: context,
          drawingBoardCubit: context.read<DrawingBoardCubit>(),
        );
      },
      child: const Icon(Icons.palette),
    );
  }
}
