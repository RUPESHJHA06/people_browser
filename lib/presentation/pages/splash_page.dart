import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:people_browser/core/export.dart';
import 'package:people_browser/presentation/export.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    FocusManager.instance.primaryFocus?.unfocus();
    SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
    Future<void>.delayed(AppConstants.splashDuration, _openPeoplePage);
  }

  void _openPeoplePage() {
    if (!mounted) {
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const PeoplePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.detailHeaderBackgroundFor(brightness),
              AppColors.scaffoldBackgroundFor(brightness),
              AppColors.splashBackgroundEndFor(brightness),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.spacingXl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _AvatarCluster(),
                  const SizedBox(height: AppSizes.spacingXl),
                  Text(
                    AppStrings.appTitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textStrongFor(brightness),
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingSm),
                  Text(
                    AppStrings.splashTagline,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.textMediumFor(brightness),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingXs),
                  Text(
                    AppStrings.splashSubtitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
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

class _AvatarCluster extends StatelessWidget {
  const _AvatarCluster();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.splashClusterWidth,
      height: AppSizes.splashClusterHeight,
      child: Stack(
        alignment: Alignment.center,
        children: const [
          Positioned(
            left: 0,
            top: AppSizes.splashSideAvatarTop,
            child: _SplashAvatar(
              color: AppColors.avatarYellow,
              icon: Icons.person,
              size: AppSizes.splashSideAvatarSize,
            ),
          ),
          Positioned(
            right: 0,
            top: AppSizes.splashSideAvatarTop,
            child: _SplashAvatar(
              color: AppColors.avatarBlue,
              icon: Icons.person_outline,
              size: AppSizes.splashSideAvatarSize,
            ),
          ),
          Positioned(
            top: 0,
            child: _SplashAvatar(
              color: AppColors.avatarTeal,
              icon: Icons.person_search,
              size: AppSizes.splashCenterAvatarSize,
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashAvatar extends StatelessWidget {
  const _SplashAvatar({
    required this.color,
    required this.icon,
    required this.size,
  });

  final Color color;
  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.scaffoldBackgroundFor(brightness),
          width: AppSizes.splashAvatarBorderWidth,
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: AppSizes.splashAvatarShadowBlur,
            offset: Offset(0, AppSizes.splashAvatarShadowOffsetY),
            color: AppColors.shadow,
          ),
        ],
      ),
      child: Icon(
        icon,
        size: size * 0.44,
        color: AppColors.textStrongFor(Brightness.light),
      ),
    );
  }
}
