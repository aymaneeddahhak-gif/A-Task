package com.example.ui.screens

import android.widget.Toast
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.automirrored.filled.KeyboardArrowRight
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Computer
import androidx.compose.material.icons.filled.DeleteOutline
import androidx.compose.material.icons.filled.Image
import androidx.compose.material.icons.filled.PhoneAndroid
import androidx.compose.material.icons.filled.QrCode
import androidx.compose.material.icons.filled.Smartphone
import androidx.compose.material.icons.filled.Tablet
import androidx.compose.material.icons.filled.Visibility
import androidx.compose.material.icons.filled.VisibilityOff
import androidx.compose.material.icons.outlined.CurrencyExchange
import androidx.compose.material.icons.outlined.Devices
import androidx.compose.material.icons.outlined.Edit
import androidx.compose.material.icons.outlined.Fingerprint
import androidx.compose.material.icons.outlined.Language
import androidx.compose.material.icons.outlined.Lock
import androidx.compose.material.icons.outlined.Palette
import androidx.compose.material.icons.outlined.PhoneIphone
import androidx.compose.material.icons.outlined.Pin
import androidx.compose.material.icons.outlined.QrCodeScanner
import androidx.compose.material.icons.outlined.Security
import androidx.compose.material.icons.outlined.Translate
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Surface
import androidx.compose.material3.Switch
import androidx.compose.material3.SwitchDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.input.VisualTransformation
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.example.R
import com.example.ui.theme.TextPrimary
import com.example.ui.theme.TextSecondary
import com.example.ui.viewmodel.ConnectedDevice
import com.example.ui.viewmodel.TaskViewModel

