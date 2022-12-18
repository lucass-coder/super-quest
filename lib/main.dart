import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:super_quest/overlays/game_over.dart';
import 'package:super_quest/overlays/main_menu.dart';

import 'ember_quest.dart';

void main() {
  runApp(
    GameWidget<EmberQuestGame>.controlled(
      // initialActiveOverlays: const ['MainMenu'],
      gameFactory: EmberQuestGame.new,
      overlayBuilderMap: {
        // 'MainMenu': (_, game) => MainMenu(game: game),
         'GameOver': (_, game) => GameOver(game: game),
      },
      // initialActiveOverlays: const ['MainMenu'],
    ),
  );
}