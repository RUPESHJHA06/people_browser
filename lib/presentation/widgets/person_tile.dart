import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:people_browser/core/export.dart';
import 'package:people_browser/domain/export.dart';
import 'package:people_browser/presentation/export.dart';

class PersonTile extends StatelessWidget {
  const PersonTile({
    super.key,
    required this.person,
    required this.onTap,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  final Person person;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.personTileVerticalPadding,
      ),
      child: Material(
        elevation: AppSizes.personTileElevation,
        shadowColor: Colors.black.withValues(
          alpha: AppSizes.personTileShadowOpacity,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        color: theme.colorScheme.surfaceContainerHighest,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spacingMd),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _Avatar(imageUrl: person.avatarUrl),
                  const SizedBox(width: AppSizes.spacingMd),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                person.fullName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            FavoriteIconButton(
                              isFavorite: isFavorite,
                              onPressed: onFavoriteToggle,
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSizes.spacingXs),

                        Text(
                          person.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textMediumFor(brightness),
                          ),
                        ),

                        const SizedBox(height: AppSizes.spacingXss),

                        Text(
                          person.location,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textMutedFor(brightness),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Chevron
                  Center(
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textMutedFor(brightness),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Container(
      padding: const EdgeInsets.all(AppSizes.avatarFramePadding),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.tileBorderFor(brightness)),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: AppSizes.avatarSizeMd,
          height: AppSizes.avatarSizeMd,
          fit: BoxFit.cover,
          fadeInDuration: AppConstants.imageFadeInDuration,
          placeholder: (_, __) => ColoredBox(
            color: AppColors.skeletonBaseFor(brightness),
            child: const SizedBox(
              width: AppSizes.avatarSizeMd,
              height: AppSizes.avatarSizeMd,
            ),
          ),
          errorWidget: (_, __, ___) => ColoredBox(
            color: AppColors.skeletonBaseFor(brightness),
            child: const SizedBox(
              width: AppSizes.avatarSizeMd,
              height: AppSizes.avatarSizeMd,
              child: Icon(Icons.person),
            ),
          ),
        ),
      ),
    );
  }
}
