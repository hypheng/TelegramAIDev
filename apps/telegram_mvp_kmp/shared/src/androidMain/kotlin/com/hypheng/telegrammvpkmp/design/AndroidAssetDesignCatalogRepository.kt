package com.hypheng.telegrammvpkmp.design

import android.content.Context
import com.hypheng.telegrammvpkmp.session.DesignCatalogRepository

class AndroidAssetDesignCatalogRepository(
    private val context: Context,
) : DesignCatalogRepository {
    override suspend fun load(): DesignCatalog {
        return runCatching {
            context.assets.open(DesignAssetPaths.catalogJson).bufferedReader().use { reader ->
                DesignCatalog.fromJsonString(reader.readText())
            }
        }.getOrElse {
            DesignCatalog.sample()
        }
    }
}
