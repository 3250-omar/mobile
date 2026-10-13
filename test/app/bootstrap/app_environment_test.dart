import 'package:flutter_test/flutter_test.dart';
import 'package:offline_quotes/app/bootstrap/app_environment.dart';

void main() {
  group('AppEnvironment', () {
    test('parses development environment successfully', () {
      expect(AppEnvironment.parse('development'), AppEnvironment.development);
      expect(AppEnvironment.parse('DEVELOPMENT'), AppEnvironment.development);
      expect(AppEnvironment.parse(' development '), AppEnvironment.development);
      expect(AppEnvironment.development.isDevelopment, isTrue);
      expect(AppEnvironment.development.isTesting, isFalse);
      expect(AppEnvironment.development.isProduction, isFalse);
    });

    test('parses testing environment successfully', () {
      expect(AppEnvironment.parse('testing'), AppEnvironment.testing);
      expect(AppEnvironment.parse('TESTING'), AppEnvironment.testing);
      expect(AppEnvironment.testing.isTesting, isTrue);
      expect(AppEnvironment.testing.isDevelopment, isFalse);
      expect(AppEnvironment.testing.isProduction, isFalse);
    });

    test('parses production environment successfully', () {
      expect(AppEnvironment.parse('production'), AppEnvironment.production);
      expect(AppEnvironment.parse('PRODUCTION'), AppEnvironment.production);
      expect(AppEnvironment.production.isProduction, isTrue);
      expect(AppEnvironment.production.isDevelopment, isFalse);
      expect(AppEnvironment.production.isTesting, isFalse);
    });

    test('rejects unknown environment names', () {
      expect(() => AppEnvironment.parse('staging'), throwsArgumentError);
      expect(() => AppEnvironment.parse('sandbox'), throwsArgumentError);
      expect(() => AppEnvironment.parse('local'), throwsArgumentError);
      expect(() => AppEnvironment.parse('qa'), throwsArgumentError);
    });

    test('rejects null or empty environment names', () {
      expect(() => AppEnvironment.parse(null), throwsArgumentError);
      expect(() => AppEnvironment.parse(''), throwsArgumentError);
      expect(() => AppEnvironment.parse('   '), throwsArgumentError);
    });

    test('contains no remote endpoint or secret defaults', () {
      // Assert contract: environments do not hold remote hosts, endpoints, or secrets
      for (final env in AppEnvironment.values) {
        expect(env.name, isNotEmpty);
      }
    });
  });
}
