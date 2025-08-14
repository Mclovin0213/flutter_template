// -----------------------------------------------------------------------
// Filename: screen_home.dart
// Description: This file contains the primary app bar.

// Flutter imports

// Flutter external package imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/theme/colors.dart';
import 'package:flutter_template/features/auth/providers/auth_provider.dart';

class WidgetPrimaryAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  // Constant parameters passedin
  final Widget title;
  final List<Widget>? actionButtons;
  bool inCurrentMeeting;

  WidgetPrimaryAppBar({
    Key? key,
    required this.title,
    this.actionButtons,
    this.inCurrentMeeting = false,
  }) : super(key: key);
  // UserData().updateProfileImage();

  @override
  ConsumerState<WidgetPrimaryAppBar> createState() => _PrimaryAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}

//////////////////////////////////////////////////////////////////
// The actual STATE which is managed by the above widget.
//////////////////////////////////////////////////////////////////
class _PrimaryAppBar extends ConsumerState<WidgetPrimaryAppBar> {
  // The "instance variables" managed in this state
  var _isInit = true;

  ////////////////////////////////////////////////////////////////
  // Gets the current state of the providers for consumption on
  // this page
  ////////////////////////////////////////////////////////////////
  _init() async {
    // Get providers
  }

  ////////////////////////////////////////////////////////////////
  // Runs the following code once upon initialization
  ////////////////////////////////////////////////////////////////
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

  ////////////////////////////////////////////////////////////////
  // Primary Flutter method overriden which describes the layout
  // and bindings for this widget.
  ////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    // Get the number of notifications

    return AppBar(
      title: widget.title,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: CustomColors.statusError),
          onPressed: () => {ref.read(authProvider.notifier).signOut()},
        ),
        if (widget.actionButtons != null)
          ...widget.actionButtons!.map((e) {
            return e;
          }).toList(),
      ],
    );
  }
}
