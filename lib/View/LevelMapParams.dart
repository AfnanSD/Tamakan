//\\\Not used///\\\
import 'dart:ui';

import 'ImageParams.dart';

class LevelMapParams {
  late final int levelCount;

  /// Determines the current level of the user.
  /// If the user is in between levels, use decimal.
  late final double currentLevel;

  /// Determines the stroke width of the path lines.
  /// Default is 3.
  late final double pathStrokeWidth;
  late final Color pathColor;

  /// Default is 200.
  late final double levelHeight;

  /// Used to adjust the length of the dash.
  /// Should be between 0 and 0.5.
  /// Default is 0.025.
  late final double dashLengthFactor;

  /// If set to false, there won't be any variation between curves, all curves are identical.
  /// Default is true.
  late final bool enableVariationBetweenCurves;

  /// Determines max offset variation between curves.
  /// Affects only if [enableVariationBetweenCurves] flag is set to true.
  /// Note: Having huge [maxVariationFactor]  causes hard edges. Ideal value is between 0 and 1 (may vary based on the [levelHeight]).
  /// Default is 0.2.
  late final double maxVariationFactor;

  /// Determines the position of the reference point of the first curve.
  /// This affects all the successive reference points.
  /// Offset factor should be between 0 and 1.
  /// Default is random.
  late Offset? firstCurveReferencePointOffsetFactor;

  /// List of reference point offset of each level.
  /// Affects only if [enableVariationBetweenCurves] flag is set to true
  /// Helps to position the reference point for each curve.
  /// Default is random.
  late final List<Offset> curveReferenceOffsetVariationForEachLevel;

  late final bool showPathShadow;

  /// Determines how far the shadows should cast.
  /// Affects only if showPathShadow flag is set to true
  /// dx of the offset determines horizontal distance from the path,
  /// dy of the offset determines vertical distance from the path.
  /// +ve dx casts shadow to right and -ve dx casts shadow to the left,
  /// +ve dy casts shadow to the bottom and -ve dy casts shadow to the top.
  /// Default is Offset(-2, 12).
  late final Offset shadowDistanceFromPathOffset;

  /// Min Amplitude factor of the curve.
  /// Affects how far the reference point at least be from mid point.
  /// Offset factor should be between 0 and 1.
  /// Default is Offset(0.4, 0.3), which means dx of Reference point should at least (0.4 * (width/2))
  /// and dy of the Reference point should at least (0.3 * (width/2))
  /// width/2 since the curve starts in center
  late final Offset minReferencePositionOffsetFactor;

  /// Max Amplitude factor of the curve.
  /// Affects how far the reference point at most be from mid point.
  /// Offset factor should be between 0 and 1.
  /// Default is Offset(1, 0.7), which means dx of Reference point should at most (1 * (width/2))
  /// and dy of the Reference point should at most (0.7 * (width/2))
  /// width/2 since the curve starts in center
  late final Offset maxReferencePositionOffsetFactor;

  late final List<ImageParams>? bgImagesToBePaintedRandomly;

  /// It is the image positioned in the bottom center of the level map to indicate the start position.
  late final ImageParams? startLevelImage;

  /// It is the image positioned on top of the completed levels of the level map to indicate the level is completed.
  late final ImageParams completedLevelImage;

  /// It is the image positioned on top of the current level of the level map to indicate the current position of the user.
  late final ImageParams currentLevelImage;

  /// It is the image positioned on top of the upcoming levels of the level map to indicate those levels are yet to unlock.
  late final ImageParams lockedLevelImage;

  /// It is the image positioned in the top center of the level map to indicate the end of the level map.
  late final ImageParams? pathEndImage;
}
