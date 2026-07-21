import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Horizontally scrollable row showing the icons of the currently
/// selected apps/categories.
///
/// Apple's Screen Time API keeps the selection opaque, so the icons are
/// rendered natively (SwiftUI `Label(token)`) and embedded as a platform
/// view. The row updates automatically after the picker saves a new
/// selection.
///
/// Renders nothing on non-iOS platforms. On the Simulator or iOS < 16
/// the native side falls back to an empty view.
class SelectedAppIconsView extends StatelessWidget {
  const SelectedAppIconsView({
    super.key,
    this.height = 48,
    this.iconSize = 40,
    this.spacing = 8,
  });

  /// Height of the embedded native view.
  final double height;

  /// Rendered size of each icon. Approximate — the icon itself is drawn
  /// by the system and scaled to fit.
  final double iconSize;

  /// Horizontal gap between icons.
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) return const SizedBox.shrink();
    return SizedBox(
      height: height,
      child: UiKitView(
        viewType: 'flutter_family_controls/selected_app_icons',
        creationParams: {'iconSize': iconSize, 'spacing': spacing},
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }
}
