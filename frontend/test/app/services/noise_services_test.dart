import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:sustainable_city_management/app/constants/app_constants.dart';
import 'package:sustainable_city_management/app/services/noise_services.dart';
import 'package:sustainable_city_management/app/dashboard/models/noise_model.dart';

// Import the generated mocks.dart file before noise_services_test.dart
import 'noise_services_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  group('NoiseServices', () {
    test('getNoiseData returns a list of noise data', () async {
      // Arrange
      final dio = MockDio();

      /// Replacing the dioClient instance in NoiseServices with the mocked instance
      final noiseServices = NoiseServices(dio: dio);
      final uri = Uri.parse(ApiPath.getNoiseData);
      final responseData = {
        'error': false,
        'msg': 'success',
        'noise_data': {
          'noiseData': [
            {
              'monitorID': 1,
              'location': 'Location 1',
              'latitude': 53.3464062899053,
              'longitude': -6.2570863424236,
              'recordTime': '2023-04-19 20:10:00',
              'currentRating': 3,
              'laeq': 60.5,
              'dailyAvg': 55.0,
              'hourlyAvg': 58.0,
            },
          ],
        },
      };

      when(dio.getUri(uri)).thenAnswer((_) async => Response(
          data: responseData, requestOptions: RequestOptions(path: '')));

      // Act
      final result = await noiseServices.getNoiseData();

      // Assert
      expect(result, isInstanceOf<List<NoiseDatum>>());
      expect(result.length, 1);
      expect(result.first.monitorId, 1);
      expect(result.first.location, 'Location 1');
      expect(result.first.latitude, 53.3464062899053);
      expect(result.first.longitude, -6.2570863424236);
      expect(result.first.recordTime, DateTime.parse('2023-04-19 20:10:00'));
      expect(result.first.currentRating, 3);
      expect(result.first.laeq, 60.5);
      expect(result.first.dailyAvg, 55.0);
      expect(result.first.hourlyAvg, 58.0);
    });
  });
}
