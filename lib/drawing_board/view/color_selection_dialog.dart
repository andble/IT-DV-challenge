import 'package:as_drawingchallenge_flutter/drawing_board/drawing_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorSelectionDialog extends StatelessWidget {
  const ColorSelectionDialog();

  static void show({
    required BuildContext context,
    required DrawingBoardCubit drawingBoardCubit,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'ColorSelectionDialog',
      pageBuilder: (_, __, ___) => BlocProvider.value(
        value: drawingBoardCubit,
        child: const ColorSelectionDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Dropdown(),
          ],
        ),
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  const _Dropdown();

  @override
  Widget build(BuildContext context) {
    final selectedColor = context.select(
      (DrawingBoardCubit cubit) => cubit.state.drawing.color,
    );

    return DropdownButton(
      value: selectedColor.value,
      items: [
        for (final color in ColorSelection.colors)
          DropdownMenuItem(
            value: color.value,
            child: Container(
              padding: const EdgeInsets.all(8),
              width: 30,
              height: 30,
              color: color,
            ),
          ),
      ],
      onChanged: (color) {
        final newColor = ColorSelection.colors.firstWhere(
          (element) => element.value == color,
          orElse: () => selectedColor,
        );
        context.read<DrawingBoardCubit>().changeColor(newColor);
      },
    );
  }
}
