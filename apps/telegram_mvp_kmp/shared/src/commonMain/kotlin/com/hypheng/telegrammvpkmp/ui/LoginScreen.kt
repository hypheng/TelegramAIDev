package com.hypheng.telegrammvpkmp.ui

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp

import com.hypheng.telegrammvpkmp.TelegramUiState
import com.hypheng.telegrammvpkmp.design.DesignAssetPaths
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch

@Composable
fun LoginScreen(
    state: TelegramUiState.Login,
    onPhoneChange: (String) -> Unit,
    onContinue: suspend (String) -> Boolean,
) {
    val scope = rememberCoroutineScopeSafe()
    var localPhone by rememberSaveable(state.phoneNumber) { mutableStateOf(state.phoneNumber) }

    LaunchedEffect(state.phoneNumber) {
        if (state.phoneNumber != localPhone) {
            localPhone = state.phoneNumber
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(24.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center,
    ) {
        DesignSvgIcon(
            assetPath = DesignAssetPaths.telegramBrandBadge,
            modifier = Modifier.size(72.dp),
            size = 72.dp,
        )
        Spacer(modifier = Modifier.height(18.dp))
        Text(
            text = state.catalog.login.brandTitle,
            style = MaterialTheme.typography.headlineLarge,
        )
        Spacer(modifier = Modifier.height(28.dp))
        Card(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(20.dp)) {
                Text(
                    text = "Demo Sign In",
                    style = MaterialTheme.typography.labelLarge,
                )
                Spacer(modifier = Modifier.height(16.dp))
                OutlinedTextField(
                    value = localPhone,
                    onValueChange = {
                        localPhone = it
                        onPhoneChange(it)
                    },
                    modifier = Modifier.fillMaxWidth(),
                    label = { Text("Phone number") },
                    supportingText = { Text(state.catalog.login.hint) },
                    isError = state.errorMessage != null,
                    keyboardOptions = androidx.compose.foundation.text.KeyboardOptions(
                        keyboardType = KeyboardType.Phone,
                        imeAction = ImeAction.Done,
                    ),
                    singleLine = true,
                )
                if (state.errorMessage != null) {
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = state.errorMessage,
                        color = MaterialTheme.colorScheme.error,
                        style = MaterialTheme.typography.bodySmall,
                    )
                }
                Spacer(modifier = Modifier.height(16.dp))
                Button(
                    onClick = {
                        scope.launch {
                            onContinue(localPhone)
                        }
                    },
                    enabled = !state.isSigningIn,
                ) {
                    if (state.isSigningIn) {
                        CircularProgressIndicator(modifier = Modifier.size(18.dp))
                    } else {
                        Text(text = state.catalog.login.submitLabel)
                    }
                }
                Spacer(modifier = Modifier.height(12.dp))
                Text(
                    text = state.catalog.login.validationHint,
                    style = MaterialTheme.typography.bodySmall,
                )
                Spacer(modifier = Modifier.height(10.dp))
                Text(
                    text = if (state.errorMessage == null) {
                        state.catalog.login.footer
                    } else {
                        state.catalog.login.validationFooter
                    },
                    style = MaterialTheme.typography.bodySmall,
                )
            }
        }
    }
}

@Composable
private fun rememberCoroutineScopeSafe(): CoroutineScope {
    return androidx.compose.runtime.rememberCoroutineScope()
}
