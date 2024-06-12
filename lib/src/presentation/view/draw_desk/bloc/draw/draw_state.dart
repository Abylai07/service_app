part of 'draw_bloc.dart';

class DrawState {
  final DrawingMode drawingMode;
  final Color selectedColor;
  final double strokeSize;
  final double eraserSize;
  final bool filled;
  final int polygonSides;
  final ui.Image? backgroundImage;
  final List<Sketch> allSketches;
  final List<Sketch> redoStack;
  final Sketch? currentSketch;
  final bool canRedo;

  DrawState({
    this.drawingMode = DrawingMode.pencil,
    this.selectedColor = Colors.black,
    this.strokeSize = 10,
    this.eraserSize = 30,
    this.filled = false,
    this.canRedo = false,
    this.polygonSides = 3,
    this.backgroundImage,
    this.allSketches = const [],
    this.redoStack = const [],
    this.currentSketch,
  });

  DrawState copyWith({
    DrawingMode? drawingMode,
    Color? selectedColor,
    double? strokeSize,
    double? eraserSize,
    bool? filled,
    bool? canRedo,
    int? polygonSides,
    ui.Image? backgroundImage,
    List<Sketch>? allSketches,
    List<Sketch>? redoStack,
    Sketch? currentSketch,
  }) {
    return DrawState(
      drawingMode: drawingMode ?? this.drawingMode,
      selectedColor: selectedColor ?? this.selectedColor,
      strokeSize: strokeSize ?? this.strokeSize,
      eraserSize: eraserSize ?? this.eraserSize,
      filled: filled ?? this.filled,
      canRedo: canRedo ?? this.canRedo,
      polygonSides: polygonSides ?? this.polygonSides,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      allSketches: allSketches ?? this.allSketches,
      redoStack: redoStack ?? this.redoStack,
      currentSketch: currentSketch ?? this.currentSketch,
    );
  }
}

