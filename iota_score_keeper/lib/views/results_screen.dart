import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/game_provider.dart';

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);

    if (game == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Results')),
        body: const Center(child: Text('No game results available.')),
      );
    }

    // Sort players by score descending
    final sortedPlayers = List.of(game.players)
      ..sort((a, b) => b.totalScore.compareTo(a.totalScore));

    final winner = sortedPlayers.isNotEmpty ? sortedPlayers.first : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Results'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 32),
          if (winner != null) ...[
            const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              'Winner: ${winner.name}!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Score: ${winner.totalScore}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
          const SizedBox(height: 32),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: sortedPlayers.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final player = sortedPlayers[index];
                final rank = index + 1;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: rank == 1 ? Colors.amber : Colors.grey[300],
                    foregroundColor: Colors.black,
                    child: Text('$rank'),
                  ),
                  title: Text(player.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Max: ${player.scores.isEmpty ? 0 : player.scores.reduce((a, b) => a > b ? a : b)} | Avg: ${(player.scores.isEmpty ? 0 : player.totalScore / player.scores.length).toStringAsFixed(1)}"),
                  trailing: Text(
                    '${player.totalScore}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  ref.read(gameProvider.notifier).clearGame();
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Back to Home'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
