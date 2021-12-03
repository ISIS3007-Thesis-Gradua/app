// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import '../src/models/emotions_measure.dart';
import '../src/models/meditation.dart';
import '../src/models/meditation_config.dart';
import '../src/view_models/player_view_model.dart';
import '../src/views/graph_view.dart';
import '../src/views/home_view.dart';
import '../src/views/loading_meditation.dart';
import '../src/views/login_view.dart';
import '../src/views/meditation_rating_view.dart';
import '../src/views/other_player.dart';
import '../src/views/player_view.dart';
import '../src/views/registation_view.dart';

class Routes {
  static const String homeView = '/';
  static const String login = 'login';
  static const String registration = 'registration';
  static const String player = 'player';
  static const String other_player = 'other_player';
  static const String meditation_rating = 'meditation_rating';
  static const String loading_meditation = 'loading_meditation';
  static const String graph_view = 'graph_view';
  static const all = <String>{
    homeView,
    login,
    registration,
    player,
    other_player,
    meditation_rating,
    loading_meditation,
    graph_view,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.homeView, page: HomeView),
    RouteDef(Routes.login, page: Login),
    RouteDef(Routes.registration, page: Registration),
    RouteDef(Routes.player, page: Player),
    RouteDef(Routes.other_player, page: OtherPlayer),
    RouteDef(Routes.meditation_rating, page: MeditationRatingView),
    RouteDef(Routes.loading_meditation, page: LoadingMeditationView),
    RouteDef(Routes.graph_view, page: GraphView),
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
    Login: (data) {
      return CupertinoPageRoute<CupertinoRoute<dynamic>>(
        builder: (context) => const Login(),
        settings: data,
      );
    },
    Registration: (data) {
      return CupertinoPageRoute<CupertinoRoute<dynamic>>(
        builder: (context) => const Registration(),
        settings: data,
      );
    },
    Player: (data) {
      var args = data.getArgs<PlayerArguments>(nullOk: false);
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
    MeditationRatingView: (data) {
      var args = data.getArgs<MeditationRatingViewArguments>(nullOk: false);
      return CupertinoPageRoute<CupertinoRoute<dynamic>>(
        builder: (context) => MeditationRatingView(
          key: args.key,
          prevEmotionsMeasure: args.prevEmotionsMeasure,
          simpleMeditation: args.simpleMeditation,
          ttsSource: args.ttsSource,
        ),
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
    GraphView: (data) {
      var args = data.getArgs<GraphViewArguments>(nullOk: false);
      return CupertinoPageRoute<CupertinoRoute<dynamic>>(
        builder: (context) => GraphView(
          args.prevEmotionsMeasure,
          args.posEmotionsMeasure,
          key: args.key,
          simpleMeditation: args.simpleMeditation,
          ttsSource: args.ttsSource,
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
  final SimpleMeditation meditation;
  PlayerArguments({this.key, required this.meditation});
}

/// MeditationRatingView arguments holder class
class MeditationRatingViewArguments {
  final Key? key;
  final EmotionsMeasure prevEmotionsMeasure;
  final SimpleMeditation simpleMeditation;
  final TtsSource ttsSource;
  MeditationRatingViewArguments(
      {this.key,
      required this.prevEmotionsMeasure,
      required this.simpleMeditation,
      required this.ttsSource});
}

/// LoadingMeditationView arguments holder class
class LoadingMeditationViewArguments {
  final Key? key;
  final MeditationConfig config;
  LoadingMeditationViewArguments({this.key, required this.config});
}

/// GraphView arguments holder class
class GraphViewArguments {
  final EmotionsMeasure prevEmotionsMeasure;
  final EmotionsMeasure posEmotionsMeasure;
  final Key? key;
  final SimpleMeditation simpleMeditation;
  final TtsSource ttsSource;
  GraphViewArguments(
      {required this.prevEmotionsMeasure,
      required this.posEmotionsMeasure,
      this.key,
      required this.simpleMeditation,
      required this.ttsSource});
}
