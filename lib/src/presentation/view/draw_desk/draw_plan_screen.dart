import 'package:floating_menu_panel/floating_menu_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_plan_app/src/presentation/view/draw_desk/bloc/draw/draw_bloc.dart';
import 'package:my_plan_app/src/presentation/view/draw_desk/widgets/custom_app_bar.dart';

import '../../../common/app_styles/colors.dart';
import 'drawing_canvas/drawing_canvas.dart';
import 'drawing_canvas/models/drawing_mode.dart';
import 'drawing_canvas/widgets/canvas_side_bar.dart';

class DrawPlanScreen extends StatefulWidget {
  const DrawPlanScreen({super.key});

  @override
  State<DrawPlanScreen> createState() => _DrawPlanScreenState();
}

class _DrawPlanScreenState extends State<DrawPlanScreen> with TickerProviderStateMixin{
  final canvasGlobalKey = GlobalKey();


  getDrawMode(int index){
    switch(index){
      case 0:
        return DrawingMode.pencil;
      case 1:
        return DrawingMode.line;
      case 2:
        return DrawingMode.polygon;
      case 3:
        return DrawingMode.eraser;
      case 4:
        return DrawingMode.square;
      case 5:
        return DrawingMode.circle;
    }
  }

  List<IconData>? icons = const [
    FontAwesomeIcons.pencil,
    FontAwesomeIcons.linesLeaning,
    Icons.hexagon_outlined,
    FontAwesomeIcons.eraser,
    FontAwesomeIcons.square,
    FontAwesomeIcons.circle,
  ];

  @override
  Widget build(BuildContext context) {
    final animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    print('new state');
    int selectIndex = 0;

    return Scaffold(
      body: BlocBuilder<DrawBloc, DrawState>(
        builder: (context, state) {
          return SafeArea(
            child: Stack(
              children: [
                Container(
                  color: AppColors.canvas,
                  width: double.maxFinite,
                  height: double.maxFinite,
                  child: DrawingCanvas(
                    state: state,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    canvasGlobalKey: canvasGlobalKey,
                  ),
                ),
                Positioned(
                  top: kToolbarHeight + 10,
                  // left: -5,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-1, 0),
                      end: Offset.zero,
                    ).animate(animationController),
                    child: CanvasSideBar(
                      state: state,
                    ),
                  ),
                ),
                CustomAppBar(
                  animationController: animationController,
                  canvasGlobalKey: canvasGlobalKey,
                  state: state,
                ),
                FloatingMenuPanel(
                  positionTop: 60.0, // Initial Top Position
                  positionLeft: 6.0,
                  onPressed: (index) {
                    selectIndex = index;
                    context.read<DrawBloc>().add(ChangeDrawingMode(getDrawMode(index)!));
                  },
                  panelIcon: icons?[selectIndex],
                  buttons: icons,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
