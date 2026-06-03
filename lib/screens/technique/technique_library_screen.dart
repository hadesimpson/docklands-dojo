import 'package:docklands_dojo/models/belt_rank.dart';
import 'package:docklands_dojo/models/technique.dart';
import 'package:docklands_dojo/screens/technique/kata_detail_screen.dart';
import 'package:docklands_dojo/screens/technique/technique_detail_screen.dart';
import 'package:docklands_dojo/services/search_service.dart';
import 'package:flutter/material.dart';

/// Main technique library screen with search, filter, and browsing.
///
/// Features:
/// - Search bar at top with fuzzy search across japaneseName, englishName,
///   romajiName
/// - Filter chips for all 9 [TechniqueCategory] values
/// - Optional belt rank filter
/// - Technique cards in a [ListView] showing category icon, japaneseName,
///   and englishName
/// - Tap to navigate to [TechniqueDetailScreen]
/// - Separate tab for kata browsing
///
/// See PRD Section 3, F2: Technique Library.
class TechniqueLibraryScreen extends StatefulWidget {
  /// Creates a [TechniqueLibraryScreen].
  const TechniqueLibraryScreen({super.key});

  @override
  State<TechniqueLibraryScreen> createState() => _TechniqueLibraryScreenState();
}

class _TechniqueLibraryScreenState extends State<TechniqueLibraryScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _searchService = const SearchService();

  late final TabController _tabController;

  TechniqueCategory? _selectedCategory;
  BeltRank? _selectedBeltRank;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Technique Library'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Techniques'),
            Tab(text: 'Kata'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar.
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search techniques...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _searchController.clear,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Tabs content.
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildTechniquesTab(theme), _buildKataTab(theme)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechniquesTab(ThemeData theme) {
    return Column(
      children: [
        // Category filter chips.
        _CategoryFilterChips(
          selectedCategory: _selectedCategory,
          onCategorySelected: (category) {
            setState(() {
              _selectedCategory = _selectedCategory == category
                  ? null
                  : category;
            });
          },
        ),

        // Belt rank filter.
        if (_selectedBeltRank != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Chip(
              label: Text('Belt: ${_selectedBeltRank!.displayName}'),
              onDeleted: () {
                setState(() {
                  _selectedBeltRank = null;
                });
              },
            ),
          ),

        // Technique list.
        Expanded(child: _buildTechniqueList(theme)),
      ],
    );
  }

  Widget _buildTechniqueList(ThemeData theme) {
    final techniques = _searchService.searchTechniques(
      _searchQuery,
      category: _selectedCategory,
      beltRank: _selectedBeltRank,
    );

    if (techniques.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.38),
            ),
            const SizedBox(height: 16),
            Text(
              'No techniques found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            if (_searchQuery.isNotEmpty || _selectedCategory != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TextButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _selectedCategory = null;
                      _selectedBeltRank = null;
                    });
                  },
                  child: const Text('Clear filters'),
                ),
              ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: techniques.length,
      itemBuilder: (context, index) {
        final technique = techniques[index];
        return TechniqueCard(
          technique: technique,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => TechniqueDetailScreen(technique: technique),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildKataTab(ThemeData theme) {
    final kata = _searchService.searchKata(_searchQuery);

    if (kata.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.38),
            ),
            const SizedBox(height: 16),
            Text(
              'No kata found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: kata.length,
      itemBuilder: (context, index) {
        final k = kata[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.secondary.withValues(
                alpha: 0.12,
              ),
              child: Icon(
                Icons.self_improvement,
                color: theme.colorScheme.secondary,
              ),
            ),
            title: Text(k.englishName),
            subtitle: Text('${k.japaneseName} · ${k.moveCount} moves'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => KataDetailScreen(kata: k),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// ── Category Filter Chips ──────────────────────────────────────────────────

/// Horizontal scrollable category filter chips for the 9 technique categories.
class _CategoryFilterChips extends StatelessWidget {
  final TechniqueCategory? selectedCategory;
  final ValueChanged<TechniqueCategory> onCategorySelected;

  const _CategoryFilterChips({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: TechniqueCategory.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = TechniqueCategory.values[index];
          final isSelected = selectedCategory == category;

          return FilterChip(
            label: Text(categoryDisplayName(category)),
            selected: isSelected,
            onSelected: (_) => onCategorySelected(category),
            avatar: Icon(categoryIcon(category), size: 18),
          );
        },
      ),
    );
  }
}

// ── Technique Card ─────────────────────────────────────────────────────────

/// A card displaying a technique's category icon, Japanese name, and English
/// name.
///
/// Used in the technique list in [TechniqueLibraryScreen].
class TechniqueCard extends StatelessWidget {
  /// The technique to display.
  final Technique technique;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  /// Creates a [TechniqueCard].
  const TechniqueCard({required this.technique, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
          child: Icon(
            categoryIcon(technique.category),
            color: theme.colorScheme.primary,
          ),
        ),
        title: Text(technique.romajiName),
        subtitle: Text(
          '${technique.japaneseName} · ${technique.englishName}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

// ── Category Helpers ───────────────────────────────────────────────────────

/// Returns the display name for a [TechniqueCategory].
String categoryDisplayName(TechniqueCategory category) => switch (category) {
  TechniqueCategory.dachi => 'Stances',
  TechniqueCategory.tsuki => 'Punches',
  TechniqueCategory.geri => 'Kicks',
  TechniqueCategory.uke => 'Blocks',
  TechniqueCategory.uchi => 'Strikes',
  TechniqueCategory.hiji => 'Elbow',
  TechniqueCategory.hiza => 'Knee',
  TechniqueCategory.kata => 'Kata',
  TechniqueCategory.tameshiwari => 'Breaking',
};

/// Returns the icon for a [TechniqueCategory].
IconData categoryIcon(TechniqueCategory category) => switch (category) {
  TechniqueCategory.dachi => Icons.accessibility_new,
  TechniqueCategory.tsuki => Icons.front_hand,
  TechniqueCategory.geri => Icons.directions_walk,
  TechniqueCategory.uke => Icons.shield,
  TechniqueCategory.uchi => Icons.swipe,
  TechniqueCategory.hiji => Icons.sports_martial_arts,
  TechniqueCategory.hiza => Icons.airline_seat_legroom_extra,
  TechniqueCategory.kata => Icons.self_improvement,
  TechniqueCategory.tameshiwari => Icons.broken_image,
};
