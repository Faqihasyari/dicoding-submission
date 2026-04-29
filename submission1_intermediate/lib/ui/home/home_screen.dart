import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../provider/auth_provider.dart';
import '../../provider/localization_provider.dart';
import '../../provider/story_provider.dart';
import '../widget/home_state_widget.dart';
import '../widget/story_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.titleApp),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: AppLocalizations.of(context)!.changeLanguage,
            icon: const Icon(Icons.language_outlined),
            onPressed: () {
              // Logika: Kalau sekarang 'id', ubah ke 'en'. Kalau 'en', ubah ke 'id'.
              final provider = context.read<LocalizationProvider>();
              if (provider.locale.languageCode == 'id') {
                provider.setLocale(const Locale('en'));
              } else {
                provider.setLocale(const Locale('id'));
              }
            },
          ),
          IconButton(
            tooltip: AppLocalizations.of(context)!.searchStory,
            icon: const Icon(Icons.search_outlined),
            onPressed: () {},
          ),
          IconButton(
            tooltip: AppLocalizations.of(context)!.logout,
            icon: const Icon(Icons.logout_outlined),
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add_story'),
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.newStory),
      ),
      body: Consumer<StoryProvider>(
        builder: (context, provider, _) {
      return switch (provider.state) {
        ResultState.loading => const LoadingStateWidget(),
        ResultState.noData => EmptyStateWidget(
          message: AppLocalizations.of(context)!.emptyData, // Paksa menggunakan terjemahan
        ),
        ResultState.error => ErrorStateWidget(
          message: AppLocalizations.of(context)!.errorLoadStory, // Paksa menggunakan terjemahan
          onRetry: () => provider.fetchAllStories(refresh: true),
        ),
        _ => _StoryList(provider: provider),
      };
    },
    ),

// ... sisa kode di bawahnya ...
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.logoutConfirmTitle),
        content: Text(AppLocalizations.of(context)!.logoutConfirmDesc),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          FilledButton(
            onPressed: () => context.pop(true),
            child: Text(AppLocalizations.of(context)!.logout),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<AuthProvider>().logout();
    }
  }
}

class _StoryList extends StatefulWidget {
  const _StoryList({required this.provider});

  final StoryProvider provider;

  @override
  State<_StoryList> createState() => _StoryListState();
}

class _StoryListState extends State<_StoryList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
        if (widget.provider.hasMore && !widget.provider.isFetchingMore) {
          context.read<StoryProvider>().fetchAllStories();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stories = widget.provider.storiesList;

    return RefreshIndicator(
      onRefresh: () => widget.provider.fetchAllStories(refresh: true),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 8, bottom: 88),
        itemCount: stories.length + (widget.provider.isFetchingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == stories.length && widget.provider.isFetchingMore) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final story = stories[index];
          return StoryCard(
            story: story,
            onTap: () => context.push('/detail', extra: story),
          );
        },
      ),
    );
  }
}