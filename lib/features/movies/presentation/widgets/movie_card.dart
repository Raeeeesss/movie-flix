import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_theme.dart';
import '../../models/movie.dart';
import '../../../watchlist/providers/watchlist_provider.dart';

class MovieCard extends ConsumerStatefulWidget {
  final Movie movie;
  final String heroTag;
  final double width;
  final double height;
  final EdgeInsetsGeometry? margin;

  const MovieCard({
    super.key,
    required this.movie,
    required this.heroTag,
    this.width = 145,
    this.height = 218,
    this.margin,
  });

  @override
  ConsumerState<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends ConsumerState<MovieCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 0.04,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _pressController.forward();
  void _onTapUp(_) => _pressController.reverse();
  void _onTapCancel() => _pressController.reverse();

  @override
  Widget build(BuildContext context) {
    final isFavorite =
        ref.watch(watchlistProvider).asData?.value.any((i) => i.id == widget.movie.id) ?? false;
    final posterUrl = widget.movie.posterUrl;
    final ratingStr = widget.movie.formattedRating;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: () => context.push('/movie/${widget.movie.id}', extra: widget.movie),
      onLongPress: () => _showQuickActions(context),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: child,
        ),
        child: Container(
          width: widget.width,
          margin: widget.margin ?? (widget.width == double.infinity ? EdgeInsets.zero : const EdgeInsets.only(right: 14)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Poster Container with Dynamic Shadow ─────────────────────
              Hero(
                tag: widget.heroTag,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.45),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        // Cached poster image
                        SizedBox(
                          width: widget.width,
                          height: widget.height,
                          child: CachedNetworkImage(
                            imageUrl: posterUrl,
                            fit: BoxFit.cover,
                            memCacheWidth: 1200,
                            fadeInDuration: const Duration(milliseconds: 250),
                            errorWidget: (context, url, error) => _buildCustomPosterCard(),
                          ),
                        ),

                        // Top subtle gradient overlay
                        Positioned(
                          top: 0, left: 0, right: 0,
                          height: 54,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.65),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Language Badge Tag (Top-Right)
                        Positioned(
                          top: 8, right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.cardBg.withValues(alpha: 0.90),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.primaryAccent.withValues(alpha: 0.5), width: 0.8),
                            ),
                            child: Text(
                              widget.movie.language,
                              style: const TextStyle(
                                color: AppColors.gold,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),

                        // Watchlist Heart Button (Top-Left)
                        Positioned(
                          top: 2, left: 2,
                          child: Semantics(
                            label: isFavorite ? 'Remove from watchlist' : 'Add to watchlist',
                            button: true,
                            child: SizedBox(
                              width: 44,
                              height: 44,
                              child: Center(
                                child: GestureDetector(
                                  onTap: () => ref
                                      .read(watchlistProvider.notifier)
                                      .toggleWatchlist(widget.movie),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.5),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isFavorite
                                                ? AppColors.primaryAccent.withValues(alpha: 0.9)
                                                : Colors.white24,
                                            width: 1,
                                          ),
                                        ),
                                        child: Icon(
                                          isFavorite
                                              ? Icons.favorite_rounded
                                              : Icons.favorite_border_rounded,
                                          color: isFavorite
                                              ? AppColors.primaryAccent
                                              : AppColors.textPrimary,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Rating badge (Bottom-Left)
                        if (ratingStr != null)
                          Positioned(
                            bottom: 8, left: 8,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.65),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: AppColors.gold.withValues(alpha: 0.4)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.star_rounded,
                                          color: AppColors.gold, size: 12),
                                      const SizedBox(width: 3),
                                      Text(
                                        ratingStr,
                                        style: const TextStyle(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Title + Metadata (Reference design format) ──────────────
              const SizedBox(height: 8),
              Text(
                widget.movie.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  letterSpacing: -0.1,
                ),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppColors.primaryAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.primaryAccent.withValues(alpha: 0.35), width: 0.5),
                    ),
                    child: Text(
                      widget.movie.language.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.primaryAccent,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      '${widget.movie.year} • ${widget.movie.formattedDuration != 'N/A' ? widget.movie.formattedDuration : ''}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomPosterCard() {
    final hash = widget.movie.title.hashCode.abs();
    final hue1 = (hash % 360).toDouble();
    final hue2 = ((hash + 60) % 360).toDouble();
    final color1 = HSLColor.fromAHSL(1.0, hue1, 0.65, 0.20).toColor();
    final color2 = HSLColor.fromAHSL(1.0, hue2, 0.70, 0.10).toColor();

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color1, color2],
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.movie_filter_rounded, color: Colors.white54, size: 36),
          const SizedBox(height: 10),
          Text(
            widget.movie.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
          if (widget.movie.genres.isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.movie.genres.first.name,
                style: const TextStyle(color: AppColors.gold, fontSize: 9, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    final isFav =
        ref.read(watchlistProvider).asData?.value.any((i) => i.id == widget.movie.id) ??
            false;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBg,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Text(
                widget.movie.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800),
              ),
            ),
            const Divider(color: AppColors.divider, height: 1),
            ListTile(
              leading: Icon(
                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: isFav ? AppColors.primaryAccent : AppColors.textSecondary,
              ),
              title: Text(
                isFav ? 'Remove from My List' : 'Add to My List',
                style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                if (Navigator.canPop(context)) Navigator.pop(context);
                ref.read(watchlistProvider.notifier).toggleWatchlist(widget.movie);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline_rounded, color: AppColors.textSecondary),
              title: const Text('View Movie Details',
                  style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
              onTap: () {
                if (Navigator.canPop(context)) Navigator.pop(context);
                context.push('/movie/${widget.movie.id}', extra: widget.movie);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Landscape Movie Card (Exact match for "Top rated" section in Reference Image)
// ─────────────────────────────────────────────────────────────────────────────
class LandscapeMovieCard extends ConsumerWidget {
  final Movie movie;
  final String heroTag;
  final double width;
  final double height;

  const LandscapeMovieCard({
    super.key,
    required this.movie,
    required this.heroTag,
    this.width = 220,
    this.height = 135,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backdropUrl = movie.backdropUrl;
    final subtitleText = movie.formattedDuration != 'N/A'
        ? '${movie.formattedDuration} • ${movie.genres.isNotEmpty ? movie.genres.first.name : movie.year}'
        : '${movie.year} • ${movie.genres.isNotEmpty ? movie.genres.first.name : 'Cinema'}';

    return GestureDetector(
      onTap: () => context.push('/movie/${movie.id}', extra: movie),
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: heroTag,
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.45),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Backdrop Image
                      CachedNetworkImage(
                        imageUrl: backdropUrl,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        memCacheWidth: 600,
                        placeholder: (context, url) => Container(color: AppColors.cardBg),
                        errorWidget: (context, url, error) => Image.network(
                          Movie.fallbackBackdrop,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Scrim Overlay
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black87,
                            ],
                            stops: [0.4, 1.0],
                          ),
                        ),
                      ),

                      // Pill Tag (Top Right - Language Badge)
                      Positioned(
                        top: 8, right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primaryAccent.withValues(alpha: 0.5), width: 0.8),
                          ),
                          child: Text(
                            movie.language,
                            style: const TextStyle(
                              color: AppColors.gold,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),

                      // Title & Metadata overlaid at bottom (Reference style)
                      Positioned(
                        bottom: 8, left: 10, right: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              movie.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                shadows: [
                                  Shadow(blurRadius: 8, color: Colors.black, offset: Offset(0, 1))
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subtitleText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
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
          ],
        ),
      ),
    );
  }
}
