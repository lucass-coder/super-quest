import 'package:flutter/material.dart';
import 'package:super_quest/routes.dart';


final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.routes,
    ),
    // GameWidget<EmberQuestGame>.controlled(
    //   gameFactory: EmberQuestGame.new,
    //   overlayBuilderMap: {
    //      'MainMenu': (_, game) => MainMenu(game: game),
    //      'GameOver': (_, game) => GameOver(game: game),
    //   },
    //    initialActiveOverlays: const ['MainMenu'],
    // ),
  );
}