import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/utils/debounce.dart';
import '../../providers/movie_providers.dart';
import '../../../user/providers/user_preferences_provider.dart';
import '../widgets/movie_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 400));

  @override
  void initState() {
    super.initState();
    _ctrl.text = ref.read(searchQueryProvider);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focusNode.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onChanged(String q) {
    setState(() {});
    _debouncer.run(() => ref.read(searchQueryProvider.notifier).state = q);
  }

  void _clear() {
    _ctrl.clear();
    ref.read(searchQueryProvider.notifier).state = '';
    setState(() {});
  }

  void _submitSearch(String q) {
    _ctrl.text = q;
    ref.read(searchQueryProvider.notifier).state = q;
    setState(() {});
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final searchAsync = ref.watch(searchMoviesProvider);
    final prefs = ref.watch(userPreferencesProvider);

    final List<String> personalizedSearches = [
      ...prefs.favoriteActors,
      ...prefs.favoriteDirectors,
      ...prefs.favoriteIndustries,
      ...prefs.favoriteGenres,
      ...prefs.preferredLanguages,
    ].take(10).toList();

    if (personalizedSearches.isEmpty) {
      personalizedSearches.addAll([
        'Mohanlal',
        'Lucifer',
        'Drishyam',
        'Malayalam Action',
        'Mollywood',
        'Malaikottai Vaaliban',
        'Avengers',
        'Christopher Nolan',
        'Tom Cruise',
      ]);
    }

    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Discover',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ).animate().fadeIn().slideY(begin: -0.1, end: 0),
                  const SizedBox(height: 4),
                  Text(
                    'Explore millions of movies, stars & directors',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ).animate().fadeIn(delay: 100.ms),
                ],
              ),
            ),

            // ── Search Bar ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: _focusNode.hasFocus
                            ? AppColors.primaryAccent.withValues(alpha: 0.8)
                            : AppColors.divider,
                        width: 1.5,
                      ),
                    ),
                    child: TextField(
                      controller: _ctrl,
                      focusNode: _focusNode,
                      onChanged: _onChanged,
                      onSubmitted: _submitSearch,
                      style: const TextStyle(
                          color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        hintText: 'Search movies, actors, directors...',
                        hintStyle:
                            const TextStyle(color: AppColors.textSecondary, fontSize: 15),
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: AppColors.textSecondary, size: 22),
                        suffixIcon: _ctrl.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close_rounded,
                                    color: AppColors.textSecondary, size: 20),
                                onPressed: _clear,
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 150.ms),
            ),

            // ── Body ─────────────────────────────────────────────────────
            Expanded(
              child: query.trim().isEmpty
                  ? _buildEmptyState(personalizedSearches)
                  : searchAsync.when(
                      data: (movies) {
                        if (movies.isEmpty) return _buildNoResults(query);
                        return GridView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.52,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: movies.length,
                          itemBuilder: (context, index) {
                            final m = movies[index];
                            return MovieCard(
                              movie: m,
                              heroTag: 'search_${m.id}_$index',
                              width: double.infinity,
                              height: 215,
                            )
                                .animate(
                                    delay: Duration(milliseconds: index * 30))
                                .fadeIn(duration: 300.ms)
                                .scale(
                                    begin: const Offset(0.96, 0.96),
                                    end: const Offset(1, 1));
                          },
                        );
                      },
                      loading: () => Shimmer.fromColors(
                        baseColor: AppColors.cardBg,
                        highlightColor: AppColors.secondaryBg,
                        child: GridView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.58,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: 6,
                          itemBuilder: (context, index) => Container(
                            decoration: BoxDecoration(
                              color: AppColors.cardBg,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      error: (err, _) => Center(
                        child: Text(
                          'Search error: $err',
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(List<String> suggestions) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.auto_awesome_rounded, color: AppColors.gold, size: 18),
              SizedBox(width: 8),
              Text(
                'Personalized Suggestions',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: suggestions
                .asMap()
                .entries
                .map((e) => GestureDetector(
                      onTap: () => _submitSearch(e.value),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 9),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.trending_up_rounded,
                                color: AppColors.primaryAccent, size: 15),
                            const SizedBox(width: 6),
                            Text(
                              e.value,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        .animate(delay: Duration(milliseconds: 150 + e.key * 30))
                        .fadeIn(duration: 300.ms)
                        .slideX(begin: 0.08, end: 0))
                .toList(),
          ),
          const SizedBox(height: 48),
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: const Icon(
                    Icons.movie_filter_rounded,
                    color: AppColors.primaryAccent,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Search movies, stars & directors',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 350.ms),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults(String query) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded, color: AppColors.textSecondary, size: 64),
            const SizedBox(height: 20),
            Text(
              'No results found for "$query"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Try searching for your favorite actors, directors, or genres',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ).animate().fadeIn(duration: 400.ms),
      ),
    );
  }
}
