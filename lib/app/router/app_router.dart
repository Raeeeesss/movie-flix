import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/movies/models/movie.dart';
import '../../features/movies/presentation/screens/splash_screen.dart';
import '../../features/movies/presentation/screens/home_screen.dart';
import '../../features/movies/presentation/screens/search_screen.dart';
import '../../features/movies/presentation/screens/details_screen.dart';
import '../../features/movies/presentation/screens/category_screen.dart';
import '../../features/movies/presentation/screens/full_movie_player_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/watchlist/presentation/screens/watchlist_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../app/theme/app_theme.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    // Main shell with NavigationBar / NavigationRail
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return _MainShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: '/search',
              builder: (context, state) => const SearchScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: '/watchlist',
              builder: (context, state) => const WatchlistScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen()),
        ]),
      ],
    ),

    // Settings Screen
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const SettingsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            );
          },
        );
      },
    ),

    // Movie Details
    GoRoute(
      path: '/movie/:id',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final movieIdStr = state.pathParameters['id'] ?? '0';
        final movieId = int.tryParse(movieIdStr) ?? 0;
        final extraMovie = state.extra as Movie?;
        return CustomTransitionPage(
          key: state.pageKey,
          child: DetailsScreen(movieId: movieId, initialMovie: extraMovie),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                  parent: animation, curve: Curves.easeIn),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
      },
    ),

    // Category List Page
    GoRoute(
      path: '/category/:key',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final key = state.pathParameters['key'] ?? '';
        final title = state.uri.queryParameters['title'] ?? 'Movies';
        return CustomTransitionPage(
          key: state.pageKey,
          child: CategoryScreen(categoryKey: key, categoryTitle: title),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 250),
        );
      },
    ),

    // Full Movie Player Screen (Internet Archive & Public Domain Streams)
    GoRoute(
      path: '/watch/:id',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final movieIdStr = state.pathParameters['id'] ?? '0';
        final movieId = int.tryParse(movieIdStr) ?? 0;
        final movie = state.extra as Movie? ??
            Movie(
              id: movieId,
              title: 'Full Movie Stream',
              overview: 'Internet Archive Public Domain Stream',
              voteAverage: 8.5,
              releaseDate: '2024-01-01',
              streamUrl: 'https://archive.org/download/his_girl_friday/his_girl_friday.mp4',
            );
        return CustomTransitionPage(
          key: state.pageKey,
          child: FullMoviePlayerScreen(movie: movie),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
      },
    ),
  ],
);

// Responsive Main Shell
class _MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const _MainShell({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 600;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (navigationShell.currentIndex != 0) {
          navigationShell.goBranch(0);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryBg,
        body: isWide
            ? Row(
                children: [
                  NavigationRail(
                    backgroundColor: const Color(0xFF0D0D0D),
                    selectedIndex: navigationShell.currentIndex,
                    onDestinationSelected: (index) {
                      navigationShell.goBranch(
                        index,
                        initialLocation: index == navigationShell.currentIndex,
                      );
                    },
                    labelType: NavigationRailLabelType.all,
                    selectedIconTheme: const IconThemeData(color: AppColors.primaryAccent),
                    selectedLabelTextStyle: const TextStyle(color: AppColors.primaryAccent, fontWeight: FontWeight.w700),
                    unselectedIconTheme: const IconThemeData(color: Color(0xFF888888)),
                    unselectedLabelTextStyle: const TextStyle(color: Color(0xFF888888)),
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home_outlined),
                        selectedIcon: Icon(Icons.home_rounded),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.search_outlined),
                        selectedIcon: Icon(Icons.search_rounded),
                        label: Text('Search'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.bookmark_border_rounded),
                        selectedIcon: Icon(Icons.bookmark_rounded),
                        label: Text('My List'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.person_outline_rounded),
                        selectedIcon: Icon(Icons.person_rounded),
                        label: Text('Profile'),
                      ),
                    ],
                  ),
                  const VerticalDivider(thickness: 1, width: 1, color: AppColors.divider),
                  Expanded(child: navigationShell),
                ],
              )
            : navigationShell,
        bottomNavigationBar: isWide
            ? null
            : Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0D0D0D),
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withValues(alpha: 0.10),
                      width: 1,
                    ),
                  ),
                ),
                child: NavigationBar(
                  backgroundColor: Colors.transparent,
                  indicatorColor: AppColors.primaryAccent.withValues(alpha: 0.18),
                  elevation: 0,
                  height: 64,
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: (index) {
                    navigationShell.goBranch(
                      index,
                      initialLocation: index == navigationShell.currentIndex,
                    );
                  },
                  destinations: [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined,
                          color: navigationShell.currentIndex == 0
                              ? AppColors.primaryAccent
                              : const Color(0xFF888888)),
                      selectedIcon: const Icon(Icons.home_rounded,
                          color: AppColors.primaryAccent),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.search_outlined,
                          color: navigationShell.currentIndex == 1
                              ? AppColors.primaryAccent
                              : const Color(0xFF888888)),
                      selectedIcon: const Icon(Icons.search_rounded,
                          color: AppColors.primaryAccent),
                      label: 'Search',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.bookmark_border_rounded,
                          color: navigationShell.currentIndex == 2
                              ? AppColors.primaryAccent
                              : const Color(0xFF888888)),
                      selectedIcon: const Icon(Icons.bookmark_rounded,
                          color: AppColors.primaryAccent),
                      label: 'My List',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline_rounded,
                          color: navigationShell.currentIndex == 3
                              ? AppColors.primaryAccent
                              : const Color(0xFF888888)),
                      selectedIcon: const Icon(Icons.person_rounded,
                          color: AppColors.primaryAccent),
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
