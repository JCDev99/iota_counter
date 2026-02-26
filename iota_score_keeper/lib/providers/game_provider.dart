import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/game.dart';
import '../models/player.dart';

final gameProvider = NotifierProvider<GameNotifier, Game?>(GameNotifier.new);

class GameNotifier extends Notifier<Game?> {
  @override
  Game? build() => null;

  void startGame(List<String> playerNames) {
    if (playerNames.isEmpty) return;

    final players = playerNames.map((name) => Player(
      id: DateTime.now().microsecondsSinceEpoch.toString() + name,
      name: name,
      scores: [],
    )).toList();

    final game = Game(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      players: players,
      isFinished: false,
    );

    state = game;
    _saveGame();
  }

  void resumeGame(Game game) {
    state = game;
  }

  void addScore(String playerId, int score) {
    if (state == null) return;

    final updatedPlayers = state!.players.map((p) {
      if (p.id == playerId) {
        final newScores = List<int>.from(p.scores)..add(score);
        return Player(id: p.id, name: p.name, scores: newScores);
      }
      return p;
    }).toList();

    state = Game(
      id: state!.id,
      date: state!.date,
      isFinished: state!.isFinished,
      players: updatedPlayers,
    );
    _saveGame();
  }

  void updateScore(String playerId, int index, int newScore) {
    if (state == null) return;

    final updatedPlayers = state!.players.map((p) {
      if (p.id == playerId) {
        if (index >= 0 && index < p.scores.length) {
            final newScores = List<int>.from(p.scores);
            newScores[index] = newScore;
            return Player(id: p.id, name: p.name, scores: newScores);
        }
      }
      return p;
    }).toList();

    state = Game(
      id: state!.id,
      date: state!.date,
      isFinished: state!.isFinished,
      players: updatedPlayers,
    );
    _saveGame();
  }

  void deleteScore(String playerId, int index) {
      if (state == null) return;

      final updatedPlayers = state!.players.map((p) {
        if (p.id == playerId) {
          if (index >= 0 && index < p.scores.length) {
              final newScores = List<int>.from(p.scores);
              newScores.removeAt(index);
              return Player(id: p.id, name: p.name, scores: newScores);
          }
        }
        return p;
      }).toList();

      state = Game(
        id: state!.id,
        date: state!.date,
        isFinished: state!.isFinished,
        players: updatedPlayers,
      );
      _saveGame();
  }

  void finishGame() {
    if (state == null) return;
    state = Game(
      id: state!.id,
      date: state!.date,
      isFinished: true,
      players: state!.players,
    );
    _saveGame();
  }

  Future<void> _saveGame() async {
    if (state == null) return;
    final box = Hive.box<Game>('games');
    await box.put(state!.id, state!);
  }

  void clearGame() {
    state = null;
  }
}
