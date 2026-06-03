import 'package:docklands_dojo/data/flashcards_data.dart';
import 'package:docklands_dojo/database/daos/review_dao.dart';
import 'package:docklands_dojo/providers/review_providers.dart';
import 'package:docklands_dojo/result.dart';
import 'package:docklands_dojo/services/srs/review_service.dart';
import 'package:docklands_dojo/widgets/flashcard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The main flashcard review session screen.
///
/// Shows due cards one at a time: front (Japanese term), tap to flip
/// (English + description), then quality rating 0-5 buttons.
/// Includes a card counter and progress bar.
///
/// When all due cards are reviewed, navigates to [ReviewSummaryScreen].
/// When no cards are due, shows [EmptyReviewScreen].
class FlashcardScreen extends ConsumerStatefulWidget {
  /// Creates a [FlashcardScreen].
  const FlashcardScreen({super.key});

  @override
  ConsumerState<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends ConsumerState<FlashcardScreen> {
  List<CardReviewState> _dueCards = [];
  int _currentIndex = 0;
  bool _isFlipped = false;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  // Session tracking.
  int _cardsReviewed = 0;
  int _correctCount = 0;
  final DateTime _sessionStart = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadDueCards();
  }

  Future<void> _loadDueCards() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    final service = ref.read(reviewServiceProvider);
    final result = await service.getDueCards(DateTime.now());

    if (!mounted) return;

