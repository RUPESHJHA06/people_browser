import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../domain/domain.dart';

class PersonTile extends StatelessWidget {
  const PersonTile({super.key, required this.person, required this.onTap});

  final Person person;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Material(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        side: BorderSide(color: AppColors.tileBorderFor(brightness)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacingMd),
          child: Row(
            children: [
              _Avatar(imageUrl: person.avatarUrl),
              const SizedBox(width: AppSizes.spacingMd),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      person.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingXs),
                    Text(
                      person.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSizes.spacingXss),
                    Text(
                      person.location,
                      maxLines: 2,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.spacingSm),
              const Icon(Icons.chevron_right),
            ],
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

    if (imageUrl.isEmpty) {
      return const CircleAvatar(
        radius: AppSizes.avatarRadiusMd,
        child: Icon(Icons.person),
      );
    }

    return ClipOval(
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
    );
  }
}
