import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/services/recommendation_engine.dart';
import '../../models/movie.dart';
import '../../providers/movie_providers.dart';
import '../../../user/providers/user_preferences_provider.dart';
import '../widgets/hero_banner.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _appBarScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted) return;
    final isScrolled = _scrollController.offset > 40;
    if (isScrolled != _appBarScrolled) setState(() => _appBarScrolled = isScrolled);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    ref.read(movieRepositoryProvider).clearCache();
    ref.invalidate(aiRecommendedMoviesProvider);
    ref.invalidate(becauseYouWatchedMoviesProvider);
    ref.invalidate(actressPersonalizedMoviesProvider);
    ref.invalidate(popularInLanguageMoviesProvider);
    ref.invalidate(directorPersonalizedMoviesProvider);
    ref.invalidate(genreLanguagePersonalizedMoviesProvider);
    ref.invalidate(trendingMoviesProvider);
    ref.invalidate(topRatedMoviesProvider);
    ref.invalidate(popularMoviesProvider);
    ref.invalidate(nowPlayingMoviesProvider);
    ref.invalidate(upcomingMoviesProvider);
    ref.invalidate(actionMoviesProvider);
    ref.invalidate(comedyMoviesProvider);
    ref.invalidate(horrorMoviesProvider);
    ref.invalidate(scifiMoviesProvider);
    ref.invalidate(dramaMoviesProvider);
    ref.invalidate(animationMoviesProvider);
    ref.invalidate(thrillerMoviesProvider);
    ref.invalidate(awardWinnersProvider);
    ref.invalidate(classicMoviesProvider);
    ref.invalidate(southMoviesProvider);
    ref.invalidate(bollywoodMoviesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(userPreferencesProvider);
    final userName = prefs.userName.isNotEmpty ? prefs.userName : 'Cinematic Explorer';

    final topActor    = prefs.favoriteActors.isNotEmpty ? prefs.favoriteActors.first : 'Mohanlal';
    final topActress  = prefs.favoriteActresses.isNotEmpty ? prefs.favoriteActresses.first : 'Sai Pallavi';
    final topDirector = prefs.favoriteDirectors.isNotEmpty ? prefs.favoriteDirectors.first : 'Lijo Jose Pellissery';
    final mainLang    = prefs.preferredLanguages.isNotEmpty ? prefs.preferredLanguages.first : 'Malayalam';
    final mainIndustry= prefs.favoriteIndustries.isNotEmpty ? prefs.favoriteIndustries.first : 'Mollywood';
    final topGenre    = prefs.favoriteGenres.isNotEmpty ? prefs.favoriteGenres.first : 'Action';

    final sections = <_SectionConfig>[
      _SectionConfig('Latest movies', nowPlayingMoviesProvider, 'now_playing', isLandscape: false),
      _SectionConfig('Top rated', topRatedMoviesProvider, 'toprated', isLandscape: true),
      _SectionConfig('Recommended for you', aiRecommendedMoviesProvider, 'airecs', isLandscape: false),
      _SectionConfig('Because you like $topActor', becauseYouWatchedMoviesProvider, 'because_actor', isLandscape: false),
      _SectionConfig('Starring $topActress', actressPersonalizedMoviesProvider, 'actress', isLandscape: false),
      _SectionConfig('Directed by $topDirector', directorPersonalizedMoviesProvider, 'director', isLandscape: false),
      _SectionConfig('Trending in $mainIndustry', trendingMoviesProvider, 'trending', isLandscape: true),
      _SectionConfig('Popular blockbusters', popularMoviesProvider, 'popular', isLandscape: false),
      _SectionConfig('Coming soon', upcomingMoviesProvider, 'upcoming', isLandscape: false),
      _SectionConfig('$mainLang $topGenre movies', genreLanguagePersonalizedMoviesProvider, 'genre_lang', isLandscape: false),
      _SectionConfig('Popular in $mainLang', popularInLanguageMoviesProvider, 'poplang', isLandscape: false),
      _SectionConfig('Action & Thrillers', actionMoviesProvider, 'action', isLandscape: false),
      _SectionConfig('Comedy classics', comedyMoviesProvider, 'comedy', isLandscape: false),
      _SectionConfig('Sci-Fi & Fantasy', scifiMoviesProvider, 'scifi', isLandscape: false),
      _SectionConfig('Drama & Cinema', dramaMoviesProvider, 'drama', isLandscape: false),
      _SectionConfig('Horror & Mystery', horrorMoviesProvider, 'horror', isLandscape: false),
      _SectionConfig('Edge of your seat thrillers', thrillerMoviesProvider, 'thriller', isLandscape: false),
      _SectionConfig('Animated gems', animationMoviesProvider, 'animation', isLandscape: false),
      _SectionConfig('Editor\'s picks & awards', awardWinnersProvider, 'awards', isLandscape: true),
      _SectionConfig('South cinema', southMoviesProvider, 'south', isLandscape: false),
      _SectionConfig('Bollywood classics', bollywoodMoviesProvider, 'bollywood', isLandscape: false),
    ];

    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          color: AppColors.primaryAccent,
          backgroundColor: AppColors.cardBg,
          displacement: 100,
          onRefresh: _onRefresh,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Top Bar Header ──────────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    MediaQuery.of(context).padding.top + 16,
                    20,
                    12,
                  ),
                  decoration: BoxDecoration(
                    color: _appBarScrolled
                        ? AppColors.primaryBg.withValues(alpha: 0.95)
                        : Colors.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // User Welcome Title
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome back,',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            userName,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ],
                      ),

                      // Header Rounded Action Buttons
                      Row(
                        children: [
                          _CircularHeaderButton(
                            icon: Icons.notifications_none_rounded,
                            onPressed: () => context.push('/settings'),
                          ),
                          const SizedBox(width: 12),
                          _CircularHeaderButton(
                            icon: Icons.search_rounded,
                            onPressed: () => context.go('/search'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ── Hero Banner Section ─────────────────────────────────────
              SliverToBoxAdapter(
                child: Consumer(
                  builder: (context, ref, child) {
                    final aiRecsAsync = ref.watch(aiRecommendedMoviesProvider);
                    return aiRecsAsync.when(
                      data: (movies) => HeroBanner(movies: movies),
                      loading: () => const _HeroSkeleton(),
                      error: (err, stack) => const _HeroSkeleton(),
                    );
                  },
                ),
              ),

              // ── Live Cinema News & Industry Pulse ───────────────────────
              const SliverToBoxAdapter(
                child: _LiveMovieNewsWidget(),
              ),

              // ── Home Category Sections (Lazy Evaluated) ──────────────────
              SliverPadding(
                padding: const EdgeInsets.only(top: 16, bottom: 40),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final sec = sections[index];
                      return _LazySection(config: sec);
                    },
                    childCount: sections.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircularHeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _CircularHeaderButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: AppColors.textPrimary, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}

class _SectionConfig {
  final String title;
  final ProviderListenable<AsyncValue<List<Movie>>> provider;
  final String tagPrefix;
  final bool isLandscape;

  _SectionConfig(this.title, this.provider, this.tagPrefix, {this.isLandscape = false});
}

class _LazySection extends ConsumerWidget {
  final _SectionConfig config;

  const _LazySection({required this.config});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(config.provider);
    final itemHeight = config.isLandscape ? 175.0 : 275.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: asyncValue.when(
        data: (movies) {
          if (movies.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        config.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => context.push(
                        '/category/${config.tagPrefix}?title=${Uri.encodeComponent(config.title)}',
                      ),
                      child: const Text(
                        'See all',
                        style: TextStyle(
                          color: Color(0xFF2F80ED),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Horizontal Scroll Movies
              SizedBox(
                height: itemHeight,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 20, right: 6),
                  physics: const BouncingScrollPhysics(),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final m = movies[index];
                    if (config.isLandscape) {
                      return LandscapeMovieCard(
                        movie: m,
                        heroTag: '${config.tagPrefix}_land_${m.id}_$index',
                      );
                    }
                    return MovieCard(
                      movie: m,
                      heroTag: '${config.tagPrefix}_${m.id}_$index',
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => _SectionSkeleton(title: config.title, isLandscape: config.isLandscape),
        error: (err, stack) => _SectionSkeleton(title: config.title, isLandscape: config.isLandscape),
      ),
    );
  }
}

class _HeroSkeleton extends StatelessWidget {
  const _HeroSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.cardBg,
      highlightColor: AppColors.secondaryBg,
      child: Container(
        height: 380,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}

class _SectionSkeleton extends StatelessWidget {
  final String title;
  final bool isLandscape;
  const _SectionSkeleton({required this.title, this.isLandscape = false});

  @override
  Widget build(BuildContext context) {
    final itemHeight = isLandscape ? 175.0 : 275.0;
    final itemWidth = isLandscape ? 220.0 : 145.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 16, 14),
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        SizedBox(
          height: itemHeight,
          child: Shimmer.fromColors(
            baseColor: AppColors.cardBg,
            highlightColor: AppColors.secondaryBg,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20),
              itemCount: 5,
              itemBuilder: (context, index) => Container(
                width: itemWidth,
                margin: const EdgeInsets.only(right: 14),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LiveMovieNewsWidget extends StatelessWidget {
  const _LiveMovieNewsWidget();

  @override
  Widget build(BuildContext context) {
    final newsList = [
      {
        'title': 'Empuraan (Lucifer 2) World Release Date Announced',
        'category': 'BREAKING NEWS',
        'time': '10 mins ago',
        'desc': 'Prithviraj Sukumaran & Mohanlal confirm 4K IMAX worldwide theatrical event.',
        'color': const Color(0xFFE50914),
      },
      {
        'title': 'Aavesham Crosses ₹150 Crore Worldwide Box Office',
        'category': 'BOX OFFICE PULSE',
        'time': '1 hour ago',
        'desc': 'Fahadh Faasil starrer sets record-breaking run in Kerala & Overseas markets.',
        'color': const Color(0xFFFFB800),
      },
      {
        'title': 'Bramayugam 2 Expansion in Active Production',
        'category': 'INDUSTRY PULSE',
        'time': '3 hours ago',
        'desc': 'Rahul Sadasivan hints at expanding Malabar folk horror saga with Mammootty.',
        'color': const Color(0xFF00E5FF),
      },
      {
        'title': 'Avatar: Fire and Ash Production Teaser Released',
        'category': 'GLOBAL EXCLUSIVE',
        'time': '5 hours ago',
        'desc': 'James Cameron showcases revolutionary new Pandora visual effects technology.',
        'color': const Color(0xFF9E00FF),
      },
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Live Cinema Pulse & News',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                  ),
                ),
                const Spacer(),
                const Text(
                  'LIVE UPDATING',
                  style: TextStyle(
                    color: AppColors.primaryAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final item = newsList[index];
                final catColor = item['color'] as Color;
                return Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider.withValues(alpha: 0.6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: catColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: catColor.withValues(alpha: 0.4), width: 0.5),
                              ),
                              child: Text(
                                item['category'] as String,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: catColor,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item['time'] as String,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        item['title'] as String,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
