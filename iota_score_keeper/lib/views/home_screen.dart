import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/history_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/game_provider.dart';
import 'new_game_screen.dart';
import 'game_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('IOTA Score Keeper'),
        actions: [
          IconButton(
            icon: Icon(ref.watch(themeProvider) == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
        ],
      ),
      body: games.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.casino_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No games yet. Start a new one!', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return Dismissible(
                  key: Key(game.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    ref.read(historyProvider.notifier).deleteGame(game.id);
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      title: Text(DateFormat.yMMMd().add_jm().format(game.date)),
                      subtitle: Text('${game.players.length} Players - ${game.isFinished ? "Finished" : "In Progress"}'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        ref.read(gameProvider.notifier).resumeGame(game);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const GameScreen()),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewGameScreen()),
          );
        },
        label: const Text('New Game'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
