import 'package:go_router/go_router.dart';
import '../provider/auth_provider.dart';
import '../ui/auth/detail_screen.dart';
import '../ui/auth/login_screen.dart';
import '../ui/auth/register_screen.dart';
import '../ui/home/home_screen.dart';
import '../ui/home/add_story_screen.dart';
import '../data/model/story.dart';
import '../ui/home/pick_location_screen.dart';

class AppRouter {
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: authProvider,
      redirect: (context, state) {
        if (!authProvider.isInitialized) {
          return null;
        }

        final isLoggedIn = authProvider.isLoggedIn;
        final isGoingToLogin = state.matchedLocation == '/login';
        final isGoingToRegister = state.matchedLocation == '/register';

        if (!isLoggedIn && !isGoingToLogin && !isGoingToRegister) {
          return '/login';
        }
        if (isLoggedIn && (isGoingToLogin || isGoingToRegister)) {
          return '/';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
          routes: [
            GoRoute(
              path: 'add_story',
              name: 'add_story',
              builder: (context, state) => const AddStoryScreen(),
            ),
            GoRoute(
              path: 'detail',
              name: 'detail',
              builder: (context, state) {
                final story = state.extra as Story;
                return DetailScreen(story: story);
              },
            ),
            GoRoute(
              path: '/pick_location',
              builder: (context, state) => const PickLocationScreen(),
            ),
          ],
        ),
      ],
    );
  }
}
