package com.hypheng.telegram.kmp

internal enum class StartupRuntimeHook {
    None,
    ForceFailure,
}

internal data class BootstrapRouteResult(
    val bootstrapCopy: BootstrapCopy?,
    val outcome: BootstrapLoadOutcome,
)

internal sealed interface BootstrapLoadOutcome {
    data class Loaded(val assets: StartupAssets) : BootstrapLoadOutcome

    data class Failure(val notice: String) : BootstrapLoadOutcome
}

internal suspend fun loadBootstrapRouteResult(
    startupRuntimeHook: StartupRuntimeHook,
    loadBootstrapCopy: suspend () -> BootstrapCopy = { StartupAssetRepository.loadBootstrapCopy() },
    loadAll: suspend () -> StartupAssets = { StartupAssetRepository.loadAll() },
): BootstrapRouteResult {
    val bootstrapCopy = runCatching { loadBootstrapCopy() }.getOrNull()
    if (startupRuntimeHook == StartupRuntimeHook.ForceFailure) {
        return BootstrapRouteResult(
            bootstrapCopy = bootstrapCopy,
            outcome = BootstrapLoadOutcome.Failure(
                notice = bootstrapCopy?.failureNotice ?: "Startup failed",
            ),
        )
    }

    return runCatching { loadAll() }
        .fold(
            onSuccess = { assets ->
                BootstrapRouteResult(
                    bootstrapCopy = bootstrapCopy,
                    outcome = BootstrapLoadOutcome.Loaded(assets),
                )
            },
            onFailure = { error ->
                BootstrapRouteResult(
                    bootstrapCopy = bootstrapCopy,
                    outcome = BootstrapLoadOutcome.Failure(
                        notice = error.message ?: "Startup failed",
                    ),
                )
            },
        )
}
