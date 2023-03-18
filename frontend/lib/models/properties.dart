import 'package:json_annotation/json_annotation.dart';
part 'properties.g.dart';

@JsonSerializable(createToJson: false)
class Propetries {
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'stroke')
  final String stroke;
  @JsonKey(name: 'stroke-width')
  final double strokeWidth;
  @JsonKey(name: 'stroke-opacity')
  final double strokeOpacity;
  @JsonKey(name: 'fill')
  final String fill;
  @JsonKey(name: 'fill-opacity')
  final double fillOpacity;
  @JsonKey(name: 'agency_name')
  final String agency_name;

  Propetries(this.name, this.stroke, this.strokeWidth, this.strokeOpacity,
      this.fill, this.fillOpacity, this.agency_name);

  factory Propetries.fromJson(Map<String, dynamic> json) =>
      _$PropetriesFromJson(json);
}
