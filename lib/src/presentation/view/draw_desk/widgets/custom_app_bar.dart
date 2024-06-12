import 'dart:ui' as ui;
import 'package:universal_html/html.dart' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_plan_app/src/presentation/view/draw_desk/bloc/draw/draw_bloc.dart';
import 'package:my_plan_app/src/presentation/widgets/alert_dialog/export_alert_dialog.dart';
import 'package:file_saver/file_saver.dart';
import '../drawing_canvas/models/sketch.dart';

class CustomAppBar extends StatelessWidget {
  final AnimationController animationController;
  final GlobalKey canvasGlobalKey;
  final DrawState state;

  const CustomAppBar({
    super.key,
    required this.animationController,
    required this.canvasGlobalKey,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                if (animationController.value == 0) {
                  animationController.forward();
                } else {
                  animationController.reverse();
                }
              },
              icon: const Icon(Icons.menu),
            ),
            TextButton(
              onPressed: state.allSketches.isNotEmpty
                  ? () => context.read<DrawBloc>().add(UndoEvent())
                  : null,
              child: const Text('Undo'),
            ),
            TextButton(
              onPressed: state.canRedo
                  ? () => context.read<DrawBloc>().add(RedoEvent())
                  : null,
              child: const Text('Redo'),
            ),
            TextButton(
              onPressed: () => context.read<DrawBloc>().add(ClearEvent()),
              child: const Text('Clear'),
            ),
            TextButton(
              onPressed: () {
               // context.read<DrawBloc>().add(SaveEvent('png'));
                exportAlertDialog(context, title: 'Export Type',
                    onJpgTap: () async {
                      Uint8List? pngBytes = await getBytes();
                      if (pngBytes != null) saveFile(pngBytes, 'png');
                      Navigator.pop(context);
                    }, onPngTap: () async {
                      Uint8List? pngBytes = await getBytes();
                      if (pngBytes != null) saveFile(pngBytes, 'jpeg');
                      Navigator.pop(context);
                    });

              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List?> getBytes() async {
    RenderRepaintBoundary boundary = canvasGlobalKey.currentContext
        ?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? pngBytes = byteData?.buffer.asUint8List();
    return pngBytes;
  }

  void saveFile(Uint8List bytes, String extension) async {
    if (kIsWeb) {
      html.AnchorElement()
        ..href = '${Uri.dataFromBytes(bytes, mimeType: 'image/$extension')}'
        ..download =
            'FlutterLetsDraw-${DateTime.now().toIso8601String()}.$extension'
        ..style.display = 'none'
        ..click();
    } else {
      await FileSaver.instance.saveFile(
        name: 'FlutterLetsDraw-${DateTime.now().toIso8601String()}.$extension',
        bytes: bytes,
        ext: extension,
        mimeType: extension == 'png' ? MimeType.png : MimeType.jpeg,
      );
    }
  }

}

