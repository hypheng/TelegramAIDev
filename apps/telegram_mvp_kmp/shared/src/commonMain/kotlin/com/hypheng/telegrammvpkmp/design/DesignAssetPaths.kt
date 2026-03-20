package com.hypheng.telegrammvpkmp.design

object DesignAssetPaths {
    const val mockDataJson = "design/mock-data.json"
    const val iconsRoot = "design/icons/"
    const val catalogJson = mockDataJson

    const val telegramBrandBadge = "${iconsRoot}telegram-brand-badge.svg"
    const val telegramBrandMark = "${iconsRoot}telegram-brand-mark.svg"

    fun icon(name: String): String = "${iconsRoot}${name}.svg"
}
