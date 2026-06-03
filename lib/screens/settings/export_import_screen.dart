import 'dart:io';

import 'package:docklands_dojo/database/app_database.dart';
import 'package:docklands_dojo/result.dart';
import 'package:docklands_dojo/services/export_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

/// Screen for exporting and importing user data.
///
/// Provides two primary actions:
/// - **Export Data**: Serializes all user data to JSON and opens the
///   system share sheet via [ExportService.shareExport].
/// - **Import Data**: Opens a file picker for `.json` files, confirms
///   with the user, then performs a full data replacement via
///   [ExportService.importData].
///
/// Displays a progress indicator during operations and shows
/// success/failure feedback via snackbars.
class ExportImportScreen extends StatefulWidget {
  /// The Drift database instance used for export/import operations.
  final AppDatabase database;

  /// Creates an [ExportImportScreen].
  const ExportImportScreen({super.key, required this.database});

  @override
  State<ExportImportScreen> createState() => _ExportImportScreenState();
}

class _ExportImportScreenState extends State<ExportImportScreen> {
  bool _isExporting = false;
  bool _isImporting = false;
  DateTime? _lastExportDate;

  ExportService get _exportService => ExportService(widget.database);

  Future<void> _handleExport() async {
    setState(() => _isExporting = true);

    final result = await _exportService.shareExport();

    if (!mounted) return;
    setState(() {
      _isExporting = false;
      if (result is Success) {
        _lastExportDate = DateTime.now();
      }
    });

    switch (result) {
      case Success():
        _showSnackBar('Data exported successfully', isError: false);
      case Failure(:final message):
        _showSnackBar('Export failed: $message', isError: true);
    }
  }

  Future<void> _handleImport() async {
    // Pick a JSON file.
    final pickResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (pickResult == null || pickResult.files.isEmpty) return;
    if (!mounted) return;

    final filePath = pickResult.files.single.path;
    if (filePath == null) {
      _showSnackBar('Could not read selected file', isError: true);
      return;
    }

    // Confirm import with the user.
    final confirmed = await _showImportConfirmation();
    if (confirmed != true) return;

    setState(() => _isImporting = true);

    try {
      final jsonString = await File(filePath).readAsString();
      final result = await _exportService.importData(jsonString);

      if (!mounted) return;
      setState(() => _isImporting = false);

      switch (result) {
        case Success(:final data):
          final msg = StringBuffer('Import successful! ');
          if (data.progressRestored) msg.write('Progress restored. ');
          msg.write(
            '${data.advancementsCount} advancements, '
            '${data.sessionsCount} sessions, '
            '${data.cardStatesCount} cards, '
            '${data.quizAttemptsCount} quizzes imported.',
          );
          if (data.warnings.isNotEmpty) {
            msg.write(' (${data.warnings.length} warnings)');
          }
          _showSnackBar(msg.toString(), isError: false);
        case Failure(:final message):
          _showSnackBar('Import failed: $message', isError: true);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isImporting = false);
      _showSnackBar('Import failed: $e', isError: true);
    }
  }

  Future<bool?> _showImportConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Data'),
        content: const Text(
          'This will replace all existing data with the imported data. '
          'This action cannot be undone.\n\n'
          'Are you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Replace All Data'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, {required bool isError}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isProcessing = _isExporting || _isImporting;

    return Scaffold(
      appBar: AppBar(title: const Text('Export & Import')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header card with explanation.
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.sync_alt, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Data Portability',
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Export your progress to transfer to another device, '
                      'or import a previous backup.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Export button.
            FilledButton.icon(
              onPressed: isProcessing ? null : _handleExport,
              icon: _isExporting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.upload),
              label: Text(_isExporting ? 'Exporting...' : 'Export Data'),
            ),

            if (_lastExportDate != null) ...[
              const SizedBox(height: 8),
              Text(
                'Last export: ${_formatDate(_lastExportDate!)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            const SizedBox(height: 16),

            // Import button.
            OutlinedButton.icon(
              onPressed: isProcessing ? null : _handleImport,
              icon: _isImporting
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.primary,
                      ),
                    )
                  : const Icon(Icons.download),
              label: Text(_isImporting ? 'Importing...' : 'Import Data'),
            ),

            const SizedBox(height: 24),

            // Warning card.
            Card(
              color: theme.colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: theme.colorScheme.onErrorContainer,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Importing data will replace all existing progress. '
                        'Consider exporting your current data first.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final d = date.toLocal();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')} '
        '${d.hour.toString().padLeft(2, '0')}:'
        '${d.minute.toString().padLeft(2, '0')}';
  }
}
