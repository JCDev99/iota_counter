import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/game.dart';

final historyProvider = NotifierProvider<HistoryNotifier, List<Game>>(HistoryNotifier.new);

class HistoryNotifier extends Notifier<List<Game>> {
  late final ValueListenable<Box<Game>> _listenable;

  @override
  List<Game> build() {
    final box = Hive.box<Game>('games');
    _listenable = box.listenable();
    _listenable.addListener(_onBoxChange);
    ref.onDispose(() => _listenable.removeListener(_onBoxChange));
    return _getGames();
  }

  void _onBoxChange() {
    state = _getGames();
  }

  List<Game> _getGames() {
    final box = Hive.box<Game>('games');
    final games = box.values.toList().cast<Game>();
    games.sort((a, b) => b.date.compareTo(a.date));
    return games;
  }

  Future<void> deleteGame(String id) async {
    final box = Hive.box<Game>('games');
    await box.delete(id);
  }
}
