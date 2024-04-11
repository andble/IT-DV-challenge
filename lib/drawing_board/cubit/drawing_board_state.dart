import 'package:as_drawingchallenge_flutter/drawing_repository/drawing_repository.dart';
import 'package:equatable/equatable.dart';

enum Status {
  initial,
  loading,
  success,
  failure;

  bool get isLoading => this == loading;
  bool get isSuccess => this == success;
  bool get isFailure => this == failure;
}

class DrawingBoardState extends Equatable {
  const DrawingBoardState({
    this.status = Status.initial,
    this.drawing = Drawing.initial,
  });

  final Status status;
  final Drawing drawing;

  DrawingBoardState copyWith({
    Status? status,
    Drawing? drawing,
  }) {
    return DrawingBoardState(
      status: status ?? this.status,
      drawing: drawing ?? this.drawing,
    );
  }

  @override
  List<Object?> get props => [
        status,
        drawing,
      ];
}
