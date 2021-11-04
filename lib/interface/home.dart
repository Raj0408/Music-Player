/* 
  Copyright 2020-2021, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import 'package:dart_discord_rpc/dart_discord_rpc.dart';

import 'package:harmonoid/core/collection.dart';
import 'package:harmonoid/core/discordrpc.dart';
import 'package:harmonoid/interface/changenotifiers.dart';
import 'package:harmonoid/interface/nowplaying.dart';
import 'package:harmonoid/interface/nowplayingbar.dart';
import 'package:harmonoid/utils/widgets.dart';
import 'package:harmonoid/core/lyrics.dart';
import 'package:harmonoid/interface/collection/collectionmusic.dart';
import 'package:harmonoid/constants/language.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  HomeState createState() => HomeState();
}

class HomeState extends State<Home>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  int? index = 0;
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() async {
    if (nowPlayingBar.maximized) nowPlayingBar.maximized = false;
    if (this.navigatorKey.currentState!.canPop()) {
      this.navigatorKey.currentState!.pop();
    } else {
      showDialog(
        context: context,
        builder: (subContext) => AlertDialog(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(
            language!.STRING_EXIT_TITLE,
            style: Theme.of(subContext).textTheme.headline1,
          ),
          content: Text(
            language!.STRING_EXIT_SUBTITLE,
            style: Theme.of(subContext).textTheme.headline3,
          ),
          actions: [
            MaterialButton(
              textColor: Theme.of(context).primaryColor,
              onPressed: SystemNavigator.pop,
              child: Text(language!.STRING_YES),
            ),
            MaterialButton(
              textColor: Theme.of(context).primaryColor,
              onPressed: Navigator.of(subContext).pop,
              child: Text(language!.STRING_NO),
            ),
          ],
        ),
      );
    }
    return true;
  }

  void showNowPlaying() {
    nowPlayingBar.maximized = true;
    navigatorKey.currentState?.push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SharedAxisTransition(
          transitionType: SharedAxisTransitionType.vertical,
          fillColor: Colors.transparent,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: NowPlayingScreen(),
        ),
      ),
    );
  }

  void hideNowPlaying() {
    nowPlayingBar.maximized = false;
    navigatorKey.currentState?.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider<Collection>(
            create: (context) => collection,
          ),
          ChangeNotifierProvider(
            create: (context) => collectionRefresh,
          ),
          ChangeNotifierProvider<NowPlayingController>(
            create: (context) => nowPlaying,
          ),
          ChangeNotifierProvider<NowPlayingBarController>(
            create: (context) => nowPlayingBar,
          ),
          Provider<DiscordRPC>(
            create: (context) => discordRPC,
          ),
          ChangeNotifierProvider<YouTubeStateController>(
            create: (context) => YouTubeStateController(),
          ),
          ChangeNotifierProvider<Language>(
            create: (context) => Language.get()!,
          ),
          ChangeNotifierProvider<Lyrics>(
            create: (context) => Lyrics.get(),
          ),
        ],
        builder: (context, _) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const WindowTitleBar(),
            Expanded(
              child: Consumer<Language>(
                builder: (context, _, __) => Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: HeroControllerScope(
                    controller: MaterialApp.createMaterialHeroController(),
                    child: Navigator(
                      key: this.navigatorKey,
                      initialRoute: 'collection',
                      onGenerateRoute: (RouteSettings routeSettings) {
                        Route<dynamic>? route;
                        if (routeSettings.name == 'collection') {
                          route = MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const CollectionMusic(),
                          );
                        }
                        return route;
                      },
                    ),
                  ),
                ),
              ),
            ),
            NowPlayingBar(
              launch: this.showNowPlaying,
              exit: this.hideNowPlaying,
            ),
          ],
        ),
      ),
    );
  }
}
