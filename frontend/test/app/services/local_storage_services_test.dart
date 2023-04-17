import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:sustainable_city_management/app/services/local_storage_services.dart';

// @GenerateMocks([FlutterSecureStorage])
@GenerateNiceMocks([MockSpec<FlutterSecureStorage>()])
import 'local_storage_services_test.mocks.dart';

// class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('LocalStorageServices', () {
    late LocalStorageServices localStorageServices;
    late MockFlutterSecureStorage mockStorage;

    setUpAll(() {
      mockStorage = MockFlutterSecureStorage();
      localStorageServices = LocalStorageServices(storage: mockStorage);
    });

    test('write calls storage.write with key and value', () async {
      const key = 'test_key';
      const value = 'test_value';

      when(mockStorage.write(key: key, value: value)).thenAnswer((_) async {});

      await localStorageServices.write(key, value);

      verify(mockStorage.write(key: key, value: value)).called(1);
    });

    test('read calls storage.read with key and returns value', () async {
      const key = 'test_key';
      const value = 'test_value';

      when(mockStorage.read(key: key)).thenAnswer((_) async => value);

      final result = await localStorageServices.read(key);

      expect(result, value);
      verify(mockStorage.read(key: key)).called(1);
    });

    test('delete calls storage.delete with key', () async {
      const key = 'test_key';

      await localStorageServices.delete(key);

      verify(mockStorage.delete(key: key)).called(1);
    });

    test('deleteAll calls storage.deleteAll', () async {
      await localStorageServices.deleteAll();

      verify(mockStorage.deleteAll()).called(1);
    });

    tearDownAll(() {
      mockStorage;
      localStorageServices;
    });
  });
}
