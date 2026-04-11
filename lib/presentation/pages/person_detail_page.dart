import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:people_browser/core/export.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:people_browser/domain/export.dart';

class PersonDetailPage extends StatelessWidget {
  const PersonDetailPage({super.key, required this.person});

  final Person person;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          person.fullName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.spacingLg),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.spacingLg),
            decoration: BoxDecoration(
              color: AppColors.detailHeaderBackgroundFor(brightness),
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            ),
            child: Column(
              children: [
                Tooltip(
                  message: AppStrings.openPhoto,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: person.avatarUrl.isEmpty
                        ? null
                        : () => _openPhoto(context),
                    child: Hero(
                      tag: person.avatarUrl,
                      child: Container(
                        padding: const EdgeInsets.all(
                          AppSizes.detailAvatarFramePadding,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.avatarFrameBackgroundFor(brightness),
                          border: Border.all(
                            color: AppColors.avatarFrameBorderFor(brightness),
                            width: AppSizes.detailAvatarBorderWidth,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: AppSizes.detailAvatarShadowBlur,
                              offset: Offset(
                                0,
                                AppSizes.detailAvatarShadowOffsetY,
                              ),
                              color: AppColors.shadow,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: AppSizes.avatarSizeLg,
                          backgroundImage: person.avatarUrl.isEmpty
                              ? null
                              : CachedNetworkImageProvider(person.avatarUrl),
                          child: person.avatarUrl.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  size: AppSizes.avatarSizeLg,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.spacingMd),
                Text(
                  person.fullName,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSizes.spacingSm),
                Text(
                  '${person.age} years old - ${person.gender}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spacingLg),
          _DetailRow(
            icon: Icons.email,
            label: AppStrings.email,
            value: person.email,
            onTap: person.email.isEmpty
                ? null
                : () => _launchAction(
                    context,
                    Uri(scheme: 'mailto', path: person.email),
                  ),
          ),
          _DetailRow(
            icon: Icons.phone,
            label: AppStrings.phone,
            value: person.phone,
            onTap: person.phone.isEmpty
                ? null
                : () => _launchAction(
                    context,
                    Uri(scheme: 'tel', path: person.phone),
                  ),
          ),
          _DetailRow(
            icon: Icons.location_on,
            label: AppStrings.location,
            value: person.location,
            onTap: person.location.isEmpty
                ? null
                : () => _launchAction(
                    context,
                    Uri.https('www.google.com', '/maps/search/', {
                      'api': '1',
                      'query': person.location,
                    }),
                  ),
          ),
        ],
      ),
    );
  }

  void _openPhoto(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _FullScreenPhotoPage(
          imageUrl: person.avatarUrl,
          title: person.fullName,
        ),
      ),
    );
  }

  Future<void> _launchAction(BuildContext context, Uri uri) async {
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened && context.mounted) {
        _showUnableToOpenMessage(context);
      }
    } on MissingPluginException {
      if (context.mounted) {
        _showUnableToOpenMessage(context);
      }
    } on PlatformException {
      if (context.mounted) {
        _showUnableToOpenMessage(context);
      }
    }
  }

  void _showUnableToOpenMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppStrings.unableToOpenAction)),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.detailRowVerticalPadding,
      ),
      child: Material(
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: AppSizes.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: theme.textTheme.labelLarge),
                      const SizedBox(height: AppSizes.spacingXss),
                      Text(
                        value.isEmpty ? AppStrings.notAvailable : value,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (onTap != null) ...[
                  const SizedBox(width: AppSizes.spacingSm),
                  const Icon(
                    Icons.open_in_new,
                    size: AppSizes.detailActionIconSize,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FullScreenPhotoPage extends StatelessWidget {
  const _FullScreenPhotoPage({required this.imageUrl, required this.title});

  final String imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.black,
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final imageSize = constraints.biggest.shortestSide * 0.78;

            return Hero(
              tag: imageUrl,
              child: ClipOval(
                child: SizedBox.square(
                  dimension: imageSize,
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 4,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => const ColoredBox(
                        color: AppColors.black,
                        child: Icon(
                          Icons.broken_image,
                          color: AppColors.white,
                          size: AppSizes.photoFallbackIconSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