@Composable
fun ProfileScreen(
    viewModel: TaskViewModel,
    onBackClick: () -> Unit = {},
    onOpenDesignSandbox: () -> Unit = {},
    modifier: Modifier = Modifier
) {
    val context = LocalContext.current

    // Observe persistent profile state from TaskViewModel
    val userName by viewModel.userName.collectAsStateWithLifecycle()
    val userEmail by viewModel.userEmail.collectAsStateWithLifecycle()
    val userRole by viewModel.userRole.collectAsStateWithLifecycle()
    val userLocation by viewModel.userLocation.collectAsStateWithLifecycle()
    val userBio by viewModel.userBio.collectAsStateWithLifecycle()
    val selectedLanguage by viewModel.selectedLanguage.collectAsStateWithLifecycle()
    val selectedCurrency by viewModel.selectedCurrency.collectAsStateWithLifecycle()
    val selectedTheme by viewModel.selectedTheme.collectAsStateWithLifecycle()
    val accentColorName by viewModel.accentColorName.collectAsStateWithLifecycle()
    val biometricEnabled by viewModel.biometricEnabled.collectAsStateWithLifecycle()
    val autoLockEnabled by viewModel.autoLockEnabled.collectAsStateWithLifecycle()
    val twoFactorEnabled by viewModel.twoFactorEnabled.collectAsStateWithLifecycle()
    val connectedDevices by viewModel.connectedDevices.collectAsStateWithLifecycle()

    // Dialog sheets state
    var isEditProfileOpen by remember { mutableStateOf(false) }
    var isLanguageDialogOpen by remember { mutableStateOf(false) }
    var isCurrenciesDialogOpen by remember { mutableStateOf(false) }
    var isAppearanceDialogOpen by remember { mutableStateOf(false) }
    var isSecurityDialogOpen by remember { mutableStateOf(false) }
    var isDevicesDialogOpen by remember { mutableStateOf(false) }
    var isPasswordDialogOpen by remember { mutableStateOf(false) }

    // Ambient warm champagne/peach background matching the reference
    Box(
        modifier = modifier
            .fillMaxSize()
            .background(
                Brush.verticalGradient(
                    colors = listOf(
                        Color(0xFFFFF1E6),
                        Color(0xFFFDF7F2),
                        Color(0xFFFAF8F6),
                        Color(0xFFFFFFFF)
                    )
                )
            )
            .statusBarsPadding()
    ) {
        LazyColumn(
            modifier = Modifier.fillMaxSize(),
            contentPadding = PaddingValues(horizontal = 24.dp, vertical = 12.dp)
        ) {
            // 1. Top Bar Navigation & Header
            item {
                Column(modifier = Modifier.fillMaxWidth()) {
                    IconButton(
                        onClick = onBackClick,
                        modifier = Modifier
                            .size(40.dp)
                            .testTag("profile_back_btn")
                    ) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                            contentDescription = "Back",
                            tint = Color(0xFF111827),
                            modifier = Modifier.size(22.dp)
                        )
                    }

                    Spacer(modifier = Modifier.height(12.dp))

                    Text(
                        text = "Profile",
                        color = Color(0xFF111827),
                        fontSize = 28.sp,
                        fontWeight = FontWeight.Bold,
                        letterSpacing = (-0.5).sp
                    )

                    Spacer(modifier = Modifier.height(18.dp))
                }
            }

            // 2. Main Profile Card (Avatar, Name, Email, Role, Location, Orange Edit Profile Button)
            item {
                Surface(
                    modifier = Modifier
                        .fillMaxWidth()
                        .shadow(16.dp, RoundedCornerShape(28.dp), spotColor = Color(0x18000000))
                        .testTag("user_profile_card"),
                    shape = RoundedCornerShape(28.dp),
                    color = Color.White
                ) {
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(vertical = 24.dp, horizontal = 20.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        // User Avatar
                        Box(
                            modifier = Modifier
                                .size(82.dp)
                                .shadow(8.dp, CircleShape, spotColor = Color(0x20000000))
                                .clip(CircleShape)
                                .background(Color(0xFFF3F4F6))
                        ) {
                            Image(
                                painter = painterResource(id = R.drawable.avatar_hadi),
                                contentDescription = "Profile Photo",
                                modifier = Modifier.fillMaxSize(),
                                contentScale = ContentScale.Crop
                            )
                        }

                        Spacer(modifier = Modifier.height(14.dp))

                        // User Name
                        Text(
                            text = userName,
                            color = Color(0xFF111827),
                            fontSize = 20.sp,
                            fontWeight = FontWeight.Bold
                        )

                        Spacer(modifier = Modifier.height(4.dp))

                        // Email
                        Text(
                            text = userEmail,
                            color = Color(0xFF9CA3AF),
                            fontSize = 13.sp,
                            fontWeight = FontWeight.Normal
                        )

                        Spacer(modifier = Modifier.height(4.dp))

                        // Role and Location Subtitle
                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalArrangement = Arrangement.Center
                        ) {
                            Text(
                                text = userRole,
                                color = Color(0xFF9CA3AF),
                                fontSize = 12.sp
                            )
                            Text(
                                text = "  •  📍 ",
                                color = Color(0xFF9CA3AF),
                                fontSize = 12.sp
                            )
                            Text(
                                text = userLocation,
                                color = Color(0xFF9CA3AF),
                                fontSize = 12.sp
                            )
                        }

                        Spacer(modifier = Modifier.height(18.dp))

                        // Orange "Edit Profile" Pill Button
                        Surface(
                            modifier = Modifier
                                .height(44.dp)
                                .shadow(8.dp, CircleShape, spotColor = Color(0x35FA5A00))
                                .clip(CircleShape)
                                .clickable { isEditProfileOpen = true }
                                .testTag("edit_profile_pill_button"),
                            shape = CircleShape,
                            color = Color(0xFFFA5A00) // Vibrant Signature Orange
                        ) {
                            Row(
                                modifier = Modifier.padding(horizontal = 24.dp),
                                verticalAlignment = Alignment.CenterVertically,
                                horizontalArrangement = Arrangement.Center
                            ) {
                                Icon(
                                    imageVector = Icons.Outlined.Edit,
                                    contentDescription = null,
                                    tint = Color.White,
                                    modifier = Modifier.size(16.dp)
                                )
                                Spacer(modifier = Modifier.width(8.dp))
                                Text(
                                    text = "Edit Profile",
                                    color = Color.White,
                                    fontSize = 14.sp,
                                    fontWeight = FontWeight.SemiBold
                                )
                            }
                        }
                    }
                }

                Spacer(modifier = Modifier.height(18.dp))
            }

            // 3. Settings Card 1: Language, Currencies, Appearance
            item {
                Surface(
                    modifier = Modifier
                        .fillMaxWidth()
                        .shadow(12.dp, RoundedCornerShape(22.dp), spotColor = Color(0x12000000)),
                    shape = RoundedCornerShape(22.dp),
                    color = Color.White
                ) {
                    Column(modifier = Modifier.fillMaxWidth()) {
                        ProfileMenuRow(
                            icon = Icons.Outlined.Translate,
                            title = "Language",
                            trailingText = selectedLanguage.substringBefore(" "),
                            onClick = { isLanguageDialogOpen = true },
                            testTag = "menu_language"
                        )
                        HorizontalDivider(
                            modifier = Modifier.padding(horizontal = 18.dp),
                            thickness = 0.5.dp,
                            color = Color(0xFFF1F5F9)
                        )
                        ProfileMenuRow(
                            icon = Icons.Outlined.QrCodeScanner,
                            title = "Currencies",
                            trailingText = selectedCurrency,
                            onClick = { isCurrenciesDialogOpen = true },
                            testTag = "menu_currencies"
                        )
                        HorizontalDivider(
                            modifier = Modifier.padding(horizontal = 18.dp),
                            thickness = 0.5.dp,
                            color = Color(0xFFF1F5F9)
                        )
                        ProfileMenuRow(
                            icon = Icons.Outlined.Palette,
                            title = "Appearance",
                            trailingText = selectedTheme,
                            onClick = { isAppearanceDialogOpen = true },
                            testTag = "menu_appearance"
                        )
                    }
                }

                Spacer(modifier = Modifier.height(18.dp))
            }

            // 4. Settings Card 2: Application Security, Manage Devices, Change Password
            item {
                Surface(
                    modifier = Modifier
                        .fillMaxWidth()
                        .shadow(12.dp, RoundedCornerShape(22.dp), spotColor = Color(0x12000000)),
                    shape = RoundedCornerShape(22.dp),
                    color = Color.White
                ) {
                    Column(modifier = Modifier.fillMaxWidth()) {
                        ProfileMenuRow(
                            icon = Icons.Outlined.Security,
                            title = "Application Security",
                            trailingText = if (biometricEnabled) "Biometric On" else "Basic",
                            onClick = { isSecurityDialogOpen = true },
                            testTag = "menu_security"
                        )
                        HorizontalDivider(
                            modifier = Modifier.padding(horizontal = 18.dp),
                            thickness = 0.5.dp,
                            color = Color(0xFFF1F5F9)
                        )
                        ProfileMenuRow(
                            icon = Icons.Outlined.PhoneIphone,
                            title = "Manage Devices",
                            trailingText = "${connectedDevices.size} active",
                            onClick = { isDevicesDialogOpen = true },
                            testTag = "menu_devices"
                        )
                        HorizontalDivider(
                            modifier = Modifier.padding(horizontal = 18.dp),
                            thickness = 0.5.dp,
                            color = Color(0xFFF1F5F9)
                        )
                        ProfileMenuRow(
                            icon = Icons.Outlined.Pin,
                            title = "Change Password",
                            onClick = { isPasswordDialogOpen = true },
                            testTag = "menu_password"
                        )
                        HorizontalDivider(
                            modifier = Modifier.padding(horizontal = 18.dp),
                            thickness = 0.5.dp,
                            color = Color(0xFFF1F5F9)
                        )
                        ProfileMenuRow(
                            icon = Icons.Outlined.Palette,
                            title = "Design Sandbox Studio",
                            trailingText = "Drafting",
                            onClick = onOpenDesignSandbox,
                            testTag = "menu_design_sandbox"
                        )
                    }
                }

                Spacer(modifier = Modifier.height(120.dp))
            }
        }
    }

    // ==========================================
    // Fully Functional Dialogs & Settings Sheet
    // ==========================================

    // 1. Edit Profile Dialog
    if (isEditProfileOpen) {
        var tempName by remember { mutableStateOf(userName) }
        var tempEmail by remember { mutableStateOf(userEmail) }
        var tempRole by remember { mutableStateOf(userRole) }
        var tempLocation by remember { mutableStateOf(userLocation) }
        var tempBio by remember { mutableStateOf(userBio) }

        Dialog(
            onDismissRequest = { isEditProfileOpen = false },
            properties = DialogProperties(usePlatformDefaultWidth = false)
        ) {
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .background(Color.Black.copy(alpha = 0.5f))
                    .clickable { isEditProfileOpen = false },
                contentAlignment = Alignment.Center
            ) {
                Surface(
                    modifier = Modifier
                        .fillMaxWidth(0.92f)
                        .clickable(enabled = false) {},
                    shape = RoundedCornerShape(28.dp),
                    color = Color.White
                ) {
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(24.dp)
                    ) {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Text(
                                text = "Edit Profile",
                                fontSize = 20.sp,
                                fontWeight = FontWeight.Bold,
                                color = Color(0xFF111827)
                            )
                            IconButton(onClick = { isEditProfileOpen = false }) {
                                Icon(
                                    imageVector = Icons.Default.Close,
                                    contentDescription = "Close",
                                    tint = Color(0xFF9CA3AF)
                                )
                            }
                        }

                        Spacer(modifier = Modifier.height(16.dp))

                        OutlinedTextField(
                            value = tempName,
                            onValueChange = { tempName = it },
                            label = { Text("Full Name") },
                            modifier = Modifier.fillMaxWidth(),
                            shape = RoundedCornerShape(14.dp),
                            colors = OutlinedTextFieldDefaults.colors(
                                focusedBorderColor = Color(0xFFFA5A00),
                                focusedLabelColor = Color(0xFFFA5A00)
                            )
                        )

                        Spacer(modifier = Modifier.height(12.dp))

                        OutlinedTextField(
                            value = tempEmail,
                            onValueChange = { tempEmail = it },
                            label = { Text("Email Address") },
                            modifier = Modifier.fillMaxWidth(),
                            shape = RoundedCornerShape(14.dp),
                            colors = OutlinedTextFieldDefaults.colors(
                                focusedBorderColor = Color(0xFFFA5A00),
                                focusedLabelColor = Color(0xFFFA5A00)
                            )
                        )

                        Spacer(modifier = Modifier.height(12.dp))

                        OutlinedTextField(
                            value = tempRole,
                            onValueChange = { tempRole = it },
                            label = { Text("Job Title / Role") },
                            modifier = Modifier.fillMaxWidth(),
                            shape = RoundedCornerShape(14.dp),
                            colors = OutlinedTextFieldDefaults.colors(
                                focusedBorderColor = Color(0xFFFA5A00),
                                focusedLabelColor = Color(0xFFFA5A00)
                            )
                        )

                        Spacer(modifier = Modifier.height(12.dp))

                        OutlinedTextField(
                            value = tempLocation,
                            onValueChange = { tempLocation = it },
                            label = { Text("Location") },
                            modifier = Modifier.fillMaxWidth(),
                            shape = RoundedCornerShape(14.dp),
                            colors = OutlinedTextFieldDefaults.colors(
                                focusedBorderColor = Color(0xFFFA5A00),
                                focusedLabelColor = Color(0xFFFA5A00)
                            )
                        )

                        Spacer(modifier = Modifier.height(24.dp))

                        Surface(
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(50.dp)
                                .shadow(6.dp, CircleShape, spotColor = Color(0x35FA5A00))
                                .clip(CircleShape)
                                .clickable {
                                    viewModel.updateProfile(tempName, tempEmail, tempRole, tempLocation, tempBio)
                                    isEditProfileOpen = false
                                    Toast.makeText(context, "Profile updated successfully!", Toast.LENGTH_SHORT).show()
                                },
                            shape = CircleShape,
                            color = Color(0xFFFA5A00)
                        ) {
                            Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                                Text(
                                    text = "Save Changes",
                                    color = Color.White,
                                    fontSize = 15.sp,
                                    fontWeight = FontWeight.Bold
                                )
                            }
                        }
                    }
                }
            }
        }
    }

    // 2. Language Selector Dialog
    if (isLanguageDialogOpen) {
        val languages = listOf(
            "English (US)", "Spanish (Español)", "French (Français)",
            "German (Deutsch)", "Japanese (日本語)", "Arabic (العربية)",
            "Portuguese (Português)", "Italian (Italiano)"
        )
        SelectionOptionDialog(
            title = "Select Language",
            options = languages,
            selectedOption = selectedLanguage,
            onSelect = {
                viewModel.setLanguage(it)
                isLanguageDialogOpen = false
                Toast.makeText(context, "Language switched to $it", Toast.LENGTH_SHORT).show()
            },
            onDismiss = { isLanguageDialogOpen = false }
        )
    }

    // 3. Currencies Selector Dialog
    if (isCurrenciesDialogOpen) {
        val currencies = listOf("USD ($)", "EUR (€)", "GBP (£)", "JPY (¥)", "CAD ($)", "AUD ($)", "AED (د.إ)", "CHF (₣)")
        SelectionOptionDialog(
            title = "Select Currency",
            options = currencies,
            selectedOption = selectedCurrency,
            onSelect = {
                viewModel.setCurrency(it)
                isCurrenciesDialogOpen = false
                Toast.makeText(context, "Primary currency updated to $it", Toast.LENGTH_SHORT).show()
            },
            onDismiss = { isCurrenciesDialogOpen = false }
        )
    }

    // 4. Appearance Selector Dialog (Theme & Accent Color)
    if (isAppearanceDialogOpen) {
        var currentThemeChoice by remember { mutableStateOf(selectedTheme) }
        var currentAccentChoice by remember { mutableStateOf(accentColorName) }

        val themeModes = listOf("Light Theme", "Dark Theme", "System Default")
        val accentPalettes = listOf(
            Triple("Signature Orange", Color(0xFFFA5A00), "Warm Vibrant"),
            Triple("Electric Ocean Blue", Color(0xFF0284C7), "Cool High-contrast"),
            Triple("Emerald Mint", Color(0xFF059669), "Fresh Productivity"),
            Triple("Royal Purple", Color(0xFF7C3AED), "Refined Elegant"),
            Triple("Rose Pink", Color(0xFFE11D48), "Energetic Focus")
        )

        Dialog(
            onDismissRequest = { isAppearanceDialogOpen = false },
            properties = DialogProperties(usePlatformDefaultWidth = false)
        ) {
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .background(Color.Black.copy(alpha = 0.5f))
                    .clickable { isAppearanceDialogOpen = false },
                contentAlignment = Alignment.Center
            ) {
                Surface(
                    modifier = Modifier
                        .fillMaxWidth(0.92f)
                        .clickable(enabled = false) {},
                    shape = RoundedCornerShape(28.dp),
                    color = Color.White
                ) {
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(24.dp)
                    ) {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Text(
                                text = "Appearance & Theme",
                                fontSize = 20.sp,
                                fontWeight = FontWeight.Bold,
                                color = Color(0xFF111827)
                            )
                            IconButton(onClick = { isAppearanceDialogOpen = false }) {
                                Icon(imageVector = Icons.Default.Close, contentDescription = "Close", tint = Color(0xFF9CA3AF))
                            }
                        }

                        Spacer(modifier = Modifier.height(12.dp))

                        Text(
                            text = "DISPLAY MODE",
                            fontSize = 11.sp,
                            fontWeight = FontWeight.Bold,
                            color = Color(0xFF9CA3AF),
                            letterSpacing = 1.sp
                        )

                        Spacer(modifier = Modifier.height(8.dp))

                        themeModes.forEach { mode ->
                            val isSelected = mode == currentThemeChoice
                            Surface(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .clip(RoundedCornerShape(14.dp))
                                    .clickable { currentThemeChoice = mode }
                                    .padding(vertical = 3.dp),
                                shape = RoundedCornerShape(14.dp),
                                color = if (isSelected) Color(0xFFFFF1E6) else Color(0xFFF8FAFC),
                                border = if (isSelected) androidx.compose.foundation.BorderStroke(1.2.dp, Color(0xFFFA5A00)) else null
                            ) {
                                Row(
                                    modifier = Modifier
                                        .fillMaxWidth()
                                        .padding(horizontal = 16.dp, vertical = 12.dp),
                                    horizontalArrangement = Arrangement.SpaceBetween,
                                    verticalAlignment = Alignment.CenterVertically
                                ) {
                                    Text(
                                        text = mode,
                                        fontSize = 14.sp,
                                        fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Medium,
                                        color = if (isSelected) Color(0xFFFA5A00) else Color(0xFF1F2937)
                                    )
                                    if (isSelected) {
                                        Icon(
                                            imageVector = Icons.Default.Check,
                                            contentDescription = "Selected",
                                            tint = Color(0xFFFA5A00),
                                            modifier = Modifier.size(18.dp)
                                        )
                                    }
                                }
                            }
                        }

                        Spacer(modifier = Modifier.height(16.dp))

                        Text(
                            text = "APP ACCENT PALETTE",
                            fontSize = 11.sp,
                            fontWeight = FontWeight.Bold,
                            color = Color(0xFF9CA3AF),
                            letterSpacing = 1.sp
                        )

                        Spacer(modifier = Modifier.height(8.dp))

                        Column(verticalArrangement = Arrangement.spacedBy(6.dp)) {
                            accentPalettes.forEach { (accentName, colorSwatch, desc) ->
                                val isSelected = accentName == currentAccentChoice
                                Surface(
                                    modifier = Modifier
                                        .fillMaxWidth()
                                        .clip(RoundedCornerShape(14.dp))
                                        .clickable { currentAccentChoice = accentName },
                                    shape = RoundedCornerShape(14.dp),
                                    color = if (isSelected) Color(0xFFF1F5F9) else Color.Transparent,
                                    border = if (isSelected) androidx.compose.foundation.BorderStroke(1.dp, colorSwatch) else null
                                ) {
                                    Row(
                                        modifier = Modifier
                                            .fillMaxWidth()
                                            .padding(horizontal = 12.dp, vertical = 8.dp),
                                        verticalAlignment = Alignment.CenterVertically,
                                        horizontalArrangement = Arrangement.SpaceBetween
                                    ) {
                                        Row(verticalAlignment = Alignment.CenterVertically) {
                                            Box(
                                                modifier = Modifier
                                                    .size(20.dp)
                                                    .clip(CircleShape)
                                                    .background(colorSwatch)
                                            )
                                            Spacer(modifier = Modifier.width(10.dp))
                                            Column {
                                                Text(
                                                    text = accentName,
                                                    fontSize = 13.sp,
                                                    fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Medium,
                                                    color = Color(0xFF111827)
                                                )
                                                Text(
                                                    text = desc,
                                                    fontSize = 11.sp,
                                                    color = Color(0xFF9CA3AF)
                                                )
                                            }
                                        }
                                        if (isSelected) {
                                            Icon(
                                                imageVector = Icons.Default.Check,
                                                contentDescription = null,
                                                tint = colorSwatch,
                                                modifier = Modifier.size(18.dp)
                                            )
                                        }
                                    }
                                }
                            }
                        }

                        Spacer(modifier = Modifier.height(20.dp))

                        Surface(
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(48.dp)
                                .shadow(6.dp, CircleShape, spotColor = Color(0x35FA5A00))
                                .clip(CircleShape)
                                .clickable {
                                    viewModel.setTheme(currentThemeChoice)
                                    viewModel.setAccentColor(currentAccentChoice)
                                    isAppearanceDialogOpen = false
                                    Toast.makeText(context, "Appearance saved: $currentThemeChoice ($currentAccentChoice)", Toast.LENGTH_SHORT).show()
                                },
                            shape = CircleShape,
                            color = Color(0xFFFA5A00)
                        ) {
                            Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                                Text(
                                    text = "Apply Appearance",
                                    color = Color.White,
                                    fontSize = 15.sp,
                                    fontWeight = FontWeight.Bold
                                )
                            }
                        }
                    }
                }
            }
        }
    }

    // 5. Application Security Dialog
    if (isSecurityDialogOpen) {
        Dialog(
            onDismissRequest = { isSecurityDialogOpen = false },
            properties = DialogProperties(usePlatformDefaultWidth = false)
        ) {
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .background(Color.Black.copy(alpha = 0.5f))
                    .clickable { isSecurityDialogOpen = false },
                contentAlignment = Alignment.Center
            ) {
                Surface(
                    modifier = Modifier
                        .fillMaxWidth(0.92f)
                        .clickable(enabled = false) {},
                    shape = RoundedCornerShape(28.dp),
                    color = Color.White
                ) {
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(24.dp)
                    ) {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Text(
                                text = "Application Security",
                                fontSize = 20.sp,
                                fontWeight = FontWeight.Bold,
                                color = Color(0xFF111827)
                            )
                            IconButton(onClick = { isSecurityDialogOpen = false }) {
                                Icon(imageVector = Icons.Default.Close, contentDescription = "Close", tint = Color(0xFF9CA3AF))
                            }
                        }

                        Spacer(modifier = Modifier.height(18.dp))

                        SecurityToggleRow(
                            title = "Biometric Unlock (FaceID / Touch)",
                            subtitle = "Use fingerprint or FaceID to open",
                            checked = biometricEnabled,
                            onCheckedChange = { viewModel.setBiometric(it) }
                        )

                        Spacer(modifier = Modifier.height(14.dp))

                        SecurityToggleRow(
                            title = "Auto-Lock App",
                            subtitle = "Lock after 2 minutes of inactivity",
                            checked = autoLockEnabled,
                            onCheckedChange = { viewModel.setAutoLock(it) }
                        )

                        Spacer(modifier = Modifier.height(14.dp))

                        SecurityToggleRow(
                            title = "Two-Factor Authentication (2FA)",
                            subtitle = "Require SMS or authenticator code",
                            checked = twoFactorEnabled,
                            onCheckedChange = { viewModel.setTwoFactor(it) }
                        )

                        Spacer(modifier = Modifier.height(24.dp))

                        Surface(
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(48.dp)
                                .clip(CircleShape)
                                .clickable {
                                    isSecurityDialogOpen = false
                                    Toast.makeText(context, "Security preferences saved", Toast.LENGTH_SHORT).show()
                                },
                            shape = CircleShape,
                            color = Color(0xFF111827)
                        ) {
                            Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                                Text(
                                    text = "Done",
                                    color = Color.White,
                                    fontSize = 15.sp,
                                    fontWeight = FontWeight.Bold
                                )
                            }
                        }
                    }
                }
            }
        }
    }

    // 6. Manage Devices Dialog (Interactive list with device removal & log out all)
    if (isDevicesDialogOpen) {
        Dialog(
            onDismissRequest = { isDevicesDialogOpen = false },
            properties = DialogProperties(usePlatformDefaultWidth = false)
        ) {
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .background(Color.Black.copy(alpha = 0.5f))
                    .clickable { isDevicesDialogOpen = false },
                contentAlignment = Alignment.Center
            ) {
                Surface(
                    modifier = Modifier
                        .fillMaxWidth(0.92f)
                        .clickable(enabled = false) {},
                    shape = RoundedCornerShape(28.dp),
                    color = Color.White
                ) {
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(24.dp)
                    ) {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Column {
                                Text(
                                    text = "Manage Devices",
                                    fontSize = 20.sp,
                                    fontWeight = FontWeight.Bold,
                                    color = Color(0xFF111827)
                                )
                                Text(
                                    text = "${connectedDevices.size} logged-in sessions",
                                    fontSize = 12.sp,
                                    color = Color(0xFF9CA3AF)
                                )
                            }
                            IconButton(onClick = { isDevicesDialogOpen = false }) {
                                Icon(imageVector = Icons.Default.Close, contentDescription = "Close", tint = Color(0xFF9CA3AF))
                            }
                        }

                        Spacer(modifier = Modifier.height(16.dp))

                        Column(
                            modifier = Modifier.fillMaxWidth(),
                            verticalArrangement = Arrangement.spacedBy(10.dp)
                        ) {
                            connectedDevices.forEach { device ->
                                DeviceSessionCard(
                                    device = device,
                                    onRevoke = {
                                        viewModel.removeDevice(device.id)
                                        Toast.makeText(context, "Signed out from ${device.deviceName}", Toast.LENGTH_SHORT).show()
                                    }
                                )
                            }
                        }

                        Spacer(modifier = Modifier.height(20.dp))

                        // Log Out All Other Devices Button
                        if (connectedDevices.any { !it.isCurrentDevice }) {
                            Surface(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .height(48.dp)
                                    .clip(CircleShape)
                                    .clickable {
                                        viewModel.logOutAllOtherDevices()
                                        Toast.makeText(context, "Successfully logged out all other devices!", Toast.LENGTH_SHORT).show()
                                    },
                                shape = CircleShape,
                                color = Color(0xFFFEE2E2)
                            ) {
                                Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                                    Text(
                                        text = "Log Out All Other Devices",
                                        color = Color(0xFFDC2626),
                                        fontSize = 14.sp,
                                        fontWeight = FontWeight.Bold
                                    )
                                }
                            }
                            Spacer(modifier = Modifier.height(10.dp))
                        }

                        // Close Dialog Button
                        Surface(
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(46.dp)
                                .clip(CircleShape)
                                .clickable { isDevicesDialogOpen = false },
                            shape = CircleShape,
                            color = Color(0xFFF1F5F9)
                        ) {
                            Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                                Text(
                                    text = "Done",
                                    color = Color(0xFF475569),
                                    fontSize = 14.sp,
                                    fontWeight = FontWeight.SemiBold
                                )
                            }
                        }
                    }
                }
            }
        }
    }

    // 7. Change Password Dialog (Complete with visibility toggle, validation & strength indicator)
    if (isPasswordDialogOpen) {
        var currentPassword by remember { mutableStateOf("") }
        var newPassword by remember { mutableStateOf("") }
        var confirmPassword by remember { mutableStateOf("") }
        var showCurrentPassword by remember { mutableStateOf(false) }
        var showNewPassword by remember { mutableStateOf(false) }
        var showConfirmPassword by remember { mutableStateOf(false) }
        var errorMessage by remember { mutableStateOf<String?>(null) }

        // Dynamic password strength calculation
        val passwordStrength = when {
            newPassword.isEmpty() -> 0
            newPassword.length < 6 -> 1
            newPassword.length < 10 || !newPassword.any { it.isDigit() } -> 2
            else -> 3
        }

        Dialog(
            onDismissRequest = { isPasswordDialogOpen = false },
            properties = DialogProperties(usePlatformDefaultWidth = false)
        ) {
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .background(Color.Black.copy(alpha = 0.5f))
                    .clickable { isPasswordDialogOpen = false },
                contentAlignment = Alignment.Center
            ) {
                Surface(
                    modifier = Modifier
                        .fillMaxWidth(0.92f)
                        .clickable(enabled = false) {},
                    shape = RoundedCornerShape(28.dp),
                    color = Color.White
                ) {
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(24.dp)
                    ) {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Text(
                                text = "Change Password",
                                fontSize = 20.sp,
                                fontWeight = FontWeight.Bold,
                                color = Color(0xFF111827)
                            )
                            IconButton(onClick = { isPasswordDialogOpen = false }) {
                                Icon(imageVector = Icons.Default.Close, contentDescription = "Close", tint = Color(0xFF9CA3AF))
                            }
                        }

                        Spacer(modifier = Modifier.height(16.dp))

                        // Current Password
                        OutlinedTextField(
                            value = currentPassword,
                            onValueChange = {
                                currentPassword = it
                                errorMessage = null
                            },
                            label = { Text("Current Password") },
                            modifier = Modifier.fillMaxWidth(),
                            shape = RoundedCornerShape(14.dp),
                            visualTransformation = if (showCurrentPassword) VisualTransformation.None else PasswordVisualTransformation(),
                            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
                            trailingIcon = {
                                IconButton(onClick = { showCurrentPassword = !showCurrentPassword }) {
                                    Icon(
                                        imageVector = if (showCurrentPassword) Icons.Default.VisibilityOff else Icons.Default.Visibility,
                                        contentDescription = "Toggle visibility",
                                        tint = Color(0xFF9CA3AF)
                                    )
                                }
                            },
                            colors = OutlinedTextFieldDefaults.colors(
                                focusedBorderColor = Color(0xFFFA5A00),
                                focusedLabelColor = Color(0xFFFA5A00)
                            )
                        )

                        Spacer(modifier = Modifier.height(12.dp))

                        // New Password
                        OutlinedTextField(
                            value = newPassword,
                            onValueChange = {
                                newPassword = it
                                errorMessage = null
                            },
                            label = { Text("New Password (min. 6 characters)") },
                            modifier = Modifier.fillMaxWidth(),
                            shape = RoundedCornerShape(14.dp),
                            visualTransformation = if (showNewPassword) VisualTransformation.None else PasswordVisualTransformation(),
                            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
                            trailingIcon = {
                                IconButton(onClick = { showNewPassword = !showNewPassword }) {
                                    Icon(
                                        imageVector = if (showNewPassword) Icons.Default.VisibilityOff else Icons.Default.Visibility,
                                        contentDescription = "Toggle visibility",
                                        tint = Color(0xFF9CA3AF)
                                    )
                                }
                            },
                            colors = OutlinedTextFieldDefaults.colors(
                                focusedBorderColor = Color(0xFFFA5A00),
                                focusedLabelColor = Color(0xFFFA5A00)
                            )
                        )

                        // Password strength meter
                        if (newPassword.isNotEmpty()) {
                            Spacer(modifier = Modifier.height(6.dp))
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                verticalAlignment = Alignment.CenterVertically,
                                horizontalArrangement = Arrangement.spacedBy(4.dp)
                            ) {
                                for (i in 1..3) {
                                    val barColor = when {
                                        i <= passwordStrength && passwordStrength == 1 -> Color(0xFFEF4444)
                                        i <= passwordStrength && passwordStrength == 2 -> Color(0xFFF59E0B)
                                        i <= passwordStrength && passwordStrength == 3 -> Color(0xFF10B981)
                                        else -> Color(0xFFE2E8F0)
                                    }
                                    Box(
                                        modifier = Modifier
                                            .weight(1f)
                                            .height(4.dp)
                                            .clip(CircleShape)
                                            .background(barColor)
                                    )
                                }
                            }
                            Spacer(modifier = Modifier.height(2.dp))
                            Text(
                                text = when (passwordStrength) {
                                    1 -> "Weak — add numbers or more letters"
                                    2 -> "Good — moderate security"
                                    else -> "Strong password"
                                },
                                fontSize = 11.sp,
                                color = when (passwordStrength) {
                                    1 -> Color(0xFFEF4444)
                                    2 -> Color(0xFFF59E0B)
                                    else -> Color(0xFF10B981)
                                }
                            )
                        }

                        Spacer(modifier = Modifier.height(12.dp))

                        // Confirm New Password
                        OutlinedTextField(
                            value = confirmPassword,
                            onValueChange = {
                                confirmPassword = it
                                errorMessage = null
                            },
                            label = { Text("Confirm New Password") },
                            modifier = Modifier.fillMaxWidth(),
                            shape = RoundedCornerShape(14.dp),
                            visualTransformation = if (showConfirmPassword) VisualTransformation.None else PasswordVisualTransformation(),
                            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
                            trailingIcon = {
                                IconButton(onClick = { showConfirmPassword = !showConfirmPassword }) {
                                    Icon(
                                        imageVector = if (showConfirmPassword) Icons.Default.VisibilityOff else Icons.Default.Visibility,
                                        contentDescription = "Toggle visibility",
                                        tint = Color(0xFF9CA3AF)
                                    )
                                }
                            },
                            colors = OutlinedTextFieldDefaults.colors(
                                focusedBorderColor = Color(0xFFFA5A00),
                                focusedLabelColor = Color(0xFFFA5A00)
                            )
                        )

                        if (errorMessage != null) {
                            Spacer(modifier = Modifier.height(8.dp))
                            Text(
                                text = errorMessage!!,
                                color = Color(0xFFDC2626),
                                fontSize = 12.sp,
                                fontWeight = FontWeight.Medium
                            )
                        }

                        Spacer(modifier = Modifier.height(24.dp))

                        Surface(
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(50.dp)
                                .shadow(6.dp, CircleShape, spotColor = Color(0x35FA5A00))
                                .clip(CircleShape)
                                .clickable {
                                    when {
                                        currentPassword.isEmpty() -> {
                                            errorMessage = "Please enter your current password."
                                        }
                                        newPassword.length < 6 -> {
                                            errorMessage = "New password must be at least 6 characters."
                                        }
                                        newPassword != confirmPassword -> {
                                            errorMessage = "New passwords do not match."
                                        }
                                        else -> {
                                            isPasswordDialogOpen = false
                                            Toast.makeText(context, "Password updated successfully!", Toast.LENGTH_LONG).show()
                                        }
                                    }
                                },
                            shape = CircleShape,
                            color = Color(0xFFFA5A00)
                        ) {
                            Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                                Text(
                                    text = "Update Password",
                                    color = Color.White,
                                    fontSize = 15.sp,
                                    fontWeight = FontWeight.Bold
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}

/**
 * Menu Item Row for Profile Settings (Icon + Title + Trailing Chevron)
 */
@Composable
private fun ProfileMenuRow(
    icon: ImageVector,
    title: String,
    trailingText: String? = null,
    onClick: () -> Unit,
    testTag: String
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable { onClick() }
            .padding(horizontal = 20.dp, vertical = 18.dp)
            .testTag(testTag),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            modifier = Modifier.weight(1f)
        ) {
            Icon(
                imageVector = icon,
                contentDescription = title,
                tint = Color(0xFF1F2937),
                modifier = Modifier.size(22.dp)
            )
            Spacer(modifier = Modifier.width(16.dp))
            Text(
                text = title,
                color = Color(0xFF1F2937),
                fontSize = 15.sp,
                fontWeight = FontWeight.Medium
            )
        }

        Row(verticalAlignment = Alignment.CenterVertically) {
            if (trailingText != null) {
                Text(
                    text = trailingText,
                    color = Color(0xFF9CA3AF),
                    fontSize = 13.sp,
                    fontWeight = FontWeight.Normal
                )
                Spacer(modifier = Modifier.width(6.dp))
            }
            Icon(
                imageVector = Icons.AutoMirrored.Filled.KeyboardArrowRight,
                contentDescription = null,
                tint = Color(0xFFCBD5E1),
                modifier = Modifier.size(20.dp)
            )
        }
    }
}

