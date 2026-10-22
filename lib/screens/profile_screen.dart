import 'package:flutter/material.dart';
import '../state/task_provider.dart';

enum ProfileModal {
  none,
  editProfile,
  fullAvatar,
  cropAvatar,
  changePassword,
  googleAccount,
  logout,
  security,
  language,
  currency,
  appearance,
}

class ProfileScreen extends StatefulWidget {
  final TaskProvider provider;

  const ProfileScreen({Key? key, required this.provider}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileModal _activeModal = ProfileModal.none;

  // Edit Profile Form Controllers
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _roleCtrl;
  late TextEditingController _locationCtrl;
  late TextEditingController _bioCtrl;

  // Change Password Form Controllers & State
  final TextEditingController _oldPassCtrl = TextEditingController();
  final TextEditingController _newPassCtrl = TextEditingController();
  final TextEditingController _confirmPassCtrl = TextEditingController();
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  String? _passwordError;

  // Google Account Form Controller
  final TextEditingController _googleEmailCtrl = TextEditingController();

  // Avatar Crop/Zoom Working State
  double _tempCropScale = 1.35;
  double _tempCropDx = 0.0;
  double _tempCropDy = -0.15;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _nameCtrl = TextEditingController(text: widget.provider.userName);
    _emailCtrl = TextEditingController(text: widget.provider.userEmail);
    _phoneCtrl = TextEditingController(text: widget.provider.userPhone);
    _roleCtrl = TextEditingController(text: widget.provider.userRole);
    _locationCtrl = TextEditingController(text: widget.provider.userLocation);
    _bioCtrl = TextEditingController(text: widget.provider.userBio);
    _googleEmailCtrl.text = widget.provider.userEmail;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _roleCtrl.dispose();
    _locationCtrl.dispose();
    _bioCtrl.dispose();
    _oldPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    _googleEmailCtrl.dispose();
    super.dispose();
  }

  void _openModal(ProfileModal modal) {
    setState(() {
      _activeModal = modal;
      if (modal == ProfileModal.editProfile) {
        _nameCtrl.text = widget.provider.userName;
        _emailCtrl.text = widget.provider.userEmail;
        _phoneCtrl.text = widget.provider.userPhone;
        _roleCtrl.text = widget.provider.userRole;
        _locationCtrl.text = widget.provider.userLocation;
        _bioCtrl.text = widget.provider.userBio;
      } else if (modal == ProfileModal.changePassword) {
        _oldPassCtrl.clear();
        _newPassCtrl.clear();
        _confirmPassCtrl.clear();
        _passwordError = null;
        _obscureOld = true;
        _obscureNew = true;
        _obscureConfirm = true;
      } else if (modal == ProfileModal.cropAvatar) {
        _tempCropScale = widget.provider.avatarScale;
        _tempCropDx = widget.provider.avatarOffsetX;
        _tempCropDy = widget.provider.avatarOffsetY;
      } else if (modal == ProfileModal.googleAccount) {
        _googleEmailCtrl.text = widget.provider.userEmail;
      }
    });
  }

  void _closeModal() {
    setState(() {
      _activeModal = ProfileModal.none;
    });
  }

