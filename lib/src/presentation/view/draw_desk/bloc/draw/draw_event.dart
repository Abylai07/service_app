part of 'draw_bloc.dart';

abstract class DrawEvent {}

class ChangeDrawingMode extends DrawEvent {
  final DrawingMode mode;
  ChangeDrawingMode(this.mode);
}

class UpdateColor extends DrawEvent {
  final Color color;
  UpdateColor(this.color);
}

class UpdateStrokeSize extends DrawEvent {
  final double size;
  UpdateStrokeSize(this.size);
}

class UpdateEraserSize extends DrawEvent {
  final double size;
  UpdateEraserSize(this.size);
}

class UpdateFilledStatus extends DrawEvent {
  final bool filled;
  UpdateFilledStatus(this.filled);
}

class MyPointerDownEvent extends DrawEvent {
  final Offset position;
  MyPointerDownEvent(this.position);
}

class MyPointerMoveEvent extends DrawEvent {
  final Offset position;
  MyPointerMoveEvent(this.position);
}

class UpdatePolygonSides extends DrawEvent {
  final int sides;
  UpdatePolygonSides(this.sides);
}

class MyPointerUpEvent extends DrawEvent {}


//AppBar


class UndoEvent extends DrawEvent {}

class RedoEvent extends DrawEvent {}

class ClearEvent extends DrawEvent {}

class SaveEvent extends DrawEvent {
  final String format;
  SaveEvent(this.format);
}

class LoadImageEvent extends DrawEvent {
  final ui.Image image;
  LoadImageEvent(this.image);
}

class UpdateSketchListEvent extends DrawEvent {
  final List<Sketch> sketches;
  UpdateSketchListEvent(this.sketches);
}


