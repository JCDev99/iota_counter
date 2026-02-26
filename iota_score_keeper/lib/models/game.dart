import 'package:hive/hive.dart';
import 'player.dart';

part 'game.g.dart';

@HiveType(typeId: 1)
class Game extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  bool isFinished;

  @HiveField(3)
  List<Player> players;

  Game({
    required this.id,
    required this.date,
    this.isFinished = false,
    required this.players,
  });
}
