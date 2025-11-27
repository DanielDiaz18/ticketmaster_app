import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/ticket.dart';
import '../models/payment.dart';
import '../models/venue.dart';
import '../core/constants/enums.dart';
import '../core/analytics/analytics_service.dart';
import '../services/inventory_service.dart';

/// Provider para gestionar el carrito de compras
class CartProvider with ChangeNotifier {
  final AnalyticsService _analyticsService;
  final InventoryService _inventoryService;
  final _uuid = const Uuid();

  // Estado del carrito
  final List<Ticket> _tickets = [];
  Venue? _selectedVenue;
  dynamic _selectedEvent; // TheaterShow, Movie, o null para Museum
  DateTime? _selectedDate;
  String? _selectedTime;
  Map<String, dynamic>? _additionalDetails;

  // Estado de pago
  PaymentMethod? _selectedPaymentMethod;
  PaymentDetails? _paymentDetails;

  // ID de sesión para analytics
  final String _sessionId = const Uuid().v4();

  CartProvider({
    required AnalyticsService analyticsService,
    required InventoryService inventoryService,
  })  : _analyticsService = analyticsService,
        _inventoryService = inventoryService;

  // Getters
  List<Ticket> get tickets => List.unmodifiable(_tickets);
  Venue? get selectedVenue => _selectedVenue;
  dynamic get selectedEvent => _selectedEvent;
  DateTime? get selectedDate => _selectedDate;
  String? get selectedTime => _selectedTime;
  PaymentMethod? get selectedPaymentMethod => _selectedPaymentMethod;
  
  int get ticketCount => _tickets.length;
  
  double get totalAmount {
    return _tickets.fold(0.0, (sum, ticket) => sum + ticket.price);
  }

  bool get hasItems => _tickets.isNotEmpty;

  /// Establece el venue seleccionado
  void setVenue(Venue venue) {
    _selectedVenue = venue;
    _analyticsService.trackEvent(
      AnalyticsEvent.venueSelected,
      properties: {
        'venueId': venue.id,
        'venueName': venue.name,
        'category': venue.category.toString().split('.').last,
      },
    );
    notifyListeners();
  }

  /// Establece el evento seleccionado
  void setEvent(dynamic event, DateTime date, String time) {
    _selectedEvent = event;
    _selectedDate = date;
    _selectedTime = time;

    String eventId = '';
    String eventName = '';

    if (event is TheaterShow) {
      eventId = event.id;
      eventName = event.title;
    } else if (event is Movie) {
      eventId = event.id;
      eventName = event.title;
    }

    _analyticsService.trackEvent(
      AnalyticsEvent.eventSelected,
      properties: {
        'eventId': eventId,
        'eventName': eventName,
        'date': date.toIso8601String(),
        'time': time,
      },
    );

    // Inicializar inventario para este evento
    if (_selectedVenue != null) {
      _inventoryService.initializeVenueInventory(_selectedVenue!, date, eventId);
    }

    notifyListeners();
  }

  /// Establece detalles adicionales (sección de teatro, tipo de servicio, etc.)
  void setAdditionalDetails(Map<String, dynamic> details) {
    _additionalDetails = details;
    notifyListeners();
  }

  /// Agrega un boleto al carrito
  bool addTicket({
    required double price,
    Map<String, dynamic>? details,
  }) {
    if (_selectedVenue == null || _selectedDate == null || _selectedTime == null) {
      return false;
    }

    // Validar límites según categoría
    int maxTickets = _getMaxTicketsForCategory(_selectedVenue!.category);
    if (_tickets.length >= maxTickets) {
      return false;
    }

    // Verificar disponibilidad en inventario
    String eventId = _getEventId();
    final available = _inventoryService.getAvailableTickets(
      _selectedVenue!.id,
      _selectedDate!,
      eventId,
    );

    if (available <= 0) {
      return false;
    }

    // Reservar boleto
    bool reserved = _inventoryService.reserveTickets(
      _selectedVenue!.id,
      _selectedDate!,
      eventId,
      1,
    );

    if (!reserved) {
      return false;
    }

    final ticket = Ticket(
      id: _uuid.v4(),
      venueId: _selectedVenue!.id,
      venueName: _selectedVenue!.name,
      category: _selectedVenue!.category,
      eventId: eventId,
      eventName: _getEventName(),
      eventDate: _selectedDate!,
      eventTime: _selectedTime!,
      price: price,
      details: details ?? _additionalDetails ?? {},
    );

    _tickets.add(ticket);

    _analyticsService.trackEvent(
      AnalyticsEvent.ticketQuantityChanged,
      properties: {
        'quantity': _tickets.length,
        'venueId': _selectedVenue!.id,
      },
    );

    notifyListeners();
    return true;
  }

