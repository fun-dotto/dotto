import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';

final class _CircularProgressIndicatorInButton extends StatelessWidget {
  const _CircularProgressIndicatorInButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          color: SemanticColor.light.labelSecondary,
          strokeWidth: 2,
        ),
      ),
    );
  }
}

final class DottoButton extends ButtonStyleButton {
  const DottoButton({
    required VoidCallback? onPressed,
    required Widget? child,
    super.key,
    this.type = DottoButtonType.contained,
    this.shape = DottoButtonShape.rectangle,
    this.size = DottoButtonSize.medium,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior = Clip.none,
  }) : super(
         onPressed: child != null ? onPressed : null,
         child: child ?? const _CircularProgressIndicatorInButton(),
       );

  final DottoButtonType type;
  final DottoButtonShape shape;
  final DottoButtonSize size;

  bool get isDisabled => onPressed == null;

  Color get backgroundColor {
    if (isDisabled) {
      return disabledBackgroundColor;
    }
    switch (type) {
      case DottoButtonType.contained:
        return SemanticColor.light.accentPrimary;
      case DottoButtonType.outlined:
        return Colors.transparent;
      case DottoButtonType.text:
        return Colors.transparent;
    }
  }

  Color get foregroundColor {
    if (isDisabled) {
      return disabledForegroundColor;
    }
    switch (type) {
      case DottoButtonType.contained:
        return SemanticColor.light.labelTertiary;
      case DottoButtonType.outlined:
        return SemanticColor.light.accentPrimary;
      case DottoButtonType.text:
        return SemanticColor.light.accentPrimary;
    }
  }

  Color get disabledBackgroundColor {
    switch (type) {
      case DottoButtonType.contained:
        return SemanticColor.light.backgroundTertiary;
      case DottoButtonType.outlined:
        return Colors.transparent;
      case DottoButtonType.text:
        return Colors.transparent;
    }
  }

  Color get disabledForegroundColor {
    switch (type) {
      case DottoButtonType.contained:
        return SemanticColor.light.labelSecondary;
      case DottoButtonType.outlined:
        return SemanticColor.light.labelSecondary;
      case DottoButtonType.text:
        return SemanticColor.light.labelSecondary;
    }
  }

  Color get strokeColor {
    switch (type) {
      case DottoButtonType.contained:
        return Colors.transparent;
      case DottoButtonType.outlined:
        return isDisabled
            ? SemanticColor.light.borderPrimary
            : SemanticColor.light.accentPrimary;
      case DottoButtonType.text:
        return Colors.transparent;
    }
  }

  OutlinedBorder get borderShape {
    switch (shape) {
      case DottoButtonShape.rectangle:
        return RoundedRectangleBorder(
          side: BorderSide(color: strokeColor),
          borderRadius: BorderRadius.circular(8),
        );
      case DottoButtonShape.circle:
        return CircleBorder(side: BorderSide(color: strokeColor));
    }
  }

  EdgeInsets get padding {
    switch (shape) {
      case DottoButtonShape.rectangle:
        return const EdgeInsets.symmetric(vertical: 8, horizontal: 24);
      case DottoButtonShape.circle:
        return EdgeInsets.zero;
    }
  }

