import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:serenity/src/components/seek_bar.dart';
import 'package:serenity/src/models/meditation.dart';
import 'package:serenity/src/view_models/player_view_model.dart';
import 'package:serenity/src/views/scroll_sheet.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class Player extends StatefulWidget {
  final SimpleMeditation? meditation;
  const Player({Key? key, this.meditation}) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> with WidgetsBindingObserver {
  bool isSimple = true;
  GetIt locator = GetIt.instance;
  final PlayerViewModel vm = PlayerViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.meditation is Meditation) {
      setState(() {
        isSimple = false;
        vm.constructSource((widget.meditation as Meditation).meditationText);
      });
    }
    WidgetsBinding.instance?.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    vm.init();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      vm.player.stop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    vm.player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double getHeight() {
      return MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom;
    }

    final double height = getHeight();
    final width = MediaQuery.of(context).size.width;
    final navigationService = locator<NavigationService>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFEDCCEE),
        body: ScrollSheet(
          isDraggable: false,
          maxHeight: height * 0.35,
          minHeight: height * 0.35,
          body: Padding(
            padding: EdgeInsets.fromLTRB(width * 0.05, height * 0.03, 0, 0),
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(
                        CupertinoIcons.back,
                        size: height * 0.03,
                      ),
                      onPressed: () => {navigationService.back()},
                    )),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(widget.meditation?.name ?? ""),
                )
              ],
            ),
          ),
          panel: ViewModelBuilder<PlayerViewModel>.reactive(
              // stream: null,
              viewModelBuilder: () => vm,
              builder: (context, vm, child) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Color(0xEEF6F5F5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      playPauseControls(context, vm, height, width),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: width * 0.066),
                        child: SeekBar(
                          duration: vm.positionData?.duration ?? Duration.zero,
                          position: vm.positionData?.position ?? Duration.zero,
                          bufferedPosition: vm.positionData?.bufferedPosition ??
                              Duration.zero,
                          onChanged: vm.player.seek,
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  Widget playPauseControls(
      BuildContext context, PlayerViewModel vm, double height, double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          CupertinoIcons.heart,
          size: height * 0.03,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, height * 0.025),
          child: Visibility(
            visible: vm.hasPlayerState
                ? !vm.playerState.playing || vm.isCompleted
                : true,
            child: Visibility(
              visible: vm.hasPlayerState ? vm.isLoading : true,
              child: CircularProgressIndicator(),
              replacement: IconButton(
                icon: Icon(
                  CupertinoIcons.play_circle,
                  size: height * 0.055,
                ),
                onPressed: () {
                  if (vm.isCompleted) {
                    vm.player.seek(Duration.zero);
                  }
                  vm.player.play();
                },
              ),
            ),
            replacement: IconButton(
              icon: Icon(
                CupertinoIcons.pause_circle,
                size: height * 0.055,
              ),
              onPressed: () {
                vm.player.pause();
              },
            ),
          ),
        ),
        Icon(Icons.settings_voice_outlined, size: height * 0.03)
      ],
    );
  }
}