/**
 * Generic Selection Dialog for Language, Currencies, Appearance
 */
@Composable
private fun SelectionOptionDialog(
    title: String,
    options: List<String>,
    selectedOption: String,
    onSelect: (String) -> Unit,
    onDismiss: () -> Unit
) {
    Dialog(
        onDismissRequest = onDismiss,
        properties = DialogProperties(usePlatformDefaultWidth = false)
    ) {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(Color.Black.copy(alpha = 0.5f))
                .clickable { onDismiss() },
            contentAlignment = Alignment.Center
        ) {
            Surface(
                modifier = Modifier
                    .fillMaxWidth(0.88f)
                    .clickable(enabled = false) {},
                shape = RoundedCornerShape(28.dp),
                color = Color.White
            ) {
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(24.dp)
                ) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(
                            text = title,
                            fontSize = 20.sp,
                            fontWeight = FontWeight.Bold,
                            color = Color(0xFF111827)
                        )
                        IconButton(onClick = onDismiss) {
                            Icon(imageVector = Icons.Default.Close, contentDescription = "Close", tint = Color(0xFF9CA3AF))
                        }
                    }

                    Spacer(modifier = Modifier.height(14.dp))

                    options.forEach { option ->
                        val isSelected = option == selectedOption
                        Surface(
                            modifier = Modifier
                                .fillMaxWidth()
                                .clip(RoundedCornerShape(14.dp))
                                .clickable { onSelect(option) }
                                .padding(vertical = 4.dp),
                            shape = RoundedCornerShape(14.dp),
                            color = if (isSelected) Color(0xFFFFF1E6) else Color.Transparent
                        ) {
                            Row(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .padding(horizontal = 16.dp, vertical = 12.dp),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Text(
                                    text = option,
                                    fontSize = 15.sp,
                                    fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Normal,
                                    color = if (isSelected) Color(0xFFFA5A00) else Color(0xFF1F2937)
                                )
                                if (isSelected) {
                                    Icon(
                                        imageVector = Icons.Default.Check,
                                        contentDescription = "Selected",
                                        tint = Color(0xFFFA5A00),
                                        modifier = Modifier.size(18.dp)
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

/**
 * Security Toggle Row Component
 */
@Composable
private fun SecurityToggleRow(
    title: String,
    subtitle: String,
    checked: Boolean,
    onCheckedChange: (Boolean) -> Unit
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column(modifier = Modifier.weight(1f)) {
            Text(
                text = title,
                fontSize = 14.sp,
                fontWeight = FontWeight.SemiBold,
                color = Color(0xFF111827)
            )
            Text(
                text = subtitle,
                fontSize = 12.sp,
                color = Color(0xFF9CA3AF)
            )
        }
        Spacer(modifier = Modifier.width(12.dp))
        Switch(
            checked = checked,
            onCheckedChange = onCheckedChange,
            colors = SwitchDefaults.colors(
                checkedThumbColor = Color.White,
                checkedTrackColor = Color(0xFFFA5A00),
                uncheckedThumbColor = Color.White,
                uncheckedTrackColor = Color(0xFFE2E8F0)
            )
        )
    }
}

/**
 * Device Session Item Card with Revoke Action
 */
@Composable
private fun DeviceSessionCard(
    device: ConnectedDevice,
    onRevoke: () -> Unit
) {
    Surface(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(16.dp),
        color = Color(0xFFF8FAFC),
        border = androidx.compose.foundation.BorderStroke(1.dp, Color(0xFFF1F5F9))
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(14.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Box(
                modifier = Modifier
                    .size(40.dp)
                    .clip(CircleShape)
                    .background(if (device.isCurrentDevice) Color(0xFFDCFCE7) else Color(0xFFE2E8F0)),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = when (device.deviceType) {
                        "Laptop" -> Icons.Default.Computer
                        "Tablet" -> Icons.Default.Tablet
                        else -> Icons.Default.Smartphone
                    },
                    contentDescription = null,
                    tint = if (device.isCurrentDevice) Color(0xFF16A34A) else Color(0xFF475569),
                    modifier = Modifier.size(20.dp)
                )
            }

            Spacer(modifier = Modifier.width(12.dp))

            Column(modifier = Modifier.weight(1f)) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(
                        text = device.deviceName,
                        fontSize = 14.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color(0xFF111827)
                    )
                    if (device.isCurrentDevice) {
                        Spacer(modifier = Modifier.width(6.dp))
                        Surface(
                            shape = CircleShape,
                            color = Color(0xFFDCFCE7)
                        ) {
                            Text(
                                text = "THIS DEVICE",
                                fontSize = 9.sp,
                                fontWeight = FontWeight.Bold,
                                color = Color(0xFF16A34A),
                                modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
                            )
                        }
                    }
                }
                Spacer(modifier = Modifier.height(2.dp))
                Text(
                    text = "${device.location} • ${device.lastActive}",
                    fontSize = 12.sp,
                    color = Color(0xFF9CA3AF)
                )
            }

            if (!device.isCurrentDevice) {
                IconButton(
                    onClick = onRevoke,
                    modifier = Modifier.size(32.dp)
                ) {
                    Icon(
                        imageVector = Icons.Default.DeleteOutline,
                        contentDescription = "Sign out device",
                        tint = Color(0xFFEF4444),
                        modifier = Modifier.size(18.dp)
                    )
                }
            }
        }
    }
}