  Widget _buildRawAvatarImage(double? width, double? height, {BoxFit fit = BoxFit.cover}) {
    return Image.asset(
      'assets/images/profile.png',
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'profile.png',
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return Image.network(
              'profile.png',
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Text(
                    'AD',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: (width != null && width < 60) ? 16 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildFramedAvatar({double size = 86}) {
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: Transform.scale(
          scale: widget.provider.avatarScale,
          alignment: Alignment(widget.provider.avatarOffsetX, widget.provider.avatarOffsetY),
          child: _buildRawAvatarImage(size, size, fit: BoxFit.cover),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Base Profile Content Scrollable Screen
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFF1E6),
                Color(0xFFFDF7F2),
                Color(0xFFFAF8F6),
                Color(0xFFFFFFFF),
              ],
            ),
          ),
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              children: [
                // Top Bar Navigation & Header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => widget.provider.setSelectedTab(0),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_back,
                            size: 20,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),

                // Main Profile Card (Framed Avatar, Tap to Full, Crop Badge, Name, Subtitle, Edit Profile button)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // User Avatar with Tap to View Full + Crop Badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          GestureDetector(
                            onTap: () => _openModal(ProfileModal.fullAvatar),
                            child: Container(
                              width: 86,
                              height: 86,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF1E293B),
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.12),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: _buildFramedAvatar(size: 86),
                            ),
                          ),
                          // Edit / Crop badge button
                          Positioned(
                            right: -2,
                            bottom: -2,
                            child: GestureDetector(
                              onTap: () => _openModal(ProfileModal.cropAvatar),
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFA5A00),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.18),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.crop_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // User Name
                      Text(
                        widget.provider.userName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Email
                      Text(
                        widget.provider.userEmail,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Role and Location Subtitle (Wrapped to prevent any 42px overflow)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          runSpacing: 2,
                          children: [
                            Text(
                              widget.provider.userRole,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                            ),
                            const Text(
                              '•',
                              style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF9CA3AF)),
                                const SizedBox(width: 2),
                                Text(
                                  widget.provider.userLocation,
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Signature Orange "Edit Profile" Pill Button
                      GestureDetector(
                        onTap: () => _openModal(ProfileModal.editProfile),
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFA5A00),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFA5A00).withOpacity(0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.edit_outlined, size: 16, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Edit Profile',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Settings Card 1: Language, Currencies, Appearance
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildMenuRow(
                        icon: Icons.translate_rounded,
                        title: 'Language',
                        trailing: widget.provider.selectedLanguage.split(' ').first,
                        onTap: () => _openModal(ProfileModal.language),
                      ),
                      const Divider(height: 1, indent: 18, endIndent: 18, color: Color(0xFFF1F5F9)),
                      _buildMenuRow(
                        icon: Icons.qr_code_scanner_rounded,
                        title: 'Currencies',
                        trailing: widget.provider.selectedCurrency,
                        onTap: () => _openModal(ProfileModal.currency),
                      ),
                      const Divider(height: 1, indent: 18, endIndent: 18, color: Color(0xFFF1F5F9)),
                      _buildMenuRow(
                        icon: Icons.palette_outlined,
                        title: 'Appearance',
                        trailing: widget.provider.selectedTheme,
                        onTap: () => _openModal(ProfileModal.appearance),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Settings Card 2: Security, Google Account, Password (Manage Devices & Sandbox completely removed)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildMenuRow(
                        icon: Icons.security_rounded,
                        title: 'Application Security',
                        trailing: widget.provider.biometricEnabled ? 'Biometric On' : 'Basic',
                        onTap: () => _openModal(ProfileModal.security),
                      ),
                      const Divider(height: 1, indent: 18, endIndent: 18, color: Color(0xFFF1F5F9)),
                      _buildMenuRow(
                        icon: Icons.account_circle_outlined,
                        title: 'Google Account',
                        trailing: widget.provider.isGoogleConnected ? 'Connected' : 'Not Linked',
                        onTap: () => _openModal(ProfileModal.googleAccount),
                      ),
                      const Divider(height: 1, indent: 18, endIndent: 18, color: Color(0xFFF1F5F9)),
                      _buildMenuRow(
                        icon: Icons.pin_outlined,
                        title: 'Change Password',
                        trailing: '••••••',
                        onTap: () => _openModal(ProfileModal.changePassword),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Settings Card 3: Log Out
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _buildMenuRow(
                    icon: Icons.logout_rounded,
                    title: widget.provider.isLoggedIn ? 'Log Out' : 'Sign Back In',
                    trailing: widget.provider.isLoggedIn ? 'Active' : 'Signed Out',
                    iconColor: widget.provider.isLoggedIn ? const Color(0xFFDC2626) : const Color(0xFF059669),
                    textColor: widget.provider.isLoggedIn ? const Color(0xFFDC2626) : const Color(0xFF059669),
                    onTap: () {
                      if (widget.provider.isLoggedIn) {
                        _openModal(ProfileModal.logout);
                      } else {
                        widget.provider.login();
                        widget.provider.showToast('Welcome back!', icon: Icons.login_rounded);
                      }
                    },
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),

        // 2. IN-APP MODAL OVERLAYS (STRICTLY CONFINED INSIDE PHONE SHAPE)
        if (_activeModal != ProfileModal.none)
          _buildInAppModalBackdrop(),
      ],
    );
  }

  Widget _buildInAppModalBackdrop() {
    return Positioned.fill(
      child: Stack(
        children: [
          // Dismiss on tapping outside
          GestureDetector(
            onTap: _closeModal,
            child: Container(
              color: Colors.black.withOpacity(0.55),
            ),
          ),

          // Modal Card
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: _buildModalCardContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModalCardContent() {
    switch (_activeModal) {
      case ProfileModal.editProfile:
        return _buildEditProfileModal();
      case ProfileModal.fullAvatar:
        return _buildFullAvatarModal();
      case ProfileModal.cropAvatar:
        return _buildCropAvatarModal();
      case ProfileModal.changePassword:
        return _buildChangePasswordModal();
      case ProfileModal.googleAccount:
        return _buildGoogleAccountModal();
      case ProfileModal.logout:
        return _buildLogoutModal();
      case ProfileModal.security:
        return _buildSecurityModal();
      case ProfileModal.language:
        return _buildLanguageModal();
      case ProfileModal.currency:
        return _buildCurrencyModal();
      case ProfileModal.appearance:
        return _buildAppearanceModal();
      case ProfileModal.none:
      default:
        return const SizedBox.shrink();
    }
  }

  // --- MODAL 1: EDIT PROFILE ---
  Widget _buildEditProfileModal() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 380),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Edit Profile',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20, color: Color(0xFF6B7280)),
                onPressed: _closeModal,
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _emailCtrl,
            decoration: InputDecoration(
              labelText: 'Email Address',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _phoneCtrl,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _roleCtrl,
            decoration: InputDecoration(
              labelText: 'Professional Role',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _locationCtrl,
            decoration: InputDecoration(
              labelText: 'Location',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _bioCtrl,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Bio & Focus',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () {
                widget.provider.updateProfile(
                  name: _nameCtrl.text.trim(),
                  email: _emailCtrl.text.trim(),
                  phone: _phoneCtrl.text.trim(),
                  role: _roleCtrl.text.trim(),
                  location: _locationCtrl.text.trim(),
                  bio: _bioCtrl.text.trim(),
                );
                _closeModal();
                widget.provider.showToast('Profile updated successfully!');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFA5A00),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // --- MODAL 2: FULL PHOTO PREVIEW ---
  Widget _buildFullAvatarModal() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 380),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.provider.userName,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      widget.provider.userRole,
                      style: const TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                  onPressed: _closeModal,
                ),
              ],
            ),
          ),

          // Photo Display
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              height: 280,
              width: double.infinity,
              color: Colors.black,
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 3.5,
                child: Center(
                  child: _buildRawAvatarImage(double.infinity, 280, fit: BoxFit.contain),
                ),
              ),
            ),
          ),

          // Actions
          Padding(
            padding: const EdgeInsets.all(14),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.crop_rounded, size: 16, color: Colors.white),
                label: const Text('Adjust Avatar Framing', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF334155)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => _openModal(ProfileModal.cropAvatar),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- MODAL 3: CIRCULAR CROP & ZOOM TOOL ---
  Widget _buildCropAvatarModal() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 380),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.crop_rotate_rounded, color: Color(0xFFFA5A00), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Framing & Zoom',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20, color: Color(0xFF6B7280)),
                onPressed: _closeModal,
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Drag to reposition or adjust zoom to choose which part appears inside your circular profile avatar.',
            style: TextStyle(fontSize: 11.5, color: Color(0xFF6B7280)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),

          // Interactive Crop Area with Circular Shadow Mask
          Container(
            width: 210,
            height: 210,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(18),
            ),
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _tempCropDx = (_tempCropDx - (details.delta.dx / 80)).clamp(-1.0, 1.0);
                  _tempCropDy = (_tempCropDy - (details.delta.dy / 80)).clamp(-1.0, 1.0);
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.scale(
                    scale: _tempCropScale,
                    alignment: Alignment(_tempCropDx, _tempCropDy),
                    child: _buildRawAvatarImage(210, 210, fit: BoxFit.cover),
                  ),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _CircleMaskPainter(diameter: 170),
                    ),
                  ),
                  IgnorePointer(
                    child: Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.9), width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Zoom Slider
          Row(
            children: [
              const Icon(Icons.zoom_out, size: 18, color: Color(0xFF64748B)),
              Expanded(
                child: Slider(
                  value: _tempCropScale,
                  min: 1.0,
                  max: 3.0,
                  divisions: 20,
                  activeColor: const Color(0xFFFA5A00),
                  inactiveColor: const Color(0xFFE2E8F0),
                  onChanged: (val) {
                    setState(() => _tempCropScale = val);
                  },
                ),
              ),
              const Icon(Icons.zoom_in, size: 18, color: Color(0xFF64748B)),
            ],
          ),

          // Presets
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _tempCropScale = 1.35;
                    _tempCropDx = 0.0;
                    _tempCropDy = -0.15;
                  });
                },
                child: const Text('Face Focus', style: TextStyle(fontSize: 12, color: Color(0xFFFA5A00), fontWeight: FontWeight.bold)),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _tempCropScale = 1.0;
                    _tempCropDx = 0.0;
                    _tempCropDy = 0.0;
                  });
                },
                child: const Text('Reset', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Apply Button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                widget.provider.updateAvatarFraming(_tempCropScale, _tempCropDx, _tempCropDy);
                _closeModal();
                widget.provider.showToast('Avatar framing applied!');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFA5A00),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                'Apply Framing',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- MODAL 4: CHANGE PASSWORD ---
  Widget _buildChangePasswordModal() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 380),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.lock_reset_rounded, color: Color(0xFFFA5A00), size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Change Password',
                    style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20, color: Color(0xFF6B7280)),
                onPressed: _closeModal,
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Enter your current password and choose a secure new password (min. 6 characters).',
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          if (_passwordError != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFCA5A5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, size: 16, color: Color(0xFFDC2626)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _passwordError!,
                      style: const TextStyle(color: Color(0xFFDC2626), fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          TextField(
            controller: _oldPassCtrl,
            obscureText: _obscureOld,
            decoration: InputDecoration(
              labelText: 'Current Password',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              suffixIcon: IconButton(
                icon: Icon(_obscureOld ? Icons.visibility_off : Icons.visibility, size: 18),
                onPressed: () => setState(() => _obscureOld = !_obscureOld),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _newPassCtrl,
            obscureText: _obscureNew,
            decoration: InputDecoration(
              labelText: 'New Password',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              suffixIcon: IconButton(
                icon: Icon(_obscureNew ? Icons.visibility_off : Icons.visibility, size: 18),
                onPressed: () => setState(() => _obscureNew = !_obscureNew),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _confirmPassCtrl,
            obscureText: _obscureConfirm,
            decoration: InputDecoration(
              labelText: 'Confirm New Password',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility, size: 18),
                onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () {
                final oldP = _oldPassCtrl.text.trim();
                final newP = _newPassCtrl.text.trim();
                final confP = _confirmPassCtrl.text.trim();

                if (!widget.provider.verifyPassword(oldP)) {
                  setState(() => _passwordError = 'Current password is incorrect.');
                  return;
                }
                if (newP.length < 6) {
                  setState(() => _passwordError = 'New password must be at least 6 characters.');
                  return;
                }
                if (newP != confP) {
                  setState(() => _passwordError = 'Passwords do not match.');
                  return;
                }

                final success = widget.provider.changePassword(oldP, newP);
                if (success) {
                  _closeModal();
                  widget.provider.showToast('Password updated successfully!');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFA5A00),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Save Password', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // --- MODAL 5: GOOGLE ACCOUNT ---
  Widget _buildGoogleAccountModal() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 380),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Google Account',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20, color: Color(0xFF6B7280)),
                onPressed: _closeModal,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.provider.isGoogleConnected
                ? 'Currently linked with ${widget.provider.googleAccountEmail}. Calendar and routine sync is active.'
                : 'Connect your Google account to automatically synchronize routines and tasks across devices.',
            style: const TextStyle(fontSize: 13, color: Color(0xFF4B5563)),
          ),
          if (!widget.provider.isGoogleConnected) ...[
            const SizedBox(height: 14),
            TextField(
              controller: _googleEmailCtrl,
              decoration: InputDecoration(
                labelText: 'Google Email Address',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
          ],
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                if (widget.provider.isGoogleConnected) {
                  widget.provider.disconnectGoogle();
                } else {
                  widget.provider.connectGoogle(_googleEmailCtrl.text.trim());
                }
                _closeModal();
                widget.provider.showToast(
                  widget.provider.isGoogleConnected
                      ? 'Connected to Google account'
                      : 'Google account disconnected',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.provider.isGoogleConnected ? const Color(0xFFDC2626) : const Color(0xFFFA5A00),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                widget.provider.isGoogleConnected ? 'Disconnect Account' : 'Connect Account',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- MODAL 6: LOG OUT CONFIRMATION ---
  Widget _buildLogoutModal() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 360),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.logout_rounded, color: Color(0xFFDC2626), size: 22),
                  SizedBox(width: 8),
                  Text('Log Out', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20, color: Color(0xFF6B7280)),
                onPressed: _closeModal,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Are you sure you want to log out of your session on this device?',
            style: TextStyle(fontSize: 13.5, color: Color(0xFF4B5563)),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _closeModal,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF6B7280),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.provider.logout();
                    _closeModal();
                    widget.provider.showToast(
                      'Logged out successfully.',
                      icon: Icons.logout_rounded,
                      color: const Color(0xFFDC2626),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Log Out', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- MODAL 7: APPLICATION SECURITY ---
  Widget _buildSecurityModal() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 380),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.security_rounded, color: Color(0xFFFA5A00), size: 22),
                  SizedBox(width: 8),
                  Text('Security Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20, color: Color(0xFF6B7280)),
                onPressed: _closeModal,
              ),
            ],
          ),
          const SizedBox(height: 6),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Biometric Authentication', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
            subtitle: const Text('Use fingerprint or face recognition', style: TextStyle(fontSize: 11.5)),
            value: widget.provider.biometricEnabled,
            activeColor: const Color(0xFFFA5A00),
            onChanged: (val) {
              setState(() => widget.provider.toggleBiometrics());
            },
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Auto-Lock on Inactivity', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
            subtitle: const Text('Lock session after 5 minutes', style: TextStyle(fontSize: 11.5)),
            value: widget.provider.autoLockEnabled,
            activeColor: const Color(0xFFFA5A00),
            onChanged: (val) {
              setState(() => widget.provider.toggleAutoLock());
            },
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Two-Factor Authentication', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
            subtitle: const Text('Enhanced sync verification', style: TextStyle(fontSize: 11.5)),
            value: widget.provider.twoFactorEnabled,
            activeColor: const Color(0xFFFA5A00),
            onChanged: (val) {
              setState(() => widget.provider.toggleTwoFactor());
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: _closeModal,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFA5A00),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // --- MODAL 8: LANGUAGE ---
  Widget _buildLanguageModal() {
    final languages = ['English (US)', 'Spanish (ES)', 'French (FR)', 'German (DE)', 'Japanese (JP)'];
    return Container(
      constraints: const BoxConstraints(maxWidth: 360),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Select Language', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
              IconButton(
                icon: const Icon(Icons.close, size: 20, color: Color(0xFF6B7280)),
                onPressed: _closeModal,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...languages.map((lang) {
            final isSel = widget.provider.selectedLanguage == lang;
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              title: Text(lang, style: TextStyle(fontSize: 14.5, fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
              trailing: isSel ? const Icon(Icons.check, color: Color(0xFFFA5A00), size: 20) : null,
              onTap: () {
                widget.provider.setSelectedLanguage(lang);
                _closeModal();
              },
            );
          }),
        ],
      ),
    );
  }

  // --- MODAL 9: CURRENCIES ---
  Widget _buildCurrencyModal() {
    final currencies = ['USD (\$)', 'EUR (€)', 'GBP (£)', 'CAD (\$)', 'JPY (¥)'];
    return Container(
      constraints: const BoxConstraints(maxWidth: 360),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Select Currency', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
              IconButton(
                icon: const Icon(Icons.close, size: 20, color: Color(0xFF6B7280)),
                onPressed: _closeModal,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...currencies.map((curr) {
            final isSel = widget.provider.selectedCurrency == curr;
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              title: Text(curr, style: TextStyle(fontSize: 14.5, fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
              trailing: isSel ? const Icon(Icons.check, color: Color(0xFFFA5A00), size: 20) : null,
              onTap: () {
                widget.provider.setSelectedCurrency(curr);
                _closeModal();
              },
            );
          }),
        ],
      ),
    );
  }

  // --- MODAL 10: APPEARANCE ---
  Widget _buildAppearanceModal() {
    final themes = ['Light Theme', 'Dark Minimal', 'System Match'];
    return Container(
      constraints: const BoxConstraints(maxWidth: 360),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Theme Appearance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
              IconButton(
                icon: const Icon(Icons.close, size: 20, color: Color(0xFF6B7280)),
                onPressed: _closeModal,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...themes.map((th) {
            final isSel = widget.provider.selectedTheme == th;
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              title: Text(th, style: TextStyle(fontSize: 14.5, fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
              trailing: isSel ? const Icon(Icons.check, color: Color(0xFFFA5A00), size: 20) : null,
              onTap: () {
                widget.provider.setSelectedTheme(th);
                _closeModal();
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMenuRow({
    required IconData icon,
    required String title,
    required String trailing,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: iconColor ?? const Color(0xFF6B7280)),
                const SizedBox(width: 14),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: textColor ?? const Color(0xFF111827),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  trailing,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: Color(0xFFCBD5E1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleMaskPainter extends CustomPainter {
  final double diameter;

  _CircleMaskPainter({required this.diameter});

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.68)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = diameter / 2;

    // Create dark background overlay with circular cutout hole
    final fullRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final circlePath = Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    final overlayPath = Path.combine(
      PathOperation.difference,
      Path()..addRect(fullRect),
      circlePath,
    );

    canvas.drawPath(overlayPath, backgroundPaint);

    // Subtle white outline around the crop window
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _CircleMaskPainter oldDelegate) => oldDelegate.diameter != diameter;
}
