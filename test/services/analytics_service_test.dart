import 'package:flutter_test/flutter_test.dart';
import 'package:ticketmaster_app/core/analytics/analytics_service.dart';
import 'package:ticketmaster_app/core/constants/enums.dart';

void main() {
  group('AnalyticsService Tests', () {
    late AnalyticsService analyticsService;

    setUp(() {
      analyticsService = AnalyticsService();
    });

    tearDown(() {
      analyticsService.clearAnalytics();
    });

    test('should track event successfully', () {
      analyticsService.trackEvent(
        AnalyticsEvent.categorySelected,
        properties: {'category': 'theater'},
      );

      final events = analyticsService.getAllEvents();
      expect(events.length, equals(1));
      expect(events.first.event, equals(AnalyticsEvent.categorySelected));
      expect(events.first.properties['category'], equals('theater'));
    });

    test('should increment metrics when tracking events', () {
      analyticsService.trackEvent(
        AnalyticsEvent.categorySelected,
        properties: {'category': 'theater'},
      );
      analyticsService.trackEvent(
        AnalyticsEvent.categorySelected,
        properties: {'category': 'cinema'},
      );

      final metrics = analyticsService.getMetrics();
      expect(metrics['category_theater_count'], equals(1));
      expect(metrics['category_cinema_count'], equals(1));
    });

    test('should track purchase completion', () {
      analyticsService.trackEvent(
        AnalyticsEvent.purchaseCompleted,
        properties: {
          'sessionId': 'test123',
          'amount': 150.0,
          'ticketCount': 2,
        },
      );

      final metrics = analyticsService.getMetrics();
      expect(metrics['total_purchases'], equals(1));
      expect(metrics['total_revenue'], equals(150.0));
    });

    test('should track cancelled purchases', () {
      analyticsService.trackEvent(AnalyticsEvent.purchaseCancelled);

      final metrics = analyticsService.getMetrics();
      expect(metrics['cancelled_purchases'], equals(1));
    });

    test('should calculate conversion rate by category', () {
      // Simulate category selections
      analyticsService.trackEvent(
        AnalyticsEvent.categorySelected,
        properties: {'category': 'theater'},
      );
      analyticsService.trackEvent(
        AnalyticsEvent.categorySelected,
        properties: {'category': 'theater'},
      );

      // Simulate one purchase
      analyticsService.trackEvent(
        AnalyticsEvent.purchaseCompleted,
        properties: {'category': 'theater'},
      );

      final conversionRates = analyticsService.getConversionRateByCategory();
      expect(conversionRates[EventCategory.theater], equals(0.5)); // 1 purchase / 2 selections
    });

    test('should return most popular venues', () {
      analyticsService.trackEvent(
        AnalyticsEvent.venueSelected,
        properties: {'venueId': 'theater_colon'},
      );
      analyticsService.trackEvent(
        AnalyticsEvent.venueSelected,
        properties: {'venueId': 'theater_colon'},
      );
      analyticsService.trackEvent(
        AnalyticsEvent.venueSelected,
        properties: {'venueId': 'cinema_cinemark'},
      );

      final popularVenues = analyticsService.getMostPopularVenues();
      expect(popularVenues.length, greaterThan(0));
      expect(popularVenues.keys.first, equals('theater_colon'));
      expect(popularVenues['theater_colon'], equals(2));
    });

    test('should track payment method usage', () {
      analyticsService.trackEvent(
        AnalyticsEvent.paymentMethodSelected,
        properties: {'method': 'creditCard'},
      );
      analyticsService.trackEvent(
        AnalyticsEvent.paymentMethodSelected,
        properties: {'method': 'paypal'},
      );
      analyticsService.trackEvent(
        AnalyticsEvent.paymentMethodSelected,
        properties: {'method': 'creditCard'},
      );

      final paymentUsage = analyticsService.getPaymentMethodUsage();
      expect(paymentUsage[PaymentMethod.creditCard], equals(2));
      expect(paymentUsage[PaymentMethod.paypal], equals(1));
    });

    test('should clear all analytics data', () {
      analyticsService.trackEvent(AnalyticsEvent.appOpened);
      analyticsService.trackEvent(AnalyticsEvent.categorySelected);

      expect(analyticsService.getAllEvents().length, equals(2));

      analyticsService.clearAnalytics();

      expect(analyticsService.getAllEvents().length, equals(0));
      expect(analyticsService.getMetrics().length, equals(0));
    });
  });
}
