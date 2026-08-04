import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../app/theme/theme_provider.dart';
import '../../../user/providers/user_preferences_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final prefs = ref.read(userPreferencesProvider);
    _nameCtrl = TextEditingController(text: prefs.userName);
    _emailCtrl = TextEditingController(text: prefs.userEmail);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();

    await ref.read(userPreferencesProvider.notifier).updateProfile(
          userName: name.isNotEmpty ? name : 'Cinematic Explorer',
          userEmail: email.isNotEmpty ? email : 'explorer@cinestream.ai',
        );

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile details saved locally successfully!'),
          backgroundColor: AppColors.primaryAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final prefs = ref.watch(userPreferencesProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBg,
        elevation: 0,
        title: const Text(
          'Settings & Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // ── Profile Avatar & Edit Header ─────────────────────────────────────
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 46,
                  backgroundColor: AppColors.cardBg,
                  backgroundImage: NetworkImage(prefs.avatarUrl),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Section 1: Edit Profile (Stored Locally) ─────────────────────────
          _buildSectionTitle('Profile Details (Saved Locally)'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _nameCtrl,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: const InputDecoration(
                    labelText: 'Display Name',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.primaryAccent),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.divider)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryAccent)),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _emailCtrl,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: const InputDecoration(
                    labelText: 'Email Address / Handle',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    prefixIcon: Icon(Icons.email_outlined, color: AppColors.primaryAccent),
                    enabledBorder: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryAccent)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Save Profile Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isSaving ? null : _saveProfile,
              icon: _isSaving
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.save_rounded, size: 20),
              label: const Text('Save Profile Changes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),

          const SizedBox(height: 28),

          // ── Section 2: Saved Preferences ────────────────────────────────────
          _buildSectionTitle('Saved Preferences'),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              children: [
                _buildSavedDetailTile(
                  icon: Icons.language_rounded,
                  title: 'App & Content Language',
                  value: prefs.preferredAppLanguage,
                ),
                const Divider(height: 1, color: AppColors.divider),
                _buildSavedDetailTile(
                  icon: Icons.high_quality_rounded,
                  title: 'Streaming Quality',
                  value: prefs.streamingQuality,
                ),
                const Divider(height: 1, color: AppColors.divider),
                _buildSavedDetailTile(
                  icon: Icons.movie_filter_rounded,
                  title: 'Favorite Genres',
                  value: prefs.favoriteGenres.isNotEmpty ? prefs.favoriteGenres.join(', ') : 'Action, Sci-Fi, Drama',
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // ── Section 3: Appearance Theme ─────────────────────────────────────
          _buildSectionTitle('Appearance Theme'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode_outlined)),
                ButtonSegment(value: ThemeMode.light, label: Text('Light'), icon: Icon(Icons.light_mode_outlined)),
                ButtonSegment(value: ThemeMode.system, label: Text('System'), icon: Icon(Icons.phone_android_outlined)),
              ],
              selected: {themeMode},
              onSelectionChanged: (set) {
                ref.read(themeModeProvider.notifier).setThemeMode(set.first);
              },
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSavedDetailTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryAccent, size: 22),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
      trailing: Text(value, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
    );
  }
}
