import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:serenity/src/services/notifications_service.dart';

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
      visible: notifications.activeDownloads.isNotEmpty,
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
                      controller: notifications.activeDownloads[index]);
                }),
          ),
        ],
      ),
    );
  }
}

class SingleDownload extends StatefulWidget {
  DownloadController controller;
  SingleDownload({Key? key, required this.controller}) : super(key: key);

  @override
  State<SingleDownload> createState() => _SingleDownloadState();
}

class _SingleDownloadState extends State<SingleDownload> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) {
          return Text(
            "${widget.controller.id}: ${widget.controller.downloadState}. Per: ${(widget.controller.progress * 100).round()}",
            style: TextStyle(
              color: Colors.black,
            ),
          );
        });
  }
}
