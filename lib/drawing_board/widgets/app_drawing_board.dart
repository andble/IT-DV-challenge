import 'package:as_drawingchallenge_flutter/drawing_board/drawing_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';



class CustomBrushTool extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Implement behavior when the tool is tapped
        print('Custom brush tool selected');
        // You can perform any custom action here, such as changing the drawing mode, selecting a specific brush, etc.
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue, // Customize color as needed
          borderRadius: BorderRadius.circular(8), // Add rounded corners
        ),
        child: Icon(
          Icons.brush, // Use an icon to represent the tool
          color: Colors.white, // Customize icon color
          size: 24, // Customize icon size
        ),
      ),
    );
  }
}

class AppDrawingBoard extends StatelessWidget {
  const AppDrawingBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DrawingController>();

    return MultiBlocListener(
      listeners: [
        BlocListener<DrawingBoardCubit, DrawingBoardState>(
          listenWhen: (previous, current) =>
              !previous.status.isSuccess && current.status.isSuccess,
          listener: (context, state) {
            final drawing = state.drawing;
            controller
              ..addContents(drawing.contents)
              ..setStyle(color: drawing.color,
              strokeWidth: 3.0, // Example: Set the stroke width to 3.0
              blendMode: BlendMode.multiply, // Example: Set the blend mode to multiply
            );
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
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        showDefaultTools: true,
        showDefaultActions: true,
      ),
    );
  }
}
