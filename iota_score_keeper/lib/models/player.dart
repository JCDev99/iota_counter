import 'package:hive/hive.dart';

part 'player.g.dart';

@HiveType(typeId: 0)
class Player extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  List<int> scores;

  Player({
    required this.id,
    required this.name,
    required this.scores,
  });

  int get totalScore => scores.fold(0, (sum, score) => sum + score);
}
