import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';

import '../../bloc/draw/draw_bloc.dart';
import '../models/drawing_mode.dart';

class CanvasSideBar extends StatelessWidget {
  final DrawState state;

  const CanvasSideBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 3,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Text('Drawing Tools',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Divider(),
              _buildDrawingModeSelector(context, state),
              _buildSizeControls(
                  context, state, 'Stroke Size', state.strokeSize, (value) {
                BlocProvider.of<DrawBloc>(context).add(UpdateStrokeSize(value));
              }),
              _buildSizeControls(
                  context, state, 'Eraser Size', state.eraserSize, (value) {
                BlocProvider.of<DrawBloc>(context).add(UpdateEraserSize(value));
              }),
              SwitchListTile(
                title: const Text('Fill Shapes'),
                value: state.filled,
                onChanged: (value) {
                  BlocProvider.of<DrawBloc>(context)
                      .add(UpdateFilledStatus(value));
                },
              ),
              if (state.drawingMode == DrawingMode.polygon)
                _buildPolygonSidesSelector(context, state),
              const SizedBox(height: 20),
              _buildColorPalette(context, state),
              const SizedBox(height: 20),
              TextButton(
                  onPressed: () async {
                    ui.Image photo = await _getImage;
                    context.read<DrawBloc>().add(LoadImageEvent(photo));
                  },
                  child: Text('Add Background')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawingModeSelector(BuildContext context, DrawState state) {
    return Wrap(
      spacing: 8,
      children: DrawingMode.values
          .map((mode) => ChoiceChip(
                label: Text(describeEnum(mode)),
                selected: state.drawingMode == mode,
                onSelected: (_) {
                  // BlocProvider.of<CanvasBloc>(context).add(UpdateDrawingMode(mode));
                  BlocProvider.of<DrawBloc>(context)
                      .add(ChangeDrawingMode(mode));
                },
              ))
          .toList(),
    );
  }

  Widget _buildSizeControls(BuildContext context, DrawState state, String label,
      double currentValue, Function(double) onUpdate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Slider(
          value: currentValue,
          min: 0,
          max: 50,
          divisions: 10,
          label: currentValue.round().toString(),
          onChanged: (value) => onUpdate(value),
        ),
      ],
    );
  }

  Widget _buildPolygonSidesSelector(BuildContext context, DrawState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Polygon Sides (${state.polygonSides})'),
        Slider(
          value: state.polygonSides.toDouble(),
          min: 3,
          max: 10,
          divisions: 7,
          label: state.polygonSides.toString(),
          onChanged: (value) {
            BlocProvider.of<DrawBloc>(context)
                .add(UpdatePolygonSides(value.toInt()));
          },
        ),
      ],
    );
  }

  Widget _buildColorPalette(BuildContext context, DrawState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.color_lens),
          color: state.selectedColor,
          onPressed: () async {
            Color? newColor;
            await showDialog<Color>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Pick a color'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: state.selectedColor,
                      onColorChanged: (Color color) {
                        newColor = color;
                      },
                    ),
                  ),
                );
              },
            );
            if (newColor != null) {
              BlocProvider.of<DrawBloc>(context).add(UpdateColor(newColor!));
            }
          },
        ),
      ],
    );
  }

  Future<ui.Image> get _getImage async {
    final completer = Completer<ui.Image>();
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) {
      final file = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (file != null) {
        final filePath = file.files.single.path;
        final bytes = filePath == null
            ? file.files.first.bytes
            : File(filePath).readAsBytesSync();
        if (bytes != null) {
          completer.complete(decodeImageFromList(bytes));
        } else {
          completer.completeError('No image selected');
        }
      }
    } else {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();
        completer.complete(
          decodeImageFromList(bytes),
        );
      } else {
        completer.completeError('No image selected');
      }
    }

    return completer.future;
  }
}
