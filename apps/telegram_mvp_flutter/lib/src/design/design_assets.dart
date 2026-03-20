abstract final class DesignAssetPaths {
  static const String mockDataJson = '../../docs/design/assets/mock-data.json';
  static const String iconsRoot = '../../docs/design/assets/icons/';
  static const String telegramBrandBadge =
      '${iconsRoot}telegram-brand-badge.svg';
  static const String telegramBrandMark = '${iconsRoot}telegram-brand-mark.svg';

  static String icon(String name) => '$iconsRoot$name.svg';
}
