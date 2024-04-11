// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:as_drawingchallenge_flutter/drawing_board/cubit/cubit.dart';
import 'package:as_drawingchallenge_flutter/drawing_repository/drawing_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:flutter_drawing_board/path_steps.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDrawingRepository extends Mock implements DrawingRepository {}

void main() {
  final drawing = Drawing(
    name: 'name',
    color: Colors.black,
    jsonList: [],
  );

  group('DrawingBoardCubit', () {
    late DrawingRepository repository;

    setUp(() {
      repository = MockDrawingRepository();
    });

    DrawingBoardCubit buildCubit() => DrawingBoardCubit(repository);

    test('initial state is DrawingBoardState', () {
      expect(
        buildCubit().state,
        DrawingBoardState(),
      );
    });

    group('loadDrawing', () {
      // TODO: Add test
    });

    group('save', () {
      final jsonList = [
        SimpleLine.data(
          paint: Paint(),
          path: DrawPath(),
        ).toJson(),
      ];

      final updatedDrawing = drawing.copyWith(jsonList: jsonList);

      blocTest<DrawingBoardCubit, DrawingBoardState>(
        'calls repository.save and emits updated drawing',
        setUp: () {
          when(() => repository.save(updatedDrawing)).thenAnswer(
            (_) async {},
          );
        },
        seed: () => DrawingBoardState(drawing: drawing),
        build: buildCubit,
        act: (cubit) => cubit.save(jsonList: jsonList),
        expect: () => [
          DrawingBoardState(
            drawing: updatedDrawing,
          ),
        ],
        verify: (_) {
          verify(() => repository.save(updatedDrawing)).called(1);
        },
      );
    });
  });
}
