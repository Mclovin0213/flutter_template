// Filename: scrollable_background.dart
// Description: This file specifies a widget which provides a scrollable
//              background image for a screen.

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ScrollableBackground extends StatefulWidget {
  // Widget Parameters
  double? height;
  bool? darkMode;
  Widget child;
  double padding;

  // Widget Constructor
  ScrollableBackground({
    super.key,
    this.height,
    required this.child,
    this.padding = 20,
  });

  @override
  State<ScrollableBackground> createState() => _ScrollableBackgroundState();
}

class _ScrollableBackgroundState extends State<ScrollableBackground> {
  // The "instance variables" managed in this state
  bool _isInit = true;
  // late DevicePreferencesProvider _devicePrefProvider;

  ////////////////////////////////////////////////////////////////////////
  // Runs the following code once upon initialization
  ////////////////////////////////////////////////////////////////////////
  @override
  void didChangeDependencies() {
    // If first time running this code, update provider settings
    if (_isInit) {
      _init();
    }

    // Now initialized; run super method
    _isInit = false;
    super.didChangeDependencies();
  }

  ////////////////////////////////////////////////////////////////////////
  // Obtains all providers and uses provider settings to initialize
  // screen (if needed).
  ////////////////////////////////////////////////////////////////////////
  _init() async {
    // _devicePrefProvider = Provider.of<DevicePreferencesProvider>(context);
  }

  ////////////////////////////////////////////////////////////////////////
  // Primary Flutter method overriden which describes the layout
  // and bindings for this widget.
  ////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      constraints: BoxConstraints(minHeight: screenHeight - 100),
      height: widget.height,
      child: widget.child,
      padding: EdgeInsets.all(widget.padding),
    );
  }
}
