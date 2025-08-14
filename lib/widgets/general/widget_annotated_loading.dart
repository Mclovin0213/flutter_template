// Dart imports
import 'dart:async';

// Flutter external package imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// App relative file imports
import '../../util/logging/app_logger.dart';
import '../../providers/auth_provider.dart';
import '../../util/message_display/snackbar.dart';

//////////////////////////////////////////////////////////////////
// A stateful widget to display a loading animation with text and an
// optional timeout feature. It remains a ConsumerStatefulWidget
// because it manages its own internal state (the Timer).
//////////////////////////////////////////////////////////////////
class WidgetAnnotatedLoading extends ConsumerStatefulWidget {
  final String loadingText;
  final List<String>? loadingTexts;
  final double height;
  final bool timeOutEnabled;
  final int timeOutSecs;
  final String timeOutTextPrefix;
  final int timeOutCountdownBeginsAtSecs;
  final bool timeOutSignsOut;
  final bool quietTimeOut;
  final VoidCallback? timeOutCallback;

  const WidgetAnnotatedLoading({
    super.key,
    this.loadingText = "",
    this.loadingTexts,
    this.height = 250,
    this.timeOutEnabled = false,
    this.timeOutSecs = 15,
    this.timeOutTextPrefix = "Loading",
    this.timeOutCountdownBeginsAtSecs = 5,
    this.timeOutSignsOut = false,
    this.quietTimeOut = false,
    this.timeOutCallback,
  });

  @override
  ConsumerState<WidgetAnnotatedLoading> createState() =>
      _WidgetAnnotatedLoadingState();
}

class _WidgetAnnotatedLoadingState
    extends ConsumerState<WidgetAnnotatedLoading> {
  Timer? _timeoutTimer;
  int _countDownSecs = 0;
  int _displayIndex = 0;

  ////////////////////////////////////////////////////////////////
  // Runs once when the widget is first inserted into the widget tree.
  ////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    // Start the timer if it's enabled.
    _startTimer();
  }

  ////////////////////////////////////////////////////////////////
  // Called when the widget's configuration changes (e.g., the parent
  // rebuilds with new properties). This replaces the complex static
  // variable logic from the original code.
  ////////////////////////////////////////////////////////////////
  @override
  void didUpdateWidget(WidgetAnnotatedLoading oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the timeout configuration has changed, we should restart the timer
    // with the new settings. This is much safer than trying to modify a
    // running timer.
    if (widget.timeOutEnabled != oldWidget.timeOutEnabled ||
        widget.timeOutSecs != oldWidget.timeOutSecs ||
        widget.loadingText != oldWidget.loadingText) {
      _timeoutTimer?.cancel();
      _startTimer();
    }
  }

  ////////////////////////////////////////////////////////////////
  // Helper method to initialize and start the timeout timer.
  ////////////////////////////////////////////////////////////////
  void _startTimer() {
    if (widget.timeOutEnabled) {
      // Initialize countdown state
      setState(() {
        _countDownSecs = widget.timeOutSecs;
        _displayIndex = 0; // Reset text index
      });

      AppLogger.print(
        "TIMER INIT: ${widget.timeOutSecs}s for '${getLoadingText()}'",
      );

      _timeoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        // If the widget is no longer in the tree, stop the timer.
        if (!mounted) {
          timer.cancel();
          return;
        }

        final int currentTick = timer.tick;
        final newCountDown = widget.timeOutSecs - currentTick;

        // Update the state for the UI
        setState(() {
          _countDownSecs = newCountDown;
          // Cycle through loading texts every 5 seconds if they exist
          if (currentTick > 0 &&
              currentTick % 5 == 0 &&
              widget.loadingTexts != null) {
            _displayIndex = (_displayIndex + 1) % widget.loadingTexts!.length;
          }
        });

        // Check if the timer has expired
        if (newCountDown <= 0) {
          AppLogger.debug("TIMER EXPIRED: '${getLoadingText()}'");
          timer.cancel();
          _handleTimeout();
        }
      });
    }
  }

  ////////////////////////////////////////////////////////////////
  // Handles the logic when the timer expires.
  ////////////////////////////////////////////////////////////////
  void _handleTimeout() {
    // Ensure the widget is still mounted before showing UI or calling callbacks
    if (!mounted) return;

    if (widget.timeOutSignsOut) {
      Snackbar.show(
        SnackbarDisplayType.SB_ERROR,
        "${widget.timeOutTextPrefix} took too long; logging out for your security. Please check your internet connection and try again.",
        context,
      );
      // Use ref.read to call the action on the auth provider notifier
      ref.read(authProvider.notifier).signOut();
    } else {
      // Execute the generic callback if provided
      widget.timeOutCallback?.call();

      if (!widget.quietTimeOut) {
        Snackbar.show(
          SnackbarDisplayType.SB_ERROR,
          "${widget.timeOutTextPrefix} took too long. Please check your internet connection.",
          context,
        );
      }
    }
  }

  ////////////////////////////////////////////////////////////////
  // Runs when the widget is permanently removed from the tree.
  ////////////////////////////////////////////////////////////////
  @override
  void dispose() {
    _timeoutTimer?.cancel();
    AppLogger.print("TIMER CANCELLED on dispose for '${getLoadingText()}'");
    super.dispose();
  }

  ////////////////////////////////////////////////////////////////
  // Gets the current loading text to display.
  ////////////////////////////////////////////////////////////////
  String getLoadingText() {
    final texts = widget.loadingTexts;
    if (texts != null && texts.isNotEmpty) {
      return texts[_displayIndex % texts.length];
    }
    return widget.loadingText;
  }

  ////////////////////////////////////////////////////////////////
  // Describes the part of the user interface represented by this widget.
  ////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    final currentLoadingText = getLoadingText();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Lottie.asset(
            'animations/CI.json',
            animate: true,
            height: widget.height,
          ),
        ),
        if (currentLoadingText.isNotEmpty) ...[
          const SizedBox(height: 10),
          Center(
            child: Text(
              currentLoadingText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ],
        if (widget.timeOutEnabled &&
            _countDownSecs <= widget.timeOutCountdownBeginsAtSecs &&
            !widget.quietTimeOut) ...[
          const SizedBox(height: 8),
          Center(
            child: Text(
              _countDownSecs > 0
                  ? "Timing out in $_countDownSecs seconds..."
                  : "Timing out...",
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ],
    );
  }
}
