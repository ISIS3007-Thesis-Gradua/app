import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenity/src/components/collapsed_container.dart';
import 'package:serenity/src/components/seek_bar.dart';
import 'package:serenity/src/models/meditation.dart';
import 'package:serenity/src/view_models/player_view_model.dart';
import 'package:serenity/src/views/scroll_sheet.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
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
  final _controller = PanelController();

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
        backgroundColor: const Color(0xFFF6F9FF),
        body: ScrollSheet(
          isDraggable: true,
          maxHeight: height * 0.67,
          minHeight: height * 0.06,
          controller: _controller,
          controllerType: ControllerType.fromFields,
          body: Padding(
            padding: EdgeInsets.fromLTRB(
                width * 0.03, height * 0.03, width * 0.03, 0),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(
                      CupertinoIcons.back,
                      size: height * 0.03,
                      color: Colors.black,
                    ),
                    onPressed: () => {navigationService.back()},
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(widget.meditation?.name ?? ""),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, height * .1, 0, height * .15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ViewModelBuilder<PlayerViewModel>.reactive(
                        // stream: null,
                        viewModelBuilder: () => vm,
                        builder: (context, vm, child) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFDCE7EF),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.066),
                                  child: SeekBar(
                                    duration: vm.positionData?.duration ??
                                        Duration.zero,
                                    position: vm.positionData?.position ??
                                        Duration.zero,
                                    bufferedPosition:
                                        vm.positionData?.bufferedPosition ??
                                            Duration.zero,
                                    onChanged: vm.player.seek,
                                  ),
                                ),
                                Text(
                                  "Meditación #34",
                                  style: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w700,
                                      fontSize: height * .03,
                                      color: Colors.black),
                                ),
                                Text(
                                  "Atención Plena",
                                  style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w400,
                                    fontSize: height * .02,
                                    color: Colors.black26,
                                  ),
                                ),
                                playPauseControls(context, vm, height, width),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          panel: Container(
            child: Text("Hello World"),
          ),
          collapse: CollapsedContainer(_controller, height, width),
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
          color: Colors.black,
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
                  color: Colors.black,
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
                color: Colors.black,
              ),
              onPressed: () {
                vm.player.pause();
              },
            ),
          ),
        ),
        Icon(
          Icons.settings_voice_outlined,
          size: height * 0.03,
          color: Colors.black,
        )
      ],
    );
  }
}
