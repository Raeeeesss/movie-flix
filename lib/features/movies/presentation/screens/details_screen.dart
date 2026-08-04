import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/theme/app_theme.dart';
import '../../models/movie.dart';
import '../../providers/movie_providers.dart';
import '../../../watchlist/providers/watchlist_provider.dart';
import '../widgets/cast_card.dart';
import '../widgets/movie_card.dart';
import '../widgets/trailer_player_dialog.dart';

class DetailsScreen extends ConsumerStatefulWidget {
  final int movieId;
  final Movie? initialMovie;

  const DetailsScreen({super.key, required this.movieId, this.initialMovie});

  @override
  ConsumerState<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends ConsumerState<DetailsScreen> {
  Color _dominantColor = AppColors.cardBg;

  @override
  void initState() {
    super.initState();
    if (widget.initialMovie != null) {
      _extractColor(widget.initialMovie!.posterUrl);
    }
  }

  Future<void> _extractColor(String url) async {
    try {
      final provider = CachedNetworkImageProvider(url);
      final gen = await PaletteGenerator.fromImageProvider(
        provider,
        size: const Size(120, 180),
        maximumColorCount: 8,
        timeout: const Duration(milliseconds: 300),
      ).timeout(const Duration(milliseconds: 300));
      final c = gen.darkVibrantColor?.color ??
          gen.darkMutedColor?.color ??
          gen.dominantColor?.color;
      if (c != null && mounted) setState(() => _dominantColor = c);
    } catch (_) {}
  }

  void _safePop(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailsAsync = ref.watch(movieDetailsProvider(widget.movieId));
    final creditsAsync = ref.watch(movieCreditsProvider(widget.movieId));
    final trailersAsync = ref.watch(movieTrailersProvider(widget.movieId));
    final recsAsync = ref.watch(movieRecommendationsProvider(widget.movieId));
    final isFavorite = ref.watch(watchlistProvider).asData?.value
            .any((i) => i.id == widget.movieId) ?? false;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && mounted) {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/home');
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryBg,
        body: detailsAsync.when(
          data: (movie) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _extractColor(movie.posterUrl);
            });
            return _buildContent(context, movie, creditsAsync, trailersAsync, recsAsync, isFavorite);
          },
          loading: () => widget.initialMovie != null
              ? _buildContent(context, widget.initialMovie!, creditsAsync, trailersAsync, recsAsync, isFavorite)
              : const _DetailsLoadingState(),
          error: (err, _) => _DetailsErrorState(
            error: err.toString(),
            onRetry: () => ref.invalidate(movieDetailsProvider(widget.movieId)),
            onBack: () => _safePop(context),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    Movie movie,
    AsyncValue creditsAsync,
    AsyncValue trailersAsync,
    AsyncValue<List<Movie>> recsAsync,
    bool isFavorite,
  ) {
    final subtitleText = movie.formattedDuration != 'N/A'
        ? '${movie.formattedDuration}  •  ${movie.genres.isNotEmpty ? movie.genres.first.name : 'Movie'}  ${movie.year}'
        : '${movie.year}  •  ${movie.genres.isNotEmpty ? movie.genres.first.name : 'Movie'}';

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Cinematic Backdrop Header (Reference design exact layout) ────────
        SliverAppBar(
          expandedHeight: 320,
          pinned: true,
          stretch: true,
          backgroundColor: AppColors.primaryBg,
          leading: GestureDetector(
            onTap: () => _safePop(context),
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: AppColors.white, size: 20),
            ),
          ),
          actions: [
            // Share Button
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sharing "${movie.title}"')),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8, top: 10, bottom: 10),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.share_outlined, color: AppColors.white, size: 20),
              ),
            ),
            // Favorite Button
            GestureDetector(
              onTap: () => ref
                  .read(watchlistProvider.notifier)
                  .toggleWatchlist(movie),
              child: Container(
                margin: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isFavorite
                        ? AppColors.primaryAccent.withValues(alpha: 0.8)
                        : Colors.white24,
                  ),
                ),
                child: Icon(
                  isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isFavorite ? AppColors.primaryAccent : AppColors.white,
                  size: 20,
                ),
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [StretchMode.zoomBackground],
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Backdrop Image
                CachedNetworkImage(
                  imageUrl: movie.backdropUrl,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  memCacheWidth: 1080,
                  placeholder: (context, url) => Container(color: AppColors.cardBg),
                  errorWidget: (context, url, error) => Image.network(
                    Movie.fallbackBackdrop,
                    fit: BoxFit.cover,
                  ),
                ),

                // Dark Scrim Gradient Overlay with Ambient Dynamic Tint
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _dominantColor.withValues(alpha: 0.15),
                        Colors.transparent,
                        AppColors.primaryBg,
                      ],
                      stops: const [0.0, 0.4, 1.0],
                    ),
                  ),
                ),

                // Central Circular Play Trailer Button (Reference design)
                Center(
                  child: GestureDetector(
                    onTap: () {
                      trailersAsync.whenData((trailers) {
                        final yt = trailers
                            .where((t) => t.isYouTubeTrailer || t.site.toLowerCase() == 'youtube')
                            .toList();
                        if (yt.isNotEmpty) {
                          showDialog(
                            context: context,
                            builder: (_) => TrailerPlayerDialog(
                              youtubeKey: yt.first.key,
                              title: movie.title,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('No trailer available')),
                          );
                        }
                      });
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipOval(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 1.5),
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: AppColors.white,
                                size: 36,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Play trailer',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            shadows: [
                              Shadow(blurRadius: 8, color: Colors.black)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Details Body Overlay Container (Rounded top corners) ─────────────
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.primaryBg,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag Handle Bar (Reference design)
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Movie Title (Reference design format)
                Text(
                  movie.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 10),

                // Metadata Row (Language badge + Rating badge + Runtime • Genre Year)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryAccent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.primaryAccent.withValues(alpha: 0.6)),
                      ),
                      child: Text(
                        movie.language.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.primaryAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: const Text(
                        '18+',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        subtitleText,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Action Buttons Row: Share Movie + Large "Watch Official Trailer" YouTube Pill CTA
                Row(
                  children: [
                    // Share Movie Action Button
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Sharing info for "${movie.title}"...')),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.share_rounded, color: AppColors.white, size: 24),
                          SizedBox(height: 4),
                          Text(
                            'Share',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Watch Official Trailer (YouTube Connector) CTA Button
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE50914),
                            foregroundColor: AppColors.white,
                            elevation: 0,
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            trailersAsync.whenData((trailers) {
                              final yt = trailers
                                  .where((t) => t.isYouTubeTrailer || t.site.toLowerCase() == 'youtube')
                                  .toList();
                              if (yt.isNotEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (_) => TrailerPlayerDialog(
                                    youtubeKey: yt.first.key,
                                    title: movie.title,
                                  ),
                                );
                              } else {
                                final query = Uri.encodeComponent('${movie.title} official trailer');
                                final ytUrl = Uri.parse('https://www.youtube.com/results?search_query=$query');
                                launchUrl(ytUrl, mode: LaunchMode.externalApplication);
                              }
                            });
                          },
                          icon: const Icon(Icons.play_circle_fill_rounded, size: 22, color: Colors.white),
                          label: const Text(
                            'Watch Official Trailer',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Synopsis Description Paragraph
                Text(
                  movie.overview.isNotEmpty
                      ? movie.overview
                      : 'No overview available for this title.',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),

                // Cast Section (Reference exact header: Cast | Director & crew, See all)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Cast',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Director & crew',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Full cast list')),
                        );
                      },
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
                const SizedBox(height: 16),

                // Cast Horizontal Cards
                creditsAsync.when(
                  data: (credits) {
                    if (credits.isEmpty) {
                      return const Text(
                        'No cast information available.',
                        style: TextStyle(color: AppColors.textSecondary),
                      );
                    }
                    return SizedBox(
                      height: 125,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: credits.take(12).length,
                        itemBuilder: (context, index) => CastCard(
                          castMember: credits.elementAt(index),
                        ),
                      ),
                    );
                  },
                  loading: () => SizedBox(
                    height: 125,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) => Container(
                        width: 82,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  error: (context, error) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 28),

                // More Like This Recommendations Section
                const Text(
                  'More Like This',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                recsAsync.when(
                  data: (recs) {
                    if (recs.isEmpty) return const SizedBox.shrink();
                    return SizedBox(
                      height: 275,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: recs.length,
                        itemBuilder: (context, index) {
                          final m = recs[index];
                          return MovieCard(
                            movie: m,
                            heroTag: 'rec_${m.id}_$index',
                          );
                        },
                      ),
                    );
                  },
                  loading: () => SizedBox(
                    height: 275,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (_, i) => Container(
                        width: 145, height: 218,
                        margin: const EdgeInsets.only(right: 14),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  error: (context, error) => const SizedBox.shrink(),
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailsLoadingState extends StatelessWidget {
  const _DetailsLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primaryBg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primaryAccent),
            SizedBox(height: 20),
            Text('Loading movie details...',
                style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _DetailsErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  const _DetailsErrorState(
      {required this.error, required this.onRetry, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      appBar: AppBar(
          backgroundColor: AppColors.primaryBg,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.movie_outlined, color: AppColors.textSecondary, size: 72),
              const SizedBox(height: 20),
              const Text('Could not load movie',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Text(error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 28),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: onRetry,
                child: const Text('Retry', style: TextStyle(color: AppColors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
