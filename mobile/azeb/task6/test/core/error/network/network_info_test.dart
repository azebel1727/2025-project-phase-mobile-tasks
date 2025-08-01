import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:task6/core/error/network/network_info.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([InternetConnectionChecker])
void main() {
  late NetworkInfoImpl networkInfo;
  late MockInternetConnectionChecker mockConnectionChecker;

  setUp(() {
    mockConnectionChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(mockConnectionChecker);
  });

  test('should forward the call to InternetConnectionChecker.hasConnection', () async {
    when(mockConnectionChecker.hasConnection).thenAnswer((_) async => true);

    final result = await networkInfo.isConnected;

    verify(mockConnectionChecker.hasConnection);
    expect(result, true);
  });
}
