import 'package:easy_logger/easy_logger.dart';

class ElibertyLogger {
  static final logger = EasyLogger(
    name: '🛂 Eliberty Check',
    defaultLevel: LevelMessages.debug,
    enableBuildModes: [BuildMode.debug, BuildMode.profile, BuildMode.release],
    enableLevels: [
      LevelMessages.debug,
      LevelMessages.info,
      LevelMessages.error,
      LevelMessages.warning
    ],
  );

  static void info(String message) {
    logger.info(message);
  }
}
