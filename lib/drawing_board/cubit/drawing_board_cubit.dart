import 'dart:async';

import 'package:as_drawingchallenge_flutter/drawing_board/drawing_board.dart';
import 'package:as_drawingchallenge_flutter/drawing_repository/drawing_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawingBoardCubit extends Cubit<DrawingBoardState> {
  DrawingBoardCubit(this._repository)
      : super(
          const DrawingBoardState(),
        );

  final DrawingRepository _repository;

  Future<void> loadDrawing() async {
    final drawing = await _repository.load();

    emit(
      state.copyWith(
        status: Status.success,
        drawing: drawing,
      ),
    );
  }

  Future<void> save({required List<Map<String, dynamic>> jsonList}) async {
    final updatedDrawing = state.drawing.copyWith(
      jsonList: jsonList,
    );

    await _repository.save(updatedDrawing);

    emit(
      state.copyWith(
        drawing: updatedDrawing,
      ),
    );
  }

  Future<void> delete() async {
    await _repository.delete();

    emit(
      state.copyWith(
        drawing: Drawing.initial,
      ),
    );
  }

  Future<void> changeColor(Color color) async {
    final updatedDrawing = state.drawing.copyWith(color: color);

    emit(
      state.copyWith(
        drawing: updatedDrawing,
      ),
    );
  }
}
