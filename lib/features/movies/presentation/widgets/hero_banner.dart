import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../app/theme/app_theme.dart';
import '../../models/movie.dart';
import '../../../watchlist/providers/watchlist_provider.dart';

class HeroBanner extends ConsumerStatefulWidget {
  final List<Movie> movies;

  const HeroBanner({super.key, required this.movies});

  @override
  ConsumerState<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends ConsumerState<HeroBanner> {
  final PageController _pageController = PageController(viewportFraction: 1.0);
  int _activeIndex = 0;
  Timer? _autoSlideTimer;
  Color _dominantColor = AppColors.secondaryBg;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.movies.isNotEmpty) {
        _precacheImages();
        _extractColor(widget.movies[0]);
      }
    });
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || widget.movies.isEmpty) return;
      final count = widget.movies.length > 1 ? 2 : widget.movies.length;
      final next = (_activeIndex + 1) % count;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void _stopAutoSlide() {
    _autoSlideTimer?.cancel();
  }

  void _precacheImages() {
    final count = widget.movies.length > 7 ? 7 : widget.movies.length;
    for (int i = 0; i < count; i++) {
      final url = widget.movies[i].backdropUrl;
      precacheImage(CachedNetworkImageProvider(url), context);
    }
  }

  @override
  void dispose() {
    _stopAutoSlide();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _extractColor(Movie movie) async {
    if (!mounted) return;
    if (WidgetsBinding.instance.runtimeType.toString().contains('Test')) return;
    try {
      final provider = CachedNetworkImageProvider(movie.backdropUrl);
      final generator = await PaletteGenerator.fromImageProvider(
        provider,
        size: const Size(100, 100),
        maximumColorCount: 6,
      );
      final color = generator.darkVibrantColor?.color ??
          generator.darkMutedColor?.color ??
          generator.dominantColor?.color;
      if (color != null && mounted) {
        setState(() {
          _dominantColor = color;
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) return const _HeroBannerSkeleton();

    final count = widget.movies.length > 7 ? 7 : widget.movies.length;

    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 8),
      child: Column(
        children: [
          SizedBox(
            height: 230,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollStartNotification) {
                  _stopAutoSlide();
                } else if (notification is ScrollEndNotification) {
                  _startAutoSlide();
                }
                return false;
              },
              child: PageView.builder(
                controller: _pageController,
                itemCount: count,
                onPageChanged: (index) {
                  if (!mounted) return;
                  setState(() => _activeIndex = index);
                  _extractColor(widget.movies[index]);
                },
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double value = 1.0;
                      if (_pageController.position.haveDimensions) {
                        value = _pageController.page! - index;
                        value = (1 - (value.abs() * 0.05)).clamp(0.95, 1.0);
                      }
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: _HeroBannerSlide(
                      movie: widget.movies[index],
                      dominantColor: _dominantColor,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          AnimatedSmoothIndicator(
            activeIndex: _activeIndex,
            count: count,
            effect: const ExpandingDotsEffect(
              activeDotColor: AppColors.primaryAccent,
              dotColor: AppColors.white30,
              dotHeight: 5,
              dotWidth: 5,
              expansionFactor: 3.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBannerSlide extends ConsumerStatefulWidget {
  final Movie movie;
  final Color dominantColor;

  const _HeroBannerSlide({required this.movie, required this.dominantColor});

  @override
  ConsumerState<_HeroBannerSlide> createState() => _HeroBannerSlideState();
}

class _HeroBannerSlideState extends ConsumerState<_HeroBannerSlide> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isFavorite =
        ref.watch(watchlistProvider).asData?.value.any((i) => i.id == widget.movie.id) ?? false;
    final backdropUrl = widget.movie.backdropUrl;
    final posterUrl = widget.movie.posterUrl;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () => context.push('/movie/${widget.movie.id}', extra: widget.movie),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.dominantColor.withValues(alpha: 0.35),
                blurRadius: 16,
                spreadRadius: -2,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Backdrop Image
                CachedNetworkImage(
                  imageUrl: backdropUrl,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  memCacheWidth: 1080,
                  fadeInDuration: const Duration(milliseconds: 300),
                  placeholder: (context, url) => Container(color: AppColors.cardBg),
                  errorWidget: (context, url, error) => Image.network(
                    Movie.fallbackBackdrop,
                    fit: BoxFit.cover,
                  ),
                ),

                // Multi-stage Dark Scrim & Radial Glow Overlay
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.primaryBg.withValues(alpha: 0.95),
                        AppColors.primaryBg.withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.55, 1.0],
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppColors.primaryBg,
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.6],
                    ),
                  ),
                ),

                // Content Layout: Info on Left, Poster on Right
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      // Movie Info Column (Left)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Status / Genre Badge
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [AppColors.primaryAccent, AppColors.secondaryAccent],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    widget.movie.genres.isNotEmpty ? widget.movie.genres.first.name.toUpperCase() : 'FEATURED',
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryAccent.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: AppColors.primaryAccent.withValues(alpha: 0.5), width: 0.8),
                                  ),
                                  child: Text(
                                    widget.movie.language.toUpperCase(),
                                    style: const TextStyle(
                                      color: AppColors.primaryAccent,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                                if (widget.movie.formattedRating != null)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.star_rounded, color: AppColors.gold, size: 13),
                                      const SizedBox(width: 2),
                                      Text(
                                        widget.movie.formattedRating!,
                                        style: const TextStyle(
                                          color: AppColors.gold,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            // Title
                            Text(
                              widget.movie.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                height: 1.15,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Short Overview Description
                            if (widget.movie.overview.isNotEmpty)
                              Text(
                                widget.movie.overview,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                  height: 1.3,
                                ),
                              ),
                            const SizedBox(height: 10),

                            // Premium CTA Buttons
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                // View Details CTA
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryAccent.withValues(alpha: 0.4),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryAccent,
                                      foregroundColor: AppColors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    onPressed: () => context.push('/movie/${widget.movie.id}', extra: widget.movie),
                                    icon: const Icon(Icons.info_outline_rounded, size: 16),
                                    label: const Text(
                                      'Explore Details',
                                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                                    ),
                                  ),
                                ),

                                // Favorite / Watchlist Button
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                    child: IconButton(
                                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                      padding: EdgeInsets.zero,
                                      style: IconButton.styleFrom(
                                        backgroundColor: AppColors.glass,
                                        side: const BorderSide(color: AppColors.glassBorder),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      onPressed: () => ref
                                          .read(watchlistProvider.notifier)
                                          .toggleWatchlist(widget.movie),
                                      icon: Icon(
                                        isFavorite ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                        color: isFavorite ? AppColors.gold : AppColors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Movie Poster Thumbnail (Right)
                      Hero(
                        tag: 'hero_banner_poster_${widget.movie.id}',
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.6),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: CachedNetworkImage(
                              imageUrl: posterUrl,
                              width: 85,
                              height: 125,
                              fit: BoxFit.cover,
                              memCacheWidth: 300,
                              placeholder: (context, url) => Container(color: AppColors.cardBg),
                              errorWidget: (context, url, error) => Container(
                                width: 85,
                                height: 125,
                                color: AppColors.cardBg,
                                child: const Center(
                                  child: Icon(Icons.movie_rounded, color: AppColors.primaryAccent, size: 28),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroBannerSkeleton extends StatelessWidget {
  const _HeroBannerSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}
