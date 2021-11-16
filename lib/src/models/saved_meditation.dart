import 'package:hive/hive.dart';

///Is important to put this here BEFORE running the script from below on terminal.
part 'saved_meditation.g.dart';

///This class will model the information for a meditation that is saved locally.
///It is also used to generate the corresponding Hive Type Adapter to store it
///inside a HiveBox. To retrieve it we should use the LocalStorageService Singleton.
///To generate the TypeAdapter run on terminal:
///flutter pub get && flutter  pub run build_runner build --delete-conflicting-outputs
///More info, see: https://docs.hivedb.dev/#/custom-objects/generate_adapter
@HiveType(typeId: 1)
class SavedMeditation {
  @HiveField(0)
  String path;

  @HiveField(1)
  String meditationName;

  @HiveField(2)
  Duration meditationDuration;

  SavedMeditation(this.path, this.meditationName, this.meditationDuration);
}
