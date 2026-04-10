import 'package:flutter/material.dart';

class AppConstants {
  const AppConstants._();

  static const randomUserUrl = 'https://randomuser.me/api/';
  static const peopleResultCount = 30;
  static const peopleSeed = 'people-browser';
  static const peopleNationalities = 'us,gb,ca,au';

  static const requestTimeout = Duration(seconds: 10);
  static const splashDuration = Duration(milliseconds: 1400);
  static const searchDebounceDuration = Duration(milliseconds: 300);
  static const loadingPulseDuration = Duration(milliseconds: 1100);
  static const imageFadeInDuration = Duration.zero;
}

class AppSizes {
  const AppSizes._();

  static const spacingXss = 2.0;
  static const spacingXs = 4.0;
  static const spacingSm = 8.0;
  static const spacingMd = 16.0;
  static const spacingLg = 24.0;
  static const spacingXl = 32.0;

  static const radiusSm = 8.0;
  static const radiusMd = 12.0;
  static const radiusLg = 20.0;

  static const personTileHeight = 132.0;
  static const avatarRadiusMd = 30.0;
  static const avatarSizeMd = 60.0;
  static const avatarSizeLg = 64.0;
  static const detailAvatarFramePadding = 4.0;
  static const detailAvatarBorderWidth = 2.0;
  static const detailAvatarShadowBlur = 18.0;
  static const detailAvatarShadowOffsetY = 8.0;
  static const detailRowVerticalPadding = 6.0;
  static const detailActionIconSize = 18.0;
  static const splashClusterWidth = 156.0;
  static const splashClusterHeight = 104.0;
  static const splashSideAvatarTop = 28.0;
  static const splashSideAvatarSize = 64.0;
  static const splashCenterAvatarSize = 88.0;
  static const splashAvatarBorderWidth = 5.0;
  static const splashAvatarShadowBlur = 22.0;
  static const splashAvatarShadowOffsetY = 10.0;
  static const messageIconSize = 48.0;
  static const emptyStateTopSpacing = 160.0;
  static const skeletonCircleRadius = 30.0;
  static const skeletonLineHeightLg = 16.0;
  static const skeletonLineHeightSm = 12.0;
  static const photoFallbackIconSize = 64.0;
  static const inputFocusBorderWidth = 1.4;
}

class AppColors {
  const AppColors._();

  static const seed = Color(0xFF00796B);
  static const darkSeed = Color(0xFF80CBC4);
  static const scaffoldBackground = Color(0xFFF3F7F7);
  static const darkScaffoldBackground = Color(0xFF0F1716);
  static const inputFill = Color(0xFFF5F7F8);
  static const lightSearchInputFill = Color(0xFFE7ECEB);
  static const darkInputFill = Color(0xFF1A2423);
  static const detailHeaderBackground = Color(0xFFE8F5F2);
  static const darkDetailHeaderBackground = Color(0xFF162A27);
  static const splashBackgroundEnd = Color(0xFFEAF1FF);
  static const darkSplashBackgroundEnd = Color(0xFF111A24);
  static const skeletonBase = Color(0xFFE6ECEB);
  static const darkSkeletonBase = Color(0xFF202B2A);
  static const skeletonHighlight = Color(0xFFF7FAFA);
  static const darkSkeletonHighlight = Color(0xFF2C3937);
  static const tileBorder = Color(0xFFD9E4E2);
  static const darkTileBorder = Color(0xFF2A3836);
  static const textStrong = Color(0xFF163832);
  static const darkTextStrong = Color(0xFFE8F5F2);
  static const textMedium = Color(0xFF31534E);
  static const darkTextMedium = Color(0xFFB9D8D2);
  static const textMuted = Color(0xFF536B67);
  static const darkTextMuted = Color(0xFF9AAEAA);
  static const avatarYellow = Color(0xFFFFD166);
  static const avatarBlue = Color(0xFF90CAF9);
  static const avatarTeal = Color(0xFF80CBC4);
  static const avatarFrameBackground = Color(0xFFFFFFFF);
  static const darkAvatarFrameBackground = Color(0xFF20312E);
  static const avatarFrameBorder = Color(0xFF80CBC4);
  static const darkAvatarFrameBorder = Color(0xFF4DB6AC);
  static const darkSurface = Color(0xFF1A2423);
  static const heartRed = Color(0xFFE53935);
  static const shadow = Color(0x1A000000);
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);

  static Color scaffoldBackgroundFor(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkScaffoldBackground
        : scaffoldBackground;
  }

  static Color inputFillFor(Brightness brightness) {
    return brightness == Brightness.dark ? darkInputFill : inputFill;
  }

  static Color searchInputFillFor(Brightness brightness) {
    return brightness == Brightness.dark ? darkInputFill : lightSearchInputFill;
  }

  static Color detailHeaderBackgroundFor(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkDetailHeaderBackground
        : detailHeaderBackground;
  }

  static Color splashBackgroundEndFor(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkSplashBackgroundEnd
        : splashBackgroundEnd;
  }

  static Color skeletonBaseFor(Brightness brightness) {
    return brightness == Brightness.dark ? darkSkeletonBase : skeletonBase;
  }

  static Color skeletonHighlightFor(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkSkeletonHighlight
        : skeletonHighlight;
  }

  static Color tileBorderFor(Brightness brightness) {
    return brightness == Brightness.dark ? darkTileBorder : tileBorder;
  }

  static Color textStrongFor(Brightness brightness) {
    return brightness == Brightness.dark ? darkTextStrong : textStrong;
  }

  static Color textMediumFor(Brightness brightness) {
    return brightness == Brightness.dark ? darkTextMedium : textMedium;
  }

  static Color textMutedFor(Brightness brightness) {
    return brightness == Brightness.dark ? darkTextMuted : textMuted;
  }

  static Color avatarFrameBackgroundFor(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkAvatarFrameBackground
        : avatarFrameBackground;
  }

  static Color avatarFrameBorderFor(Brightness brightness) {
    return brightness == Brightness.dark
        ? darkAvatarFrameBorder
        : avatarFrameBorder;
  }
}
