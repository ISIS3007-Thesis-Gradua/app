import 'package:flutter/cupertino.dart';

class NotificationService extends ChangeNotifier {
  List<DownloadController> _activeDownloads;

  NotificationService() : _activeDownloads = [];

  List<DownloadController> get activeDownloads => _activeDownloads;

  set activeDownloads(List<DownloadController> activeDownloads) {
    _activeDownloads = activeDownloads;
    notifyListeners();
  }

  DownloadController addDownload() {
    DownloadController download = DownloadController.create();
    activeDownloads.add(download);
    notifyListeners();
    return download;
  }

  void removeDownloadProcess(String id) {
    activeDownloads.removeWhere((d) => d.id == id);
    notifyListeners();
  }
}

enum DownloadState { initializing, downloading, processing, saving, finished }

enum DownloadResult { none, success, error }

///This class will handle the general state of a single meditation download
///process.
class DownloadController extends ChangeNotifier {
  /// Id of the download in progress.
  ///
  /// (It is just a Stringify version of the TimeStamp of the moment when the instance was created)
  String id;

  bool _downloadInProgress;

  double _progress;

  DownloadState _downloadState;

  DownloadResult _downloadResult;

  DownloadController.create()
      : id = DateTime.now().millisecondsSinceEpoch.toString(),
        _downloadInProgress = true,
        _progress = 0.0,
        _downloadState = DownloadState.initializing,
        _downloadResult = DownloadResult.none;

  ///[True] if the download state is anything but [DownloadState.finished],
  ///in which case this is [False].
  bool get downloadInProgress => _downloadInProgress;

  ///True it the download is in progress, false if not.
  ///It will notify all listeners of this variable.
  set downloadInProgress(bool downloadInProgress) {
    _downloadInProgress = downloadInProgress;
    notifyListeners();
  }

  ///The current state of the download process.
  DownloadState get downloadState => _downloadState;

  ///The current state of the download process.
  ///It will notify all listeners of this variable.
  set downloadState(DownloadState downloadState) {
    _downloadState = downloadState;
    if (downloadState == DownloadState.finished) {
      _downloadInProgress = false;
    }
    notifyListeners();
  }

  ///This will represent the percentage of completeness
  ///of the download, is a value between 0.0 and 1.0. Will be 1.0 if [downloadState]
  ///went from [DownloadState.downloading] to [DownloadState.processing].
  double get progress => _progress;

  ///The current download progress between 0.0 and 1.0
  ///It will notify all listeners of this variable.
  set progress(double progress) {
    _progress = progress;
    notifyListeners();
  }

  ///The result of this process. Is [DownloadResult.none] if the
  ///process has not finished yet.
  DownloadResult get downloadResult => _downloadResult;

  set downloadResult(DownloadResult downloadResult) {
    _downloadResult = downloadResult;
    notifyListeners();
  }
}