  /// Remueve un boleto del carrito
  void removeTicket(String ticketId) {
    final ticket = _tickets.firstWhere((t) => t.id == ticketId);
    _tickets.removeWhere((t) => t.id == ticketId);

    // Liberar boleto del inventario
    _inventoryService.releaseTickets(
      ticket.venueId,
      ticket.eventDate,
      ticket.eventId,
      1,
    );

    notifyListeners();
  }

  /// Establece el método de pago
  void setPaymentMethod(PaymentMethod method) {
    _selectedPaymentMethod = method;
    _analyticsService.trackEvent(
      AnalyticsEvent.paymentMethodSelected,
      properties: {
        'method': method.toString().split('.').last,
      },
    );
    notifyListeners();
  }

  /// Establece los detalles de pago
  void setPaymentDetails(PaymentDetails details) {
    _paymentDetails = details;
    notifyListeners();
  }

  /// Completa la compra
  Future<bool> completePurchase() async {
    if (!_canCompletePurchase()) {
      return false;
    }

    _analyticsService.trackEvent(
      AnalyticsEvent.purchaseStarted,
      properties: {
        'sessionId': _sessionId,
        'ticketCount': _tickets.length,
        'amount': totalAmount,
      },
    );

    // Simular procesamiento de pago
    await Future.delayed(const Duration(seconds: 2));

    // Confirmar ventas en inventario
    for (var ticket in _tickets) {
      _inventoryService.confirmSale(
        ticket.venueId,
        ticket.eventDate,
        ticket.eventId,
        1,
      );
    }

    _analyticsService.trackEvent(
      AnalyticsEvent.purchaseCompleted,
      properties: {
        'sessionId': _sessionId,
        'ticketCount': _tickets.length,
        'amount': totalAmount,
        'category': _selectedVenue?.category.toString().split('.').last,
        'venueId': _selectedVenue?.id,
      },
    );

    return true;
  }

  /// Cancela la compra
  void cancelPurchase() {
    // Liberar todos los boletos del inventario
    for (var ticket in _tickets) {
      _inventoryService.releaseTickets(
        ticket.venueId,
        ticket.eventDate,
        ticket.eventId,
        1,
      );
    }

    _analyticsService.trackEvent(
      AnalyticsEvent.purchaseCancelled,
      properties: {
        'sessionId': _sessionId,
        'ticketCount': _tickets.length,
      },
    );

    clearCart();
  }

  /// Limpia el carrito
  void clearCart() {
    _tickets.clear();
    _selectedVenue = null;
    _selectedEvent = null;
    _selectedDate = null;
    _selectedTime = null;
    _additionalDetails = null;
    _selectedPaymentMethod = null;
    _paymentDetails = null;
    notifyListeners();
  }

  bool _canCompletePurchase() {
    return _tickets.isNotEmpty &&
        _selectedPaymentMethod != null &&
        _paymentDetails != null;
  }

  int _getMaxTicketsForCategory(EventCategory category) {
    switch (category) {
      case EventCategory.theater:
      case EventCategory.cinema:
        return 10;
      case EventCategory.museum:
        return 5;
    }
  }

  String _getEventId() {
    if (_selectedEvent is TheaterShow) {
      return (_selectedEvent as TheaterShow).id;
    } else if (_selectedEvent is Movie) {
      return (_selectedEvent as Movie).id;
    }
    return 'museum_entry';
  }

  String _getEventName() {
    if (_selectedEvent is TheaterShow) {
      return (_selectedEvent as TheaterShow).title;
    } else if (_selectedEvent is Movie) {
      return (_selectedEvent as Movie).title;
    }
    return _selectedVenue?.name ?? 'Museum';
  }
}
