// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import '../src/models/meditation.dart';
import '../src/models/meditation_config.dart';
import '../src/views/home_view.dart';
import '../src/views/loading_meditation.dart';
import '../src/views/other_player.dart';
import '../src/views/player_view.dart';

class Routes {
  static const String homeView = '/';
  static const String player = 'player';
  static const String other_player = 'other_player';
  static const String loading_meditation = 'loading_meditation';
  static const all = <String>{
    homeView,
    player,
    other_player,
    loading_meditation,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.homeView, page: HomeView),
    RouteDef(Routes.player, page: Player),
    RouteDef(Routes.other_player, page: OtherPlayer),
    RouteDef(Routes.loading_meditation, page: LoadingMeditationView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    HomeView: (data) {
      return CupertinoPageRoute<CupertinoRoute<dynamic>>(
        builder: (context) => const HomeView(),
        settings: data,
      );
    },
    Player: (data) {
      var args = data.getArgs<PlayerArguments>(
        orElse: () => PlayerArguments(),
      );
      return CupertinoPageRoute<CupertinoRoute<dynamic>>(
        builder: (context) => Player(
          key: args.key,
          meditation: args.meditation,
        ),
        settings: data,
      );
    },
    OtherPlayer: (data) {
      return CupertinoPageRoute<CupertinoRoute<dynamic>>(
        builder: (context) => const OtherPlayer(),
        settings: data,
      );
    },
    LoadingMeditationView: (data) {
      var args = data.getArgs<LoadingMeditationViewArguments>(nullOk: false);
      return CupertinoPageRoute<CupertinoRoute<dynamic>>(
        builder: (context) => LoadingMeditationView(
          key: args.key,
          config: args.config,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// Player arguments holder class
class PlayerArguments {
  final Key? key;
  final SimpleMeditation? meditation;
  PlayerArguments({this.key, this.meditation});
}

/// LoadingMeditationView arguments holder class
class LoadingMeditationViewArguments {
  final Key? key;
  final MeditationConfig config;
  LoadingMeditationViewArguments({this.key, required this.config});
}
