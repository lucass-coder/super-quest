import 'dart:core';

import 'package:flame/game.dart' as game;
import 'package:flutter/material.dart';

import 'package:super_quest/ember_quest.dart';
import 'package:super_quest/lesson_menu.dart';
import 'package:super_quest/overlays/game_over.dart';
import 'package:super_quest/overlays/main_menu.dart';


class Routes {
  static const menu = '/';
  static const lucas = '/lucas';

  static Route routes(RouteSettings settings) {
    MaterialPageRoute _buildRoute(Widget widget) {
      return MaterialPageRoute(builder: (_) => widget, settings: settings);
    }

    switch (settings.name) {
      case menu:
        return _buildRoute( LessonMenu());
      case lucas:
        return _buildRoute(
          game.GameWidget<EmberQuestGame>.controlled(
            gameFactory: EmberQuestGame.new,
            overlayBuilderMap: {
               'MainMenu': (_, game) => MainMenu(game: game),
               'GameOver': (_, game) => GameOver(game: game),
            },
             initialActiveOverlays: const ['MainMenu'],
          ),
        );
      default:
        throw Exception('Route does not exists');
    }
  }
}
