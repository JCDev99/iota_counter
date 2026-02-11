import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/game_provider.dart';
import '../models/player.dart';
import 'results_screen.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);

    if (game == null) {
      return const Scaffold(body: Center(child: Text("No active game")));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game in Progress'),
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Finish Game?"),
                  content: const Text("This will finalize the game and show results."),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                    TextButton(
                      onPressed: () {
                        ref.read(gameProvider.notifier).finishGame();
                        Navigator.pop(context); // Close dialog
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const ResultsScreen()),
                        );
                      },
                      child: const Text("Finish"),
                    ),
                  ],
                ),
              );
            },
            child: const Text("Finish", style: TextStyle(color: Colors.white)), // Assuming primary color background
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: game.players.length,
        itemBuilder: (context, index) {
          final player = game.players[index];
          return PlayerCard(player: player);
        },
      ),
    );
  }
}

class PlayerCard extends ConsumerWidget {
  final Player player;
  const PlayerCard({super.key, required this.player});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(
              child: Text(player.name, style: Theme.of(context).textTheme.titleLarge),
            ),
            Text(
              '${player.totalScore}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 16),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle, size: 32, color: Colors.blue),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => ScoreDialog(
                onSave: (score) {
                  ref.read(gameProvider.notifier).addScore(player.id, score);
                },
              ),
            );
          },
        ),
        children: [
          if (player.scores.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Max: ${player.scores.reduce((a, b) => a > b ? a : b)}"),
                  Text("Avg: ${player.scores.isEmpty ? 0 : (player.totalScore / player.scores.length).toStringAsFixed(1)}"),
                  Text("Rounds: ${player.scores.length}"),
                ],
              ),
            ),
          const Divider(),
          if (player.scores.isEmpty)
             const ListTile(title: Text("No scores yet")),
          ...player.scores.asMap().entries.map((entry) {
            final index = entry.key;
            final score = entry.value;
            return ListTile(
              title: Text('Round ${index + 1}'),
              trailing: Text('$score', style: const TextStyle(fontSize: 18)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => ScoreDialog(
                    initialScore: score,
                    onSave: (newScore) {
                      ref.read(gameProvider.notifier).updateScore(player.id, index, newScore);
                    },
                    onDelete: () {
                       ref.read(gameProvider.notifier).deleteScore(player.id, index);
                       Navigator.pop(context); // Close dialog
                    },
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}

class ScoreDialog extends StatefulWidget {
  final int? initialScore;
  final Function(int) onSave;
  final VoidCallback? onDelete;

  const ScoreDialog({super.key, this.initialScore, required this.onSave, this.onDelete});

  @override
  State<ScoreDialog> createState() => _ScoreDialogState();
}

class _ScoreDialogState extends State<ScoreDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialScore?.toString() ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialScore == null ? 'Add Score' : 'Edit Score'),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        autofocus: true,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(hintText: 'Enter score'),
        onSubmitted: (value) {
            final score = int.tryParse(value);
            if (score != null) {
              widget.onSave(score);
              Navigator.pop(context);
            }
        },
      ),
      actions: [
        if (widget.onDelete != null)
          TextButton(
            onPressed: widget.onDelete,
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(
          onPressed: () {
            final score = int.tryParse(_controller.text);
            if (score != null) {
              widget.onSave(score);
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
