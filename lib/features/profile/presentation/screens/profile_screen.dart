import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../user/providers/user_preferences_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(userPreferencesProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.gold),
            onPressed: () => _showEditProfileModal(context, ref, prefs),
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: AppColors.white),
            onPressed: () => context.push('/settings'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // Avatar + Name + Username + Membership
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundImage: NetworkImage(prefs.avatarUrl),
                      ),
                      GestureDetector(
                        onTap: () => _showEditProfileModal(context, ref, prefs),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.deepRed,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt_rounded, color: AppColors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    prefs.userName,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '@${prefs.username}',
                    style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${prefs.userEmail} · ${prefs.stateRegion}, ${prefs.country}',
                    style: const TextStyle(color: AppColors.white50, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.goldFaded,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.gold.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.stars_rounded, color: AppColors.gold, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          prefs.membershipType,
                          style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Cinema Intelligence Stats Grid
            Row(
              children: [
                _buildStatCard('Movies Explored', '${prefs.watchHistory.length + 42}', Icons.movie_filter_rounded),
                const SizedBox(width: 10),
                _buildStatCard('Trailers Watched', '184', Icons.play_circle_fill_rounded),
                const SizedBox(width: 10),
                _buildStatCard('Pulse Score', '98%', Icons.auto_awesome_rounded),
              ],
            ),

            const SizedBox(height: 24),

            // Profile Details & Personalization Overview Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Profile & Personalization', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.gold),
                        onPressed: () => _showEditProfileModal(context, ref, prefs),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  _prefRow('Date of Birth', prefs.dob),
                  _prefRow('Gender', prefs.gender),
                  _prefRow('Location', '${prefs.stateRegion}, ${prefs.country}'),
                  _prefRow('App Language', prefs.preferredAppLanguage),
                  _prefRow('Audio Language', prefs.preferredAudioLanguage),
                  _prefRow('Subtitles', prefs.preferredSubtitleLanguage),
                  _prefRow('Languages', prefs.preferredLanguages.join(', ')),
                  _prefRow('Industries', prefs.favoriteIndustries.join(', ')),
                  _prefRow('Actors', prefs.favoriteActors.join(', ')),
                  _prefRow('Actresses', prefs.favoriteActresses.join(', ')),
                  _prefRow('Directors', prefs.favoriteDirectors.join(', ')),
                  _prefRow('Genres', prefs.favoriteGenres.join(', ')),
                  _prefRow('Movie Length', prefs.preferredMovieLength),
                  _prefRow('Favorite Era', prefs.favoriteDecade),
                  _prefRow('Watch Context', prefs.watchContext),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quick Actions
            ListTile(
              leading: const Icon(Icons.bookmark_rounded, color: AppColors.gold),
              title: const Text('My Watchlist & Favorites'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
              onTap: () => context.go('/watchlist'),
            ),
            ListTile(
              leading: const Icon(Icons.settings_rounded, color: AppColors.gold),
              title: const Text('App Settings & Preferences'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
              onTap: () => context.push('/settings'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.gold, size: 20),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 2),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.white50, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _prefRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(color: AppColors.white50, fontSize: 12))),
          Expanded(child: Text(val.isEmpty ? 'Not set' : val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
        ],
      ),
    );
  }

  void _showEditProfileModal(BuildContext context, WidgetRef ref, prefs) {
    final nameController = TextEditingController(text: prefs.userName);
    final usernameController = TextEditingController(text: prefs.username);
    final emailController = TextEditingController(text: prefs.userEmail);
    final dobController = TextEditingController(text: prefs.dob);
    final stateController = TextEditingController(text: prefs.stateRegion);
    final countryController = TextEditingController(text: prefs.country);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardSurface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Edit Profile & Personalization', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Full Name')),
              const SizedBox(height: 12),
              TextField(controller: usernameController, decoration: const InputDecoration(labelText: 'Username')),
              const SizedBox(height: 12),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email Address')),
              const SizedBox(height: 12),
              TextField(controller: dobController, decoration: const InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)')),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextField(controller: stateController, decoration: const InputDecoration(labelText: 'State'))),
                  const SizedBox(width: 10),
                  Expanded(child: TextField(controller: countryController, decoration: const InputDecoration(labelText: 'Country'))),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.deepRed),
                  onPressed: () {
                    ref.read(userPreferencesProvider.notifier).updateProfile(
                          userName: nameController.text.trim(),
                          username: usernameController.text.trim(),
                          userEmail: emailController.text.trim(),
                          dob: dobController.text.trim(),
                          stateRegion: stateController.text.trim(),
                          country: countryController.text.trim(),
                        );
                    Navigator.pop(context);
                  },
                  child: const Text('Save Profile Changes', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
