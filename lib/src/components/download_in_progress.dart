import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenity/src/models/meditation.dart';
import 'package:serenity/src/services/notifications_service.dart';
import 'package:serenity/src/style/text_theme.dart';
import 'package:serenity/src/utils/string_manipulation.dart';

class DownloadsInProgress extends StatefulWidget {
  const DownloadsInProgress({Key? key}) : super(key: key);

  @override
  State<DownloadsInProgress> createState() => _DownloadsInProgressState();
}

class _DownloadsInProgressState extends State<DownloadsInProgress> {
  GetIt locator = GetIt.instance;
  late NotificationService notifications;

  @override
  void initState() {
    notifications = locator<NotificationService>();
  }

  @override
  Widget build(BuildContext context) {
    double getHeight() {
      return MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom;
    }

    final double height = getHeight();
    final double width = MediaQuery.of(context).size.width;

    return Visibility(
      // visible: notifications.activeDownloads.isNotEmpty,
      child: Column(
        children: [
          Text("Descargas En Progreso"),
          Container(
            width: width * .7,
            height: height * .3,
            child: ListView.builder(
                itemCount: notifications.activeDownloads.length,
                itemBuilder: (context, index) {
                  return SingleDownload(
                      controller: notifications.activeDownloads[index]
                          as DownloadController<Meditation>);
                }),
          ),
        ],
      ),
    );
  }
}

class SingleDownload extends StatefulWidget {
  DownloadController<Meditation> controller;
  SingleDownload({Key? key, required this.controller}) : super(key: key);

  @override
  State<SingleDownload> createState() => _SingleDownloadState();
}

class _SingleDownloadState extends State<SingleDownload> {
  @override
  Widget build(BuildContext context) {
    double getHeight() {
      return MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom;
    }

    final double height = getHeight();
    final double width = MediaQuery.of(context).size.width;

    TextStyle meditationNameStyle = GoogleFonts.raleway(
      fontWeight: FontWeight.bold,
      fontSize: width * .03,
      color: Colors.black,
      // color: const Color(0xFF768596),
    );

    Widget? subtitleWidget() {
      if (widget.controller.downloadState == DownloadState.downloading) {
        return LinearProgressIndicator(
          value: widget.controller.progress,
        );
      }
    }

    Widget? trailingWidget() {
      if (widget.controller.downloadState == DownloadState.downloading) {
        return GradientText('${(widget.controller.progress * 100).round()}%');
      } else if (widget.controller.downloadState == DownloadState.processing) {
        return const CircularProgressIndicator();
      } else if (widget.controller.downloadState == DownloadState.finished) {
        if (widget.controller.downloadResult == DownloadResult.success) {
          return Icon(
            CupertinoIcons.check_mark_circled,
            color: Colors.greenAccent,
          );
        }
      }
    }

    return AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) {
          return ListTile(
            title: Text(
              "${widget.controller.downloadingObject!.name}.  Estado: ${enumValue(widget.controller.downloadState)}.",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            subtitle: subtitleWidget(),
            trailing: trailingWidget(),
          );
        });
  }
}
