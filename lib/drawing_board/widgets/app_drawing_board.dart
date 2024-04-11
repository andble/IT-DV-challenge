import 'package:as_drawingchallenge_flutter/drawing_board/drawing_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:flutter_drawing_board/paint_extension.dart';

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
              ..setStyle(
                color: drawing.color,
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
          color: Colors.white,
        ),
        showDefaultTools: true,
        showDefaultActions: true,
        boardClipBehavior: Clip.none,
        boardPanEnabled: false,
        onPointerUp: (pue) => {
          context.read<DrawingBoardCubit>().save(
                jsonList: controller.getJsonList(),
              ),
        },
        defaultToolsBuilder: (Type t, _) {
          return DrawingBoard.defaultTools(t, controller)
            ..insert(
              /// Insert the triangle tool into the second position of the default toolbar
              1,
              DefToolItem(
                icon: Icons.change_history_rounded,
                isActive: t == Triangle,
                onTap: () => controller.setPaintContent(Triangle()),
              ),
            );
        },
      ),
    );
  }
}

/// Custom drawing of a triangle
class Triangle extends PaintContent {
  Triangle();

  Triangle.data({
    required this.startPoint,
    required this.A,
    required this.B,
    required this.C,
    required Paint paint,
  }) : super.paint(paint);

  factory Triangle.fromJson(Map<String, dynamic> data) {
    return Triangle.data(
      startPoint: jsonToOffset(data['startPoint'] as Map<String, dynamic>),
      A: jsonToOffset(data['A'] as Map<String, dynamic>),
      B: jsonToOffset(data['B'] as Map<String, dynamic>),
      C: jsonToOffset(data['C'] as Map<String, dynamic>),
      paint: jsonToPaint(data['paint'] as Map<String, dynamic>),
    );
  }

  Offset startPoint = Offset.zero;

  Offset A = Offset.zero;
  Offset B = Offset.zero;
  Offset C = Offset.zero;

  @override
  void startDraw(Offset startPoint) => this.startPoint = startPoint;

  @override
  void drawing(Offset nowPoint) {
    A = Offset(
      startPoint.dx + (nowPoint.dx - startPoint.dx) / 2,
      startPoint.dy,
    );
    B = Offset(startPoint.dx, nowPoint.dy);
    C = nowPoint;
  }

  @override
  void draw(Canvas canvas, Size size, bool deeper) {
    final path = Path()
      ..moveTo(A.dx, A.dy)
      ..lineTo(B.dx, B.dy)
      ..lineTo(C.dx, C.dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  Triangle copy() => Triangle();

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'startPoint': startPoint.toJson(),
      'A': A.toJson(),
      'B': B.toJson(),
      'C': C.toJson(),
      'paint': paint.toJson(),
    };
  }

  @override
  Map<String, dynamic> toContentJson() {
    return <String, dynamic>{
      'startPoint': startPoint.toJson(),
      'A': A.toJson(),
      'B': B.toJson(),
      'C': C.toJson(),
      'paint': paint.toJson(),
    };
  }
}
