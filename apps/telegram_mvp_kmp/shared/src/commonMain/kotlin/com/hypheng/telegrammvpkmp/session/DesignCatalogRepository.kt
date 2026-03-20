package com.hypheng.telegrammvpkmp.session

import com.hypheng.telegrammvpkmp.design.DesignCatalog

interface DesignCatalogRepository {
    suspend fun load(): DesignCatalog
}
