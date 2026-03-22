package com.hypheng.telegram.kmp

import kotlin.test.Test
import kotlin.test.assertEquals

class StartupRuntimeHookTest {
    @Test
    fun defaultLaunchDoesNotEnableAnyHook() {
        assertEquals(
            StartupRuntimeHook.None,
            resolveStartupRuntimeHook(intent = null, isDebuggable = true),
        )
    }

    @Test
    fun debugLaunchCanForceStartupFailure() {
        assertEquals(
            StartupRuntimeHook.ForceFailure,
            resolveStartupRuntimeHook(
                hookValue = STARTUP_DEBUG_HOOK_FORCE_FAILURE_VALUE,
                isDebuggable = true,
            ),
        )
    }

    @Test
    fun nonDebuggableBuildIgnoresRuntimeHookExtra() {
        assertEquals(
            StartupRuntimeHook.None,
            resolveStartupRuntimeHook(
                hookValue = STARTUP_DEBUG_HOOK_FORCE_FAILURE_VALUE,
                isDebuggable = false,
            ),
        )
    }
}
