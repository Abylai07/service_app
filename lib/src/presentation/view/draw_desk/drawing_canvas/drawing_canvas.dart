import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_plan_app/src/presentation/view/draw_desk/drawing_canvas/widgets/sketch_painter.dart';

import '../../../../common/app_styles/colors.dart';
import '../bloc/draw/draw_bloc.dart';
import 'models/sketch.dart';

class DrawingCanvas extends StatelessWidget {
  final double height;
  final double width;
  final GlobalKey canvasGlobalKey;
  final DrawState state;

  const DrawingCanvas({
    super.key,
    required this.height,
    required this.width,
    required this.canvasGlobalKey,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.precise,
      child: Stack(
        children: [
          buildAllSketches(context, state.allSketches, state.backgroundImage),
          Listener(
            onPointerDown: (details) => BlocProvider.of<DrawBloc>(context)
                .add(MyPointerDownEvent(details.localPosition)),
            onPointerMove: (details) => BlocProvider.of<DrawBloc>(context)
                .add(MyPointerMoveEvent(details.localPosition)),
            onPointerUp: (_) =>
                BlocProvider.of<DrawBloc>(context).add(MyPointerUpEvent()),
            child: buildCurrentPath(context, state.currentSketch),
          ),
        ],
      ),
    );
  }

  Widget buildAllSketches(BuildContext context, List<Sketch> allSketches,
      ui.Image? backgroundImage) {
    return SizedBox(
      height: height,
      width: width,
      child: RepaintBoundary(
        key: canvasGlobalKey,
        child: Container(
          height: height,
          width: width,
          color: AppColors.canvas,
          child: CustomPaint(
            painter: SketchPainter(
              sketches: allSketches,
              backgroundImage: backgroundImage,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCurrentPath(BuildContext context, Sketch? currentSketch) {
    return RepaintBoundary(
      child: SizedBox(
        height: height,
        width: width,
        child: CustomPaint(
          painter: SketchPainter(
            sketches: currentSketch == null ? [] : [currentSketch],
          ),
        ),
      ),
    );
  }

}
