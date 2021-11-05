import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

enum ControllerType { defaultController, fromContext, fromFields }

class ScrollSheet extends StatefulWidget {
  ControllerType controllerType;
  PanelController? controller;
  EdgeInsets margin;
  double maxHeight;
  double minHeight;
  bool isDraggable;
  Widget panel;
  Widget? collapse;
  Widget body;

  ScrollSheet({
    Key? key,
    this.controllerType = ControllerType.defaultController,
    this.controller,
    this.margin = const EdgeInsets.fromLTRB(0, 50, 0, 0.0),
    required this.maxHeight,
    this.minHeight = 0,
    this.isDraggable = true,
    required this.panel,
    this.collapse,
    required this.body,
  });

  @override
  _ScrollSheetState createState() => _ScrollSheetState(
      controllerType,
      controller,
      margin,
      maxHeight,
      minHeight,
      isDraggable,
      panel,
      collapse,
      body);
}

class _ScrollSheetState extends State<ScrollSheet> {
  PanelController? controller;
  ControllerType controllerType;
  EdgeInsets margin;
  double maxHeight;
  double minHeight;
  bool isDraggable;
  Widget panel;
  Widget? collapse;
  Widget body;

  _ScrollSheetState(
      this.controllerType,
      this.controller,
      this.margin,
      this.maxHeight,
      this.minHeight,
      this.isDraggable,
      this.panel,
      this.collapse,
      this.body);

  @override
  void initState() {
    super.initState();
    switch (controllerType) {
      case ControllerType.defaultController:
        {
          controller = PanelController();
        }
        break;
      case ControllerType.fromContext:
        {
          assert(
              context.read<PanelController?>() != null,
              "Controller type equals ControllerType.fromContext."
              " This error is most likely caused because there is not a PanelController provider as an ancestor of this Widget");
          controller = context.read<PanelController>();
        }
        break;
      case ControllerType.fromFields:
        {
          assert(
              controller != null,
              "Controller type equals ControllerType.fromFields. "
              "This error is most likely because a valid controller wasn't provided from fields.");
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      double height = min(constraints.constrainHeight(), maxHeight);
      // print('Change constraints: ${constraints.constrainHeight()}');
      return SlidingUpPanel(
        controller: controller,
        backdropOpacity: 0.17,
        minHeight: minHeight,
        maxHeight: height,
        isDraggable: isDraggable,
        panel: panel,
        body: body,
        collapsed: collapse,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      );
    });
  }
}
