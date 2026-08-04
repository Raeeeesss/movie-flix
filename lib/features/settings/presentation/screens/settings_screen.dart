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
  String _videoQuality = 'Auto (4K HDR)';
  bool _autoplay = true;
  bool _hdrEnabled = true;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final prefs = ref.watch(userPreferencesProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings & Preferences'),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // User Card Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.deepRed.withValues(alpha: 0.8), AppColors.darkGraphite],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(prefs.avatarUrl),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(prefs.userName, style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 4),
                      Text(prefs.membershipType, style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w600, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_rounded, color: AppColors.white),
                  onPressed: () => context.push('/profile'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Section 1: Account ─────────────────────────────────────────
          _buildSectionHeader('Account'),
          _buildCardGroup([
            _buildListTile(Icons.person_outline_rounded, 'Profile Settings', prefs.userEmail, () => context.push('/profile')),
            _buildListTile(Icons.card_membership_rounded, 'Membership & Billing', prefs.membershipType, () {}),
            _buildListTile(Icons.devices_rounded, 'Manage Connected Devices', '2 Devices Active', () {}),
            _buildListTile(Icons.security_rounded, 'Privacy & Security', '2FA Enabled', () {}),
          ]),

          const SizedBox(height: 24),

          // ── Section 2: Personalization & Appearance ────────────────────
          _buildSectionHeader('Personalization'),
          _buildCardGroup([
            // Theme Mode Selector
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.palette_outlined, color: AppColors.gold, size: 20),
                      SizedBox(width: 12),
                      Text('Appearance Theme', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<ThemeMode>(
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
                ],
              ),
            ),
            const Divider(height: 1),
            _buildListTile(Icons.language_rounded, 'Preferred Languages', prefs.preferredLanguages.join(', '), () {}),
            _buildListTile(Icons.auto_awesome_rounded, 'AI Recommendation Tuning', 'High Personalization', () {}),
            _buildSwitchTile(Icons.play_circle_outline_rounded, 'Autoplay Trailers', _autoplay, (val) => setState(() => _autoplay = val)),
          ]),

          const SizedBox(height: 24),

          // ── Section 3: Playback ────────────────────────────────────────
          _buildSectionHeader('Playback'),
          _buildCardGroup([
            _buildListTile(Icons.high_quality_rounded, 'Streaming Quality', _videoQuality, () {
              setState(() => _videoQuality = _videoQuality.contains('Auto') ? '1080p Full HD' : 'Auto (4K HDR)');
            }),
            _buildSwitchTile(Icons.hdr_on_rounded, 'HDR & Dolby Vision', _hdrEnabled, (val) => setState(() => _hdrEnabled = val)),
            _buildListTile(Icons.subtitles_rounded, 'Default Subtitle Language', 'English (CC)', () {}),
            _buildListTile(Icons.speed_rounded, 'Playback Speed', '1.0x (Normal)', () {}),
          ]),

          const SizedBox(height: 24),

          // ── Section 4: Live Cinema Alerts ──────────────────────────────
          _buildSectionHeader('Live Cinema Alerts'),
          _buildCardGroup([
            _buildSwitchTile(Icons.notifications_active_rounded, 'Breaking Movie News', true, (val) {}),
            _buildSwitchTile(Icons.ondemand_video_rounded, 'Official Trailer Drop Alerts', true, (val) {}),
          ]),

          const SizedBox(height: 24),

          // ── Section 5: Support & About ─────────────────────────────────
          _buildSectionHeader('Support & Legal'),
          _buildCardGroup([
            _buildListTile(Icons.help_outline_rounded, 'Help Center & FAQ', '', () {}),
            _buildListTile(Icons.feedback_outlined, 'Send Feedback', '', () {}),
            _buildListTile(Icons.policy_outlined, 'Privacy Policy & Terms', '', () {}),
            _buildListTile(Icons.info_outline_rounded, 'About MovieFlix AI', 'v1.0.0 (Production Build)', () {}),
          ]),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.gold,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCardGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.gold, size: 22),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.white50)) : null,
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.white30),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppColors.gold, size: 22),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      value: value,
      activeTrackColor: AppColors.deepRed,
      onChanged: onChanged,
    );
  }
}
