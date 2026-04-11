import 'package:flutter/material.dart';
import 'package:people_browser/core/export.dart';

class FavoriteIconButton extends StatelessWidget {
  const FavoriteIconButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
    this.useFilledStyle = false,
  });

  final bool isFavorite;
  final VoidCallback onPressed;
  final bool useFilledStyle;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return AnimatedSwitcher(
      duration: AppConstants.favoriteToggleAnimationDuration,
      transitionBuilder: (child, animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: IconButton(
        key: ValueKey((isFavorite, useFilledStyle)),
        visualDensity: VisualDensity.compact,
        splashRadius: AppSizes.favoriteButtonSplashRadius,
        tooltip: isFavorite
            ? AppStrings.removeSavedPerson
            : AppStrings.savePerson,
        onPressed: onPressed,
        icon: Icon(
          _resolveIcon(),
          color: isFavorite
              ? AppColors.heartRed
              : AppColors.textMutedFor(brightness),
        ),
      ),
    );
  }

  IconData _resolveIcon() {
    if (useFilledStyle) {
      return isFavorite ? Icons.favorite : Icons.favorite_border;
    }

    return isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded;
  }
}
