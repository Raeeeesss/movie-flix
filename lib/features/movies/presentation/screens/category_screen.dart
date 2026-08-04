import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_theme.dart';
import '../../models/movie.dart';
import '../../providers/movie_providers.dart';
import '../../repositories/movie_repository.dart';
import '../../../user/providers/user_preferences_provider.dart';
import '../widgets/movie_card.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  final String categoryKey;
  final String categoryTitle;

  const CategoryScreen({
    super.key,
    required this.categoryKey,
    required this.categoryTitle,
  });

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<Movie> _movies = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String _error = '';
  bool _isGridView = true;
  String _filterQuery = '';

  @override
  void initState() {
    super.initState();
    _loadPage(_currentPage);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted || _isLoading || !_hasMore) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _loadMore();
    }
  }

  Future<void> _loadPage(int page) async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final repo = ref.read(movieRepositoryProvider);
      final prefs = ref.read(userPreferencesProvider);
      final newMovies = await _fetchForCategory(repo, prefs, widget.categoryKey, page);

      if (mounted) {
        setState(() {
          if (page == 1) {
            _movies = newMovies;
          } else {
            final existingIds = _movies.map((m) => m.id).toSet();
            final unique = newMovies.where((m) => !existingIds.contains(m.id)).toList();
            _movies.addAll(unique);
          }
          _currentPage = page;
          _isLoading = false;
          _hasMore = newMovies.isNotEmpty && page < 10;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<List<Movie>> _fetchForCategory(
      MovieRepository repo, dynamic prefs, String key, int page) async {
    final topActor = prefs.favoriteActors.isNotEmpty ? prefs.favoriteActors.first : 'Mohanlal';
    final topActress = prefs.favoriteActresses.isNotEmpty ? prefs.favoriteActresses.first : 'Sai Pallavi';
    final topDirector = prefs.favoriteDirectors.isNotEmpty ? prefs.favoriteDirectors.first : 'Lijo Jose Pellissery';
    final mainLang = prefs.preferredLanguages.isNotEmpty ? prefs.preferredLanguages.first : 'Malayalam';
    final topGenre = prefs.favoriteGenres.isNotEmpty ? prefs.favoriteGenres.first : 'Action';

    switch (key.toLowerCase()) {
      case 'airecs':
        return repo.fetchCategory('$mainLang Top Movies', page: page);
      case 'because_actor':
        return repo.fetchCategory(topActor, page: page);
      case 'actress':
        return repo.fetchCategory(topActress, page: page);
      case 'director':
        return repo.fetchCategory(topDirector, page: page);
      case 'genre_lang':
        return repo.fetchCategory('$mainLang $topGenre', page: page);
      case 'poplang':
        return repo.fetchCategory(mainLang, page: page);
      case 'trending':
        return repo.getTrendingMovies(page: page);
      case 'trendingwk':
        return repo.getTrendingWeekMovies(page: page);
      case 'popular':
        return repo.getPopularMovies(page: page);
      case 'toprated':
        return repo.getTopRatedMovies(page: page);
      case 'now_playing':
      case 'nowplaying':
        return repo.getNowPlayingMovies(page: page);
      case 'upcoming':
        return repo.getUpcomingMovies(page: page);
      case 'action':
        return repo.getActionMovies(page: page);
      case 'comedy':
        return repo.getComedyMovies(page: page);
      case 'horror':
        return repo.getHorrorMovies(page: page);
      case 'scifi':
        return repo.getScifiMovies(page: page);
      case 'drama':
        return repo.getDramaMovies(page: page);
      case 'animation':
        return repo.getAnimationMovies(page: page);
      case 'thriller':
        return repo.getThrillerMovies(page: page);
      case 'awards':
        return repo.getAwardWinners(page: page);
      case 'classics':
        return repo.getClassicMovies(page: page);
      case 'bollywood':
        return repo.getBollywoodMovies(page: page);
      case 'south':
        return repo.getSouthMovies(page: page);
      case 'anime':
        return repo.getAnimeMovies(page: page);
      case 'korean':
        return repo.getKoreanMovies(page: page);
      case 'intl':
        return repo.getInternationalMovies(page: page);
      default:
        return repo.fetchCategory(widget.categoryKey, page: page);
    }
  }

  Future<void> _loadMore() async {
    if (_hasMore && !_isLoading) {
      await _loadPage(_currentPage + 1);
    }
  }

  Future<void> _onRefresh() async {
    _currentPage = 1;
    _hasMore = true;
    await _loadPage(1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredMovies = _filterQuery.isEmpty
        ? _movies
        : _movies
            .where((m) => m.title.toLowerCase().contains(_filterQuery.toLowerCase()))
            .toList();

    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.categoryTitle,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 18,
                letterSpacing: -0.2,
              ),
            ),
            if (_movies.isNotEmpty)
              Text(
                '${_movies.length}+ Titles Available',
                style: const TextStyle(
                  color: AppColors.primaryAccent,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
              color: AppColors.gold,
            ),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primaryAccent,
        backgroundColor: AppColors.cardBg,
        onRefresh: _onRefresh,
        child: Column(
          children: [
            // Search filter bar within category
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                onChanged: (val) => setState(() => _filterQuery = val.trim()),
                decoration: InputDecoration(
                  hintText: 'Filter in ${widget.categoryTitle}...',
                  hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
                  suffixIcon: _filterQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, color: AppColors.textSecondary, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _filterQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.cardBg,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                ),
              ),
            ),

            // Category Movie View
            Expanded(
              child: _error.isNotEmpty && _movies.isEmpty
                  ? _buildErrorView()
                  : filteredMovies.isEmpty && !_isLoading
                      ? const Center(
                          child: Text(
                            'No titles match your search',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        )
                      : _isGridView
                          ? _buildGridView(filteredMovies)
                          : _buildListView(filteredMovies),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(List<Movie> movies) {
    return GridView.builder(
      key: PageStorageKey('category_grid_${widget.categoryKey}'),
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.52,
        crossAxisSpacing: 14,
        mainAxisSpacing: 18,
      ),
      itemCount: movies.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == movies.length) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryAccent),
          );
        }
        final m = movies[index];
        return MovieCard(
          movie: m,
          heroTag: 'cat_grid_${widget.categoryKey}_${m.id}_$index',
          width: double.infinity,
          height: 215,
        );
      },
    );
  }

  Widget _buildListView(List<Movie> movies) {
    return ListView.builder(
      key: PageStorageKey('category_list_${widget.categoryKey}'),
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      itemCount: movies.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == movies.length) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator(color: AppColors.primaryAccent)),
          );
        }
        final m = movies[index];
        return _CategoryListTile(movie: m, tagPrefix: widget.categoryKey, index: index);
      },
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.primaryAccent, size: 48),
          const SizedBox(height: 12),
          Text(
            'Failed to load ${widget.categoryTitle}',
            style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryAccent),
            onPressed: () => _loadPage(1),
            child: const Text('Retry', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }
}

class _CategoryListTile extends StatelessWidget {
  final Movie movie;
  final String tagPrefix;
  final int index;

  const _CategoryListTile({
    required this.movie,
    required this.tagPrefix,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final ratingStr = movie.formattedRating;

    return GestureDetector(
      onTap: () => context.push('/movie/${movie.id}', extra: movie),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: movie.posterUrl,
                width: 75,
                height: 108,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: AppColors.cardBg),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.cardBg,
                  child: const Icon(Icons.movie_outlined, color: AppColors.textSecondary),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (ratingStr != null) ...[
                        const Icon(Icons.star_rounded, color: AppColors.gold, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          ratingStr,
                          style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Text(
                        movie.year,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    movie.overview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