  static ButtonStyle styleFrom({
    Color? foregroundColor,
    Color? backgroundColor,
    Color? disabledForegroundColor,
    Color? disabledBackgroundColor,
    Color? shadowColor,
    Color? surfaceTintColor,
    Color? iconColor,
    double? iconSize,
    IconAlignment? iconAlignment,
    Color? disabledIconColor,
    Color? overlayColor,
    double? elevation,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
    Size? minimumSize,
    Size? fixedSize,
    Size? maximumSize,
    BorderSide? side,
    OutlinedBorder? shape,
    MouseCursor? enabledMouseCursor,
    MouseCursor? disabledMouseCursor,
    VisualDensity? visualDensity,
    MaterialTapTargetSize? tapTargetSize,
    Duration? animationDuration,
    bool? enableFeedback,
    AlignmentGeometry? alignment,
    InteractiveInkFeatureFactory? splashFactory,
    ButtonLayerBuilder? backgroundBuilder,
    ButtonLayerBuilder? foregroundBuilder,
  }) {
    final overlayColorProp = switch ((foregroundColor, overlayColor)) {
      (null, null) => null,
      (_, Color(a: 0.0)) => WidgetStatePropertyAll<Color?>(overlayColor),
      (_, final Color color) || (final Color color, _) =>
        WidgetStateProperty<Color?>.fromMap(<WidgetState, Color?>{
          WidgetState.pressed: color.withAlpha(25),
          WidgetState.hovered: color.withAlpha(20),
          WidgetState.focused: color.withAlpha(25),
        }),
    };

    WidgetStateProperty<double>? elevationValue;
    if (elevation != null) {
      elevationValue = WidgetStateProperty<double>.fromMap(
        <WidgetStatesConstraint, double>{
          WidgetState.disabled: 0,
          WidgetState.pressed: elevation + 6,
          WidgetState.hovered: elevation + 2,
          WidgetState.focused: elevation + 2,
          WidgetState.any: elevation,
        },
      );
    }

    return ButtonStyle(
      textStyle: WidgetStatePropertyAll<TextStyle?>(textStyle),
      backgroundColor: ButtonStyleButton.defaultColor(
        backgroundColor,
        disabledBackgroundColor,
      ),
      foregroundColor: ButtonStyleButton.defaultColor(
        foregroundColor,
        disabledForegroundColor,
      ),
      overlayColor: overlayColorProp,
      shadowColor: ButtonStyleButton.allOrNull<Color>(shadowColor),
      surfaceTintColor: ButtonStyleButton.allOrNull<Color>(surfaceTintColor),
      iconColor: ButtonStyleButton.defaultColor(iconColor, disabledIconColor),
      iconSize: ButtonStyleButton.allOrNull<double>(iconSize),
      iconAlignment: iconAlignment,
      elevation: elevationValue,
      padding: ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(padding),
      minimumSize: ButtonStyleButton.allOrNull<Size>(minimumSize),
      fixedSize: ButtonStyleButton.allOrNull<Size>(fixedSize),
      maximumSize: ButtonStyleButton.allOrNull<Size>(maximumSize),
      side: ButtonStyleButton.allOrNull<BorderSide>(side),
      shape: ButtonStyleButton.allOrNull<OutlinedBorder>(shape),
      mouseCursor: WidgetStateProperty<MouseCursor?>.fromMap(
        <WidgetStatesConstraint, MouseCursor?>{
          WidgetState.disabled: disabledMouseCursor,
          WidgetState.any: enabledMouseCursor,
        },
      ),
      visualDensity: visualDensity,
      tapTargetSize: tapTargetSize,
      animationDuration: animationDuration,
      enableFeedback: enableFeedback,
      alignment: alignment,
      splashFactory: splashFactory,
      backgroundBuilder: backgroundBuilder,
      foregroundBuilder: foregroundBuilder,
    );
  }

  @override
  ButtonStyle defaultStyleOf(BuildContext context) {
    return styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledForegroundColor: disabledForegroundColor,
      shadowColor: Colors.transparent,
      elevation: 0,
      textStyle: Theme.of(context).textTheme.bodyMedium,
      padding: padding,
      minimumSize: const Size(44, 44),
      maximumSize: const Size(double.infinity, 44),
      shape: borderShape,
      enabledMouseCursor: SystemMouseCursors.click,
      disabledMouseCursor: SystemMouseCursors.basic,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      animationDuration: Duration.zero,
      enableFeedback: false,
      alignment: Alignment.center,
    );
  }

  @override
  ButtonStyle? themeStyleOf(BuildContext context) {
    return ElevatedButtonTheme.of(context).style;
  }
}

enum DottoButtonType { contained, outlined, text }

enum DottoButtonShape { rectangle, circle }

enum DottoButtonSize { small, medium }
