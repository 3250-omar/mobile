import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Defines the hierarchical platform back behavior across overlays, stacks, branches, and exit.
class BackNavigationPolicy {
  const BackNavigationPolicy._();

  /// Evaluates and handles platform back event following the approved contract:
  /// Overlay -> Nested Route -> Branch Root -> Home -> Exit.
  static bool handleBack(
    BuildContext context, {
    StatefulNavigationShell? shell,
  }) {
    final navigator = Navigator.maybeOf(context);
    if (navigator != null && navigator.canPop()) {
      navigator.pop();
      return true;
    }

    if (context.canPop()) {
      context.pop();
      return true;
    }

    if (shell != null && shell.currentIndex != 0) {
      shell.goBranch(0);
      return true;
    }

    // At Home root; allow platform system back to exit application.
    return false;
  }
}