    switch (result) {
      case Success(:final data):
        setState(() {
          _dueCards = data;
          _isLoading = false;
        });
      case Failure(:final message):
        setState(() {
          _hasError = true;
          _errorMessage = message;
          _isLoading = false;
        });
    }
  }

  FlashCard? _findFlashCard(String cardId) {
    try {
      return allFlashCards.firstWhere((card) => card.id == cardId);
    } catch (_) {
      return null;
    }
  }

  Future<void> _rateCard(int quality) async {
    if (_currentIndex >= _dueCards.length) return;

    final currentCard = _dueCards[_currentIndex];
    final service = ref.read(reviewServiceProvider);

    await service.reviewCard(
      cardId: currentCard.cardId,
      quality: quality,
      now: DateTime.now(),
    );

    setState(() {
      _cardsReviewed++;
      if (quality >= 3) _correctCount++;

      if (_currentIndex + 1 < _dueCards.length) {
        _currentIndex++;
        _isFlipped = false;
      } else {
        // Session complete — navigate to summary.
        _navigateToSummary();
      }
    });

    // Invalidate providers so other screens see updated data.
    ref.invalidate(dueCardsProvider);
    ref.invalidate(reviewStatsProvider);
  }

  void _navigateToSummary() {
    final duration = DateTime.now().difference(_sessionStart);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => ReviewSummaryScreen(
          cardsReviewed: _cardsReviewed,
          correctCount: _correctCount,
          duration: duration,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Review')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Review')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(_errorMessage),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadDueCards,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_dueCards.isEmpty) {
      return const EmptyReviewScreen();
    }

    return _buildReviewSession(context);
  }

  Widget _buildReviewSession(BuildContext context) {
    final theme = Theme.of(context);
    final currentCard = _dueCards[_currentIndex];
    final flashCard = _findFlashCard(currentCard.cardId);
    final progress = (_currentIndex + 1) / _dueCards.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Review (${_currentIndex + 1}/${_dueCards.length})'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            if (_cardsReviewed > 0) {
              _navigateToSummary();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar.
            LinearProgressIndicator(
              value: progress,
              backgroundColor:
                  theme.colorScheme.surfaceContainerHighest,
              color: theme.colorScheme.primary,
              minHeight: 4,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Flashcard.
                    Expanded(
                      child: FlashcardWidget(
                        front: Text(
                          flashCard?.front ?? currentCard.cardId,
                          style: theme.textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        back: Text(
                          flashCard?.back ?? 'Unknown card',
                          style: theme.textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        isFlipped: _isFlipped,
                        onFlip: () {
                          setState(() {
                            _isFlipped = !_isFlipped;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Quality rating buttons (only visible when flipped).
                    if (_isFlipped)
                      _buildQualityButtons(theme)
                    else
                      Text(
                        'Tap the card to reveal the answer',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityButtons(ThemeData theme) {
    return Column(
      children: [
        Text(
          'How well did you know this?',
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            _qualityButton(
              quality: 0,
              label: '0',
              subtitle: 'Blackout',
              color: Colors.red.shade700,
            ),
            _qualityButton(
              quality: 1,
              label: '1',
              subtitle: 'Wrong',
              color: Colors.red.shade400,
            ),
            _qualityButton(
              quality: 2,
              label: '2',
              subtitle: 'Hard',
              color: Colors.orange,
            ),
            _qualityButton(
              quality: 3,
              label: '3',
              subtitle: 'OK',
              color: Colors.amber,
            ),
            _qualityButton(
              quality: 4,
              label: '4',
              subtitle: 'Good',
              color: Colors.lightGreen,
            ),
            _qualityButton(
              quality: 5,
              label: '5',
              subtitle: 'Easy',
              color: Colors.green,
            ),
          ],
        ),
      ],
    );
  }

  Widget _qualityButton({
    required int quality,
    required String label,
    required String subtitle,
    required Color color,
  }) {
    return SizedBox(
      width: 56,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => _rateCard(quality),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              minimumSize: const Size(48, 48),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Screen shown after completing a review session.
///
/// Displays: cards reviewed, correct count, retention rate,
/// and a motivational message.
class ReviewSummaryScreen extends StatelessWidget {
  /// Number of cards reviewed in this session.
  final int cardsReviewed;

  /// Number of cards answered correctly (quality ≥ 3).
  final int correctCount;

  /// Duration of the review session.
  final Duration duration;

  /// Creates a [ReviewSummaryScreen].
  const ReviewSummaryScreen({
    required this.cardsReviewed,
    required this.correctCount,
    required this.duration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final retentionRate =
        cardsReviewed > 0 ? (correctCount / cardsReviewed * 100) : 0.0;
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Complete'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Celebration icon.
                Icon(
                  retentionRate >= 80
                      ? Icons.celebration
                      : retentionRate >= 50
                          ? Icons.thumb_up
                          : Icons.school,
                  size: 64,
                  color: retentionRate >= 80
                      ? Colors.amber
                      : retentionRate >= 50
                          ? Colors.green
                          : theme.colorScheme.primary,
                ),
                const SizedBox(height: 24),

                Text(
                  retentionRate >= 80
                      ? 'Excellent work! 🔥'
                      : retentionRate >= 50
                          ? 'Good effort! 💪'
                          : 'Keep training! 🥋',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),

                // Stats cards.
                _statRow(
                  context,
                  icon: Icons.style,
                  label: 'Cards Reviewed',
                  value: '$cardsReviewed',
                ),
                const SizedBox(height: 12),
                _statRow(
                  context,
                  icon: Icons.check_circle,
                  label: 'Correct',
                  value: '$correctCount / $cardsReviewed',
                ),
                const SizedBox(height: 12),
                _statRow(
                  context,
                  icon: Icons.pie_chart,
                  label: 'Retention Rate',
                  value: '${retentionRate.toStringAsFixed(0)}%',
                ),
                const SizedBox(height: 12),
                _statRow(
                  context,
                  icon: Icons.timer,
                  label: 'Duration',
                  value: '${minutes}m ${seconds}s',
                ),

                const SizedBox(height: 48),

                FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Done'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: theme.textTheme.bodyLarge),
            ),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Screen shown when there are no cards due for review.
///
/// Displays an 'All caught up! 🎉' message with encouragement.
class EmptyReviewScreen extends StatelessWidget {
  /// Creates an [EmptyReviewScreen].
  const EmptyReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Review')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🎉',
                style: TextStyle(fontSize: 64),
              ),
              const SizedBox(height: 24),
              Text(
                'All caught up!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'No cards are due for review right now.\n'
                'Come back later to keep your streak going!',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
