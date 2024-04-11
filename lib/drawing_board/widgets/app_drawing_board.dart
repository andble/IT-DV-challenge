import 'package:as_drawingchallenge_flutter/drawing_board/drawing_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';

class AppDrawingBoard extends StatelessWidget {
  const AppDrawingBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DrawingController>();

    final size = MediaQuery.of(context).size;

    return MultiBlocListener(
      listeners: [
        BlocListener<DrawingBoardCubit, DrawingBoardState>(
          listenWhen: (previous, current) =>
              !previous.status.isSuccess && current.status.isSuccess,
          listener: (context, state) {
            final drawing = state.drawing;
            controller
              ..addContents(drawing.contents)
              ..setStyle(color: drawing.color);
          },
        ),
        BlocListener<DrawingBoardCubit, DrawingBoardState>(
          listenWhen: (previous, current) =>
              previous.drawing.color.value != current.drawing.color.value,
          listener: (context, state) {
            final drawing = state.drawing;
            controller.setStyle(color: drawing.color);
          },
        ),
      ],
      child: DrawingBoard(
        controller: controller,
        background: Container(
          width: size.width,
          height: size.height,
          color: Colors.white,
        ),
        showDefaultTools: true,
      ),
    );
  }
}
