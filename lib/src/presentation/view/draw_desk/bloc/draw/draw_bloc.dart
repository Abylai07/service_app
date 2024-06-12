import 'dart:ui' as ui;

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_plan_app/src/common/utils/shared_preference.dart';

import '../../../../../common/app_styles/colors.dart';
import '../../drawing_canvas/models/drawing_mode.dart';
import '../../drawing_canvas/models/sketch.dart';

part 'draw_event.dart';
part 'draw_state.dart';

class DrawBloc extends Bloc<DrawEvent, DrawState> {
  DrawBloc() : super(DrawState()) {
    on<ChangeDrawingMode>(
        (event, emit) => emit(state.copyWith(drawingMode: event.mode)));
    on<UpdateColor>(
        (event, emit) => emit(state.copyWith(selectedColor: event.color)));
    on<UpdateStrokeSize>(
        (event, emit) => emit(state.copyWith(strokeSize: event.size)));
    on<UpdateEraserSize>(
        (event, emit) => emit(state.copyWith(eraserSize: event.size)));
    on<UpdateFilledStatus>(
        (event, emit) => emit(state.copyWith(filled: event.filled)));
    on<UpdatePolygonSides>(
        (event, emit) => emit(state.copyWith(polygonSides: event.sides)));
    // Handle other events similarly
    on<MyPointerDownEvent>(_onPointerDown);
    on<MyPointerMoveEvent>(_onPointerMove);
    on<MyPointerUpEvent>(_onPointerUp);

    //AppBar
    on<UndoEvent>(_onUndo);
    on<RedoEvent>(_onRedo);
    on<ClearEvent>(_onClear);
    on<SaveEvent>(_onSave);
    on<LoadImageEvent>(_onLoadImage);
    on<UpdateSketchListEvent>(_onUpdateSketchList);
  }

  void _onPointerDown(MyPointerDownEvent event, Emitter<DrawState> emit) {
    final sketch = Sketch.fromDrawingMode(
      Sketch(
        points: [event.position],
        size: state.drawingMode == DrawingMode.eraser
            ? state.eraserSize
            : state.strokeSize,
        color: state.drawingMode == DrawingMode.eraser
            ? AppColors.canvas
            : state.selectedColor,
        sides: state.polygonSides,
      ),
      state.drawingMode,
      state.filled,
    );
    emit(state.copyWith(currentSketch: sketch));
  }

  void _onPointerMove(MyPointerMoveEvent event, Emitter<DrawState> emit) {
    if (state.currentSketch != null) {
      final points = List<Offset>.from(state.currentSketch!.points)
        ..add(event.position);
      final sketch = Sketch.fromDrawingMode(
        Sketch(
          points: points,
          size: state.drawingMode == DrawingMode.eraser
              ? state.eraserSize
              : state.strokeSize,
          color: state.drawingMode == DrawingMode.eraser
              ? AppColors.canvas
              : state.selectedColor,
          sides: state.polygonSides,
        ),
        state.drawingMode,
        state.filled,
      );
      emit(state.copyWith(currentSketch: sketch));
    }
  }

  void _onPointerUp(MyPointerUpEvent event, Emitter<DrawState> emit) {
    if (state.currentSketch != null) {
      final newSketches = List<Sketch>.from(state.allSketches)
        ..add(state.currentSketch!);
      emit(state.copyWith(
          allSketches: newSketches,
          currentSketch: Sketch.fromDrawingMode(
              Sketch(
                points: [],
                size: state.drawingMode == DrawingMode.eraser
                    ? state.eraserSize
                    : state.strokeSize,
                color: state.drawingMode == DrawingMode.eraser
                    ? AppColors.canvas
                    : state.selectedColor,
                sides: state.polygonSides,
              ),
              state.drawingMode,
              state.filled)));
    }
  }


  void _onUndo(UndoEvent event, Emitter<DrawState> emit) {
    if (state.allSketches.isNotEmpty) {
      final List<Sketch> updatedSketches = List<Sketch>.from(state.allSketches);
      final Sketch lastSketch = updatedSketches.removeLast();
      final List<Sketch> updatedRedoStack = List<Sketch>.from(state.redoStack)..add(lastSketch);
      emit(state.copyWith(allSketches: updatedSketches, redoStack: updatedRedoStack, canRedo: true));
    }
  }

  void _onRedo(RedoEvent event, Emitter<DrawState> emit) {
    if (state.redoStack.isNotEmpty) {
      final List<Sketch> updatedSketches = List<Sketch>.from(state.allSketches);
      final Sketch sketch = state.redoStack.last;
      updatedSketches.add(sketch);
      final List<Sketch> updatedRedoStack = List<Sketch>.from(state.redoStack)..removeLast();
      emit(state.copyWith(allSketches: updatedSketches, redoStack: updatedRedoStack, canRedo: updatedRedoStack.isNotEmpty));
    }
  }

  void _onClear(ClearEvent event, Emitter<DrawState> emit) {
    emit(state.copyWith(allSketches: [], redoStack: [], canRedo: false));
  }

  void _onSave(SaveEvent event, Emitter<DrawState> emit) {
    // Implement saving logic, possibly involving file system or external storage
  }

  void _onLoadImage(LoadImageEvent event, Emitter<DrawState> emit) {
    emit(state.copyWith(backgroundImage: event.image));
  }

  void _onUpdateSketchList(UpdateSketchListEvent event, Emitter<DrawState> emit) {
    emit(state.copyWith(allSketches: event.sketches));
  }
}
