import 'package:dotto/importer.dart';
import 'package:dotto/theme/colors/semantic_colors.dart';

final class DottoButton extends ButtonStyleButton {
  const DottoButton({
    super.key,
    this.type = DottoButtonType.contained,
    this.shape = DottoButtonShape.rectangle,
    this.size = DottoButtonSize.medium,
    this.status = DottoButtonStatus.normal,
    this.isLoading = false,
    required super.onPressed,
    required super.child,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior = Clip.none,
  });

  final DottoButtonType type;
  final DottoButtonShape shape;
  final DottoButtonSize size;
  final DottoButtonStatus status;
  final bool isLoading;

  Color get backgroundColor {
    switch (status) {
      case DottoButtonStatus.normal:
        switch (type) {
          case DottoButtonType.contained:
            return SemanticColors.primaryMain;
          case DottoButtonType.outlined:
            return Colors.transparent;
          case DottoButtonType.text:
            return Colors.transparent;
        }
      case DottoButtonStatus.focused:
        switch (type) {
          case DottoButtonType.contained:
            return SemanticColors.primaryDark;
          case DottoButtonType.outlined:
            return SemanticColors.primaryLight;
          case DottoButtonType.text:
            return SemanticColors.primaryLight;
        }
      case DottoButtonStatus.disabled:
        switch (type) {
          case DottoButtonType.contained:
            return SemanticColors.backgroundDisabled;
          case DottoButtonType.outlined:
            return Colors.transparent;
          case DottoButtonType.text:
            return Colors.transparent;
        }
    }
  }

  Color get foregroundColor {
    switch (status) {
      case DottoButtonStatus.normal:
        switch (type) {
          case DottoButtonType.contained:
            return SemanticColors.textOnColor;
          case DottoButtonType.outlined:
            return SemanticColors.primaryMain;
          case DottoButtonType.text:
            return SemanticColors.primaryMain;
        }
      case DottoButtonStatus.focused:
        switch (type) {
          case DottoButtonType.contained:
            return SemanticColors.textOnColor;
          case DottoButtonType.outlined:
            return SemanticColors.primaryMain;
          case DottoButtonType.text:
            return SemanticColors.primaryMain;
        }
      case DottoButtonStatus.disabled:
        switch (type) {
          case DottoButtonType.contained:
            return SemanticColors.textDisabled;
          case DottoButtonType.outlined:
            return SemanticColors.textDisabled;
          case DottoButtonType.text:
            return SemanticColors.textDisabled;
        }
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

  Color get strokeColor {
    switch (status) {
      case DottoButtonStatus.normal:
        switch (type) {
          case DottoButtonType.contained:
            return Colors.transparent;
          case DottoButtonType.outlined:
            return SemanticColors.primaryLight;
          case DottoButtonType.text:
            return Colors.transparent;
        }
      case DottoButtonStatus.focused:
        switch (type) {
          case DottoButtonType.contained:
            return Colors.transparent;
          case DottoButtonType.outlined:
            return SemanticColors.primaryMain;
          case DottoButtonType.text:
            return Colors.transparent;
        }
      case DottoButtonStatus.disabled:
        switch (type) {
          case DottoButtonType.contained:
            return Colors.transparent;
          case DottoButtonType.outlined:
            return SemanticColors.borderDivider;
          case DottoButtonType.text:
            return Colors.transparent;
        }
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
        return CircleBorder(
          side: BorderSide(color: strokeColor),
        );
    }
  }

  @override
  ButtonStyle defaultStyleOf(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      shape: borderShape,
      padding: padding,
    );
  }

  @override
  ButtonStyle? themeStyleOf(BuildContext context) {
    return ElevatedButtonTheme.of(context).style;
  }
}

enum DottoButtonType {
  contained,
  outlined,
  text,
}

enum DottoButtonShape {
  rectangle,
  circle,
}

enum DottoButtonSize {
  small,
  medium,
}

enum DottoButtonStatus {
  normal,
  focused,
  disabled,
}
