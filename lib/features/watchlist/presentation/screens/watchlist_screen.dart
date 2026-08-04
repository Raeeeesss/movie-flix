import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_theme.dart';
import '../../providers/watchlist_provider.dart';
import '../../../movies/presentation/widgets/movie_card.dart';

class WatchlistScreen extends ConsumerStatefulWidget {
  const WatchlistScreen({super.key});

  @override
  ConsumerState<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends ConsumerState<WatchlistScreen> {
  bool _isGrid = true;

  @override
  Widget build(BuildContext context) {
    final watchlistAsync = ref.watch(watchlistProvider);

    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('My List',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            )).animate().fadeIn().slideY(begin: -0.1, end: 0),
                        watchlistAsync.when(
                          data: (items) => Text(
                            '${items.length} movie${items.length == 1 ? '' : 's'}',
                            style: const TextStyle(
                                color: AppColors.white50, fontSize: 14),
                          ).animate().fadeIn(delay: 100.ms),
                          loading: () => const SizedBox.shrink(),
                          error: (context, error) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                  // View toggle
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      children: [
                        _ToggleBtn(
                          icon: Icons.grid_view_rounded,
                          active: _isGrid,
                          onTap: () => setState(() => _isGrid = true),
                        ),
                        _ToggleBtn(
                          icon: Icons.view_list_rounded,
                          active: !_isGrid,
                          onTap: () => setState(() => _isGrid = false),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Clear button
                  watchlistAsync.maybeWhen(
                    data: (items) => items.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.delete_outline_rounded,
                                color: AppColors.white50),
                            onPressed: () => _confirmClear(context),
                          )
                        : const SizedBox.shrink(),
                    orElse: () => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Stats bar ────────────────────────────────────────────────
            watchlistAsync.maybeWhen(
              data: (items) {
                if (items.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          icon: Icons.movie_outlined,
                          label: 'Saved',
                          value: '${items.length}',
                        ),
                        Container(width: 1, height: 30, color: AppColors.divider),
                        _StatItem(
                          icon: Icons.star_rounded,
                          label: 'Avg. Rating',
                          value: items.isNotEmpty
                              ? (items
                                          .map((i) => i.voteAverage)
                                          .reduce((a, b) => a + b) /
                                      items.length)
                                  .toStringAsFixed(1)
                              : 'N/A',
                          valueColor: AppColors.gold,
                        ),
                        Container(width: 1, height: 30, color: AppColors.divider),
                        _StatItem(
                          icon: Icons.access_time_rounded,
                          label: 'Est. Hours',
                          value: '~${(items.length * 1.8).toStringAsFixed(0)}h',
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                );
              },
              orElse: () => const SizedBox.shrink(),
            ),

            // ── Content ──────────────────────────────────────────────────
            Expanded(
              child: watchlistAsync.when(
                data: (items) {
                  if (items.isEmpty) return _buildEmpty();
                  final movies = items.map((i) => i.toMovie()).toList();

                  if (_isGrid) {
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
                          heroTag: 'watchlist_${m.id}_$index',
                          width: double.infinity,
                          height: 215,
                        )
                            .animate(
                                delay: Duration(milliseconds: index * 40))
                            .fadeIn(duration: 350.ms)
                            .scale(
                                begin: const Offset(0.95, 0.95),
                                end: const Offset(1, 1));
                      },
                    );
                  }

                  // List view
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    physics: const BouncingScrollPhysics(),
                    itemCount: movies.length,
                    separatorBuilder: (context, index) =>
                        const Divider(color: AppColors.divider, height: 1),
                    itemBuilder: (context, index) {
                      final m = movies[index];
                      return Dismissible(
                        key: Key('watchlist_${m.id}'),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => ref
                            .read(watchlistProvider.notifier)
                            .toggleWatchlist(m),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: AppColors.deepRed,
                          child: const Icon(Icons.delete_rounded,
                              color: Colors.white),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 4),
                          leading: ClipRRect(
                            child: CachedNetworkImage(
                              imageUrl: m.posterUrl,
                              width: 54,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(m.title,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          subtitle: Row(
                            children: [
                              Text(m.year,
                                  style: const TextStyle(
                                      color: AppColors.white50, fontSize: 12)),
                              if (m.voteAverage > 0) ...[
                                const SizedBox(width: 8),
                                const Icon(Icons.star_rounded,
                                    color: AppColors.gold, size: 13),
                                const SizedBox(width: 2),
                                Text(m.displayRating,
                                    style: const TextStyle(
                                        color: AppColors.gold, fontSize: 12)),
                              ],
                            ],
                          ),
                          onTap: () => context.push('/movie/${m.id}', extra: m),
                        ),
                      )
                          .animate(
                              delay: Duration(milliseconds: index * 40))
                          .fadeIn(duration: 350.ms)
                          .slideX(begin: -0.05, end: 0);
                    },
                  );
                },
                loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.gold)),
                error: (err, _) => Center(
                  child: Text('Error: $err',
                      style: const TextStyle(color: AppColors.white50)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.divider, width: 2),
              ),
              child: const Icon(Icons.bookmark_border_rounded,
                  color: AppColors.white30, size: 44),
            ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
            const SizedBox(height: 24),
            const Text('Your list is empty',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                )).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 10),
            const Text('Save movies to watch them later.\nTap the heart on any card.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.white50, fontSize: 14, height: 1.6))
                .animate().fadeIn(delay: 300.ms),
          ],
        ),
      ),
    );
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardSurface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear List',
            style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w700)),
        content: const Text(
            'Remove all movies from your list?',
            style: TextStyle(color: AppColors.white70)),
        actions: [
          TextButton(
            onPressed: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.white50)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.deepRed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              ref.read(watchlistProvider.notifier).clearWatchlist();
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
            child: const Text('Clear All',
                style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _ToggleBtn(
      {required this.icon, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: active ? AppColors.deepRed : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon,
              color: active ? AppColors.white : AppColors.white50, size: 18),
        ),
      );
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _StatItem(
      {required this.icon,
      required this.label,
      required this.value,
      this.valueColor});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Icon(icon, color: AppColors.white50, size: 18),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                color: valueColor ?? AppColors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              )),
          Text(label,
              style: const TextStyle(
                  color: AppColors.white50, fontSize: 11)),
        ],
      );
}
