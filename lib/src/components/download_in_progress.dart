import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenity/app/app.locator.dart';
import 'package:serenity/src/models/meditation.dart';
import 'package:serenity/src/services/notifications_service.dart';
import 'package:serenity/src/style/gradua_gradients.dart';
import 'package:serenity/src/style/text_theme.dart';

import 'cards.dart';

class DownloadsInProgress extends StatefulWidget {
  const DownloadsInProgress({Key? key}) : super(key: key);

  @override
  State<DownloadsInProgress> createState() => _DownloadsInProgressState();
}

class _DownloadsInProgressState extends State<DownloadsInProgress> {
  final NotificationService notifications = locator<NotificationService>();

  @override
  Widget build(BuildContext context) {
    double getHeight() {
      return MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom;
    }

    final double height = getHeight();
    final double width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
        animation: notifications,
        builder: (context, _) {
          return Visibility(
            visible: notifications.activeDownloads.isNotEmpty,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, height * .02, 0, 0),
                  child: Text(
                    "Descargas En Progreso",
                    style: GoogleFonts.raleway(
                      fontWeight: FontWeight.bold,
                      fontSize: width * .04,
                      color: Colors.black,
                      // color: const Color(0xFF768596),
                    ),
                  ),
                ),
                Container(
                  width: width * .7,
                  height: height * .3,
                  child: ListView.builder(
                      itemCount: notifications.activeDownloads.length,
                      itemBuilder: (context, index) {
                        return SingleDownload(
                            index: index,
                            controller: notifications.activeDownloads[index]
                                as DownloadController<Meditation>);
                      }),
                ),
              ],
            ),
          );
        });
  }
}

class SingleDownload extends StatefulWidget {
  DownloadController<Meditation> controller;
  int index;
  SingleDownload({Key? key, required this.controller, required this.index})
      : super(key: key);

  @override
  State<SingleDownload> createState() => _SingleDownloadState();
}

class _SingleDownloadState extends State<SingleDownload> {
  final NotificationService notifications = locator<NotificationService>();
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
          color: Colors.white,
        );
      }
    }

    Widget? trailingWidget() {
      if (widget.controller.downloadState == DownloadState.downloading) {
        return GradientText('${(widget.controller.progress * 100).round()}%');
      } else if (widget.controller.downloadState == DownloadState.processing) {
        return const CircularProgressIndicator(color: Colors.white);
      } else if (widget.controller.downloadState == DownloadState.finished) {
        if (widget.controller.downloadResult == DownloadResult.success) {
          return const Icon(
            CupertinoIcons.check_mark_circled,
            color: Colors.greenAccent,
          );
        }
      }
    }

    GraduaGradients getCardGradient() {
      if (widget.controller.downloadState == DownloadState.finished) {
        if (widget.controller.downloadResult == DownloadResult.success) {
          return GraduaGradients.successAlertGradient;
        } else {
          return GraduaGradients.errorAlertGradient;
        }
      } else {
        return GraduaGradients.defaultGradient;
      }
    }

    String getDownloadText() {
      if (widget.controller.downloadState == DownloadState.finished) {
        if (widget.controller.downloadResult == DownloadResult.success) {
          return "¡Descarga Exitosa!";
        } else {
          return "¡Hubo un error en la descarga!";
        }
      } else if (widget.controller.downloadState == DownloadState.downloading) {
        return "Descargando ${widget.controller.downloadingObject!.name}";
      } else if (widget.controller.downloadState == DownloadState.saving) {
        return "Guardando ${widget.controller.downloadingObject!.name}";
      } else if (widget.controller.downloadState ==
          DownloadState.initializing) {
        return "Iniciando descarga de ${widget.controller.downloadingObject!.name}";
      } else {
        return "Procesando descarga.";
      }
    }

    return AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) {
          GraduaGradients gradient = getCardGradient();
          TextStyle alertTextStyle = GoogleFonts.raleway(
            fontWeight: FontWeight.bold,
            fontSize: width * .03,
            color: gradient.textContrastingColor,
            // color: const Color(0xFF768596),
          );
          return Dismissible(
            key: ValueKey<int>(widget.index),
            onDismissed: (direction) {
              notifications.removeDownloadProcess(widget.controller.id);
            },
            child: BasicCard(
              gradient: gradient.linearGradient,
              child: ListTile(
                title: Text(
                  getDownloadText(),
                  style: alertTextStyle,
                  textAlign: TextAlign.center,
                ),
                subtitle: subtitleWidget(),
                trailing: trailingWidget(),
              ),
            ),
          );
        });
  }
}
