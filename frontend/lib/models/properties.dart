import 'package:json_annotation/json_annotation.dart';
part 'properties.g.dart';

@JsonSerializable(createToJson: false)
class Propetries {
  @JsonKey(name: 'agency_name', required: false)
  final String agency_name;
  @JsonKey(name: 'route_id', required: false)
  final String route_id;
  @JsonKey(name: 'agency_id', required: false)
  final String agency_id;
  @JsonKey(name: 'route_short_name', required: false)
  final String route_short_name;
  @JsonKey(name: 'route_long_name', required: false)
  final String route_long_name;
  @JsonKey(name: 'route_type', required: false)
  final int route_type;

  Propetries(this.agency_name, this.route_id, this.agency_id,
      this.route_short_name, this.route_long_name, this.route_type);

  factory Propetries.fromJson(Map<String, dynamic> json) =>
      _$PropetriesFromJson(json);
}
