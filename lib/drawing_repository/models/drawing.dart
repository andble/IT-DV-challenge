import 'package:as_drawingchallenge_flutter/drawing_repository/drawing_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Drawing extends Equatable {
  const Drawing({
    required this.name,
    required this.color,
    required this.jsonList,
  });

  factory Drawing.fromJson(Map<String, dynamic> json) => Drawing(
        name: json['name'] as String,
        color: const ColorJsonConverter().fromJson(json['color'] as int),
        jsonList: (json['jsonList'] as List<dynamic>)
            .map((e) => e as Map<String, dynamic>)
            .toList(),
      );

  final String name;
  final Color color;
  final List<Map<String, dynamic>> jsonList;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'color': const ColorJsonConverter().toJson(color),
        'jsonList': jsonList,
      };

  Drawing copyWith({
    String? name,
    Color? color,
    List<Map<String, dynamic>>? jsonList,
  }) {
    return Drawing(
      name: name ?? this.name,
      color: color ?? this.color,
      jsonList: jsonList ?? this.jsonList,
    );
  }

  List<PaintContent> get contents {
    return jsonList.map((json) {
      final type = json['type'] as String;
      switch (type) {
        case 'SimpleLine':
          return SimpleLine.fromJson(json);
        case 'SmoothLine':
          return SmoothLine.fromJson(json);
        case 'StraightLine':
          return StraightLine.fromJson(json);
        case 'Rectangle':
          return Rectangle.fromJson(json);
        case 'Circle':
          return Circle.fromJson(json);
        case 'Eraser':
          return Eraser.fromJson(json);
        default:
          throw Exception('Unknown type: $type');
      }
    }).toList();
  }

  static const initial = Drawing(
    name: 'Drawing 1',
    color: Colors.black,
    jsonList: [],
  );

  @override
  List<Object> get props => [
        name,
        color,
        jsonList,
      ];
}
