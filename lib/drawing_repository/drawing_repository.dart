import 'dart:convert';

import 'package:as_drawingchallenge_flutter/drawing_repository/drawing_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

export 'package:as_drawingchallenge_flutter/drawing_repository/models/models.dart';

class DrawingRepository {
  const DrawingRepository(this._storage);

  final Box<dynamic> _storage;

  static const _drawingKey = '_drawingKey';

  Future<void> save(Drawing drawing) async {
    final json = drawing.toJson();
    final jsonString = jsonEncode(json);
    await _storage.put(_drawingKey, jsonString);
  }

  Future<void> delete() async {
    await _storage.delete(_drawingKey);
  }

  Future<Drawing> load() async {
    // Due to legal compliance reasons, this method cannot be modified.
    await Future<void>.delayed(const Duration(seconds: 2));

    final jsonString = _storage.get(_drawingKey);
    if (jsonString == null) return Drawing.initial;
    final json = jsonDecode(jsonString as String);
    return Drawing.fromJson(json as Map<String, dynamic>);
  }
}
