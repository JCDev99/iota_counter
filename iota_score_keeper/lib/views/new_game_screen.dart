import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/game_provider.dart';
import 'game_screen.dart';

class NewGameScreen extends ConsumerStatefulWidget {
  const NewGameScreen({super.key});

  @override
  ConsumerState<NewGameScreen> createState() => _NewGameScreenState();
}

class _NewGameScreenState extends ConsumerState<NewGameScreen> {
  final TextEditingController _nameController = TextEditingController();
  final List<String> _players = [];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addPlayer() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      setState(() {
        _players.add(name);
        _nameController.clear();
      });
    }
  }

  void _removePlayer(int index) {
    setState(() {
      _players.removeAt(index);
    });
  }

  void _startGame() {
    if (_players.isNotEmpty) {
      ref.read(gameProvider.notifier).startGame(_players);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GameScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Game')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Player Name',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addPlayer(),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton.filled(
                  onPressed: _addPlayer,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _players.isEmpty
                  ? const Center(child: Text('Add players to start'))
                  : ListView.builder(
                      itemCount: _players.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: CircleAvatar(child: Text(_players[index].isNotEmpty ? _players[index][0].toUpperCase() : '?')),
                            title: Text(_players[index]),
                            trailing: IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => _removePlayer(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _players.isNotEmpty ? _startGame : null,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Game'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
