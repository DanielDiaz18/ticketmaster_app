import '../constants/enums.dart';

/// Eventos de analytics
enum AnalyticsEvent {
  appOpened,
  categorySelected,
  venueSelected,
  eventSelected,
  ticketQuantityChanged,
  paymentMethodSelected,
  purchaseStarted,
  purchaseCompleted,
  purchaseCancelled,
  validationError,
}

/// Servicio de analytics para trackear eventos y métricas
class AnalyticsService {
  // Almacenamiento en memoria de eventos
  // En producción, esto se enviaría a Firebase Analytics, Mixpanel, etc.
  final List<AnalyticsEventData> _events = [];
  final Map<String, dynamic> _metrics = {};

  /// Trackea un evento
  void trackEvent(
    AnalyticsEvent event, {
    Map<String, dynamic> properties = const {},
  }) {
    final eventData = AnalyticsEventData(
      event: event,
      timestamp: DateTime.now(),
      properties: properties,
    );

    _events.add(eventData);
    _updateMetrics(event, properties);

    // En producción, aquí se enviaría a un servicio de analytics
    print('📊 Analytics: ${event.name} - $properties');
  }

  /// Actualiza métricas basadas en eventos
  void _updateMetrics(AnalyticsEvent event, Map<String, dynamic>? properties) {
    switch (event) {
      case AnalyticsEvent.categorySelected:
        _incrementMetric('category_${properties?['category']}_count');
        break;
      case AnalyticsEvent.venueSelected:
        _incrementMetric('venue_${properties?['venueId']}_count');
        break;
      case AnalyticsEvent.purchaseCompleted:
        _incrementMetric('total_purchases');
        _addToMetric('total_revenue', properties?['amount'] ?? 0.0);
        break;
      case AnalyticsEvent.purchaseCancelled:
        _incrementMetric('cancelled_purchases');
        break;
      case AnalyticsEvent.validationError:
        _incrementMetric('validation_errors');
        break;
      default:
        break;
    }
  }

  void _incrementMetric(String key) {
    _metrics[key] = (_metrics[key] ?? 0) + 1;
  }

  void _addToMetric(String key, double value) {
    _metrics[key] = (_metrics[key] ?? 0.0) + value;
  }

  /// Obtiene todas las métricas
  Map<String, dynamic> getMetrics() {
    return Map.from(_metrics);
  }

  /// Obtiene métricas de conversión por categoría
  Map<EventCategory, double> getConversionRateByCategory() {
    final Map<EventCategory, double> conversionRates = {};

    for (var category in EventCategory.values) {
      final categoryKey = category.toString().split('.').last;
      final selections = _metrics['category_${categoryKey}_count'] ?? 0;
      final purchases = _events
          .where(
            (e) =>
                e.event == AnalyticsEvent.purchaseCompleted &&
                e.properties['category'] == categoryKey,
          )
          .length;

      if (selections > 0) {
        conversionRates[category] = purchases / selections;
      } else {
        conversionRates[category] = 0.0;
      }
    }

    return conversionRates;
  }

  /// Obtiene los venues más populares
  Map<String, int> getMostPopularVenues() {
    final venueMetrics = <String, int>{};

    for (var entry in _metrics.entries) {
      if (entry.key.startsWith('venue_') && entry.key.endsWith('_count')) {
        final venueId = entry.key
            .replaceAll('venue_', '')
            .replaceAll('_count', '');
        venueMetrics[venueId] = entry.value as int;
      }
    }

    // Ordenar por popularidad
    final sortedVenues = venueMetrics.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sortedVenues);
  }

  /// Obtiene el uso de métodos de pago
  Map<PaymentMethod, int> getPaymentMethodUsage() {
    final paymentUsage = <PaymentMethod, int>{};

    for (var method in PaymentMethod.values) {
      final methodKey = method.toString().split('.').last;
      final count = _events
          .where(
            (e) =>
                e.event == AnalyticsEvent.paymentMethodSelected &&
                e.properties['method'] == methodKey,
          )
          .length;

      paymentUsage[method] = count;
    }

    return paymentUsage;
  }

  /// Obtiene el tiempo promedio de compra
  Duration getAveragePurchaseTime() {
    final purchaseStartEvents = _events
        .where((e) => e.event == AnalyticsEvent.purchaseStarted)
        .toList();

    final purchaseCompleteEvents = _events
        .where((e) => e.event == AnalyticsEvent.purchaseCompleted)
        .toList();

    if (purchaseStartEvents.isEmpty || purchaseCompleteEvents.isEmpty) {
      return Duration.zero;
    }

    int totalDuration = 0;
    int pairCount = 0;

    for (var startEvent in purchaseStartEvents) {
      final sessionId = startEvent.properties['sessionId'];
      final completeEvent = purchaseCompleteEvents.firstWhere(
        (e) => e.properties['sessionId'] == sessionId,
        orElse: () => AnalyticsEventData(
          event: AnalyticsEvent.purchaseCompleted,
          timestamp: DateTime.now(),
          properties: {},
        ),
      );

      if (completeEvent.properties.containsKey('sessionId')) {
        final duration = completeEvent.timestamp.difference(
          startEvent.timestamp,
        );
        totalDuration += duration.inSeconds;
        pairCount++;
      }
    }

    if (pairCount == 0) return Duration.zero;

    return Duration(seconds: totalDuration ~/ pairCount);
  }

  /// Obtiene todos los eventos registrados
  List<AnalyticsEventData> getAllEvents() {
    return List.from(_events);
  }

  /// Limpia todos los eventos y métricas (solo para testing)
  void clearAnalytics() {
    _events.clear();
    _metrics.clear();
  }
}

/// Datos de un evento de analytics
class AnalyticsEventData {
  final AnalyticsEvent event;
  final DateTime timestamp;
  final Map<String, dynamic> properties;

  AnalyticsEventData({
    required this.event,
    required this.timestamp,
    required this.properties,
  });

  @override
  String toString() {
    return 'AnalyticsEventData(event: ${event.name}, timestamp: $timestamp, properties: $properties)';
  }
}
