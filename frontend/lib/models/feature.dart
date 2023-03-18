import 'geometry.dart';
import 'package:json_annotation/json_annotation.dart';

import 'properties.dart';
part 'feature.g.dart';

//json format ->
//share some data, goe json.
// string, type property, whatever,
// convert to json.
// pro
@JsonSerializable(createToJson: false)
class Feature {
  final String type;
  final Propetries properties;
  final Geometry geometry;

  Feature(this.type, this.properties, this.geometry);

  factory Feature.fromJson(Map<String, dynamic> json) =>
      _$FeatureFromJson(json);
}
