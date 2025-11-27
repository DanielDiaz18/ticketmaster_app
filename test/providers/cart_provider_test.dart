import 'package:flutter_test/flutter_test.dart';
import 'package:ticketmaster_app/providers/cart_provider.dart';
import 'package:ticketmaster_app/models/venue.dart';
import 'package:ticketmaster_app/models/payment.dart';
import 'package:ticketmaster_app/core/constants/enums.dart';
import 'package:ticketmaster_app/core/analytics/analytics_service.dart';
import 'package:ticketmaster_app/services/inventory_service.dart';

void main() {
  group('CartProvider', () {
    late CartProvider provider;
    late AnalyticsService analyticsService;
    late InventoryService inventoryService;
    late Theater testTheater;
    late Cinema testCinema;
    late Museum testMuseum;

    setUp(() {
      analyticsService = AnalyticsService();
      inventoryService = InventoryService();
      provider = CartProvider(
        analyticsService: analyticsService,
        inventoryService: inventoryService,
      );

      testTheater = Theater(
        id: 'theater-1',
        name: 'Teatro Nacional',
        location: 'Centro',
        capacity: 100,
        operatingDays: {
          1: true,
          2: true,
          3: true,
          4: true,
          5: true,
          6: true,
          7: false,
        },
        holidays: [],
        openingTime: '18:00',
        closingTime: '23:00',
        img: 'theater.jpg',
        sectionPrices: {TheaterSection.luneta: 150.00},
        shows: [
          TheaterShow(
            id: 'show-1',
            title: 'Hamlet',
            description: 'Classic',
            showTimes: ['19:00'],
            durationMinutes: 180,
          ),
        ],
        dressCode: 'Formal',
      );

      testCinema = Cinema(
        id: 'cinema-1',
        name: 'Cinépolis',
        location: 'Plaza',
        capacity: 100,
        operatingDays: {
          1: true,
          2: true,
          3: true,
          4: true,
          5: true,
          6: true,
          7: true,
        },
        holidays: [],
        openingTime: '10:00',
        closingTime: '00:00',
        img: 'cinema.jpg',
        chain: 'Cinépolis',
        availableServices: [CinemaServiceType.traditional],
        servicePrices: {CinemaServiceType.traditional: 100.00},
        movies: [
          Movie(
            id: 'movie-1',
            title: 'Avatar 3',
            description: 'Epic',
            rating: MovieRating.b15,
            showTimes: ['20:00'],
            durationMinutes: 180,
          ),
        ],
        restrictions: [],
      );

      testMuseum = Museum(
        id: 'museum-1',
        name: 'Museo Nacional',
        location: 'Centro Histórico',
        capacity: 100,
        operatingDays: {
          1: false,
          2: true,
          3: true,
          4: true,
          5: true,
          6: true,
          7: true,
        },
        holidays: [],
        openingTime: '09:00',
        closingTime: '18:00',
        img: 'museum.jpg',
        ticketPrice: 50.00,
        accessRestrictions: [],
        entryTimes: ['09:00', '11:00'],
      );
    });

    tearDown(() {
      analyticsService.clearAnalytics();
      inventoryService.clearInventory();
    });

    test('should initialize with empty cart', () {
      expect(provider.tickets, isEmpty);
      expect(provider.ticketCount, 0);
      expect(provider.totalAmount, 0.0);
      expect(provider.hasItems, false);
      expect(provider.selectedVenue, isNull);
    });

    test('should set venue', () {
      provider.setVenue(testTheater);

      expect(provider.selectedVenue, testTheater);
      expect(analyticsService.getAllEvents().length, 1);
    });

    test('should set event for theater', () {
      provider.setVenue(testTheater);
      final show = testTheater.shows[0];
      final date = DateTime(2025, 12, 1);
      const time = '19:00';

      provider.setEvent(show, date, time);

      expect(provider.selectedEvent, show);
      expect(provider.selectedDate, date);
      expect(provider.selectedTime, time);
      expect(analyticsService.getAllEvents().length, 2);
    });

    test('should set event for cinema', () {
      provider.setVenue(testCinema);
      final movie = testCinema.movies[0];
      final date = DateTime(2025, 12, 1);
      const time = '20:00';

      provider.setEvent(movie, date, time);

      expect(provider.selectedEvent, movie);
      expect(provider.selectedDate, date);
      expect(provider.selectedTime, time);
    });

    test('should add ticket to cart', () {
      provider.setVenue(testTheater);
      final show = testTheater.shows[0];
      final date = DateTime(2025, 12, 1);
      provider.setEvent(show, date, '19:00');

      final added = provider.addTicket(price: 150.00);

      expect(added, true);
      expect(provider.ticketCount, 1);
      expect(provider.totalAmount, 150.00);
      expect(provider.hasItems, true);
    });

    test('should not add ticket without venue', () {
      final added = provider.addTicket(price: 150.00);

      expect(added, false);
      expect(provider.ticketCount, 0);
    });

    test('should not add ticket without date', () {
      provider.setVenue(testTheater);

      final added = provider.addTicket(price: 150.00);

      expect(added, false);
      expect(provider.ticketCount, 0);
    });

    test('should respect theater ticket limit', () {
      provider.setVenue(testTheater);
      final show = testTheater.shows[0];
      final date = DateTime(2025, 12, 1);
      provider.setEvent(show, date, '19:00');

      // Agregar 10 boletos (límite para teatro)
      for (int i = 0; i < 10; i++) {
        provider.addTicket(price: 150.00);
      }

      expect(provider.ticketCount, 10);

      // Intentar agregar uno más
      final added = provider.addTicket(price: 150.00);
      expect(added, false);
      expect(provider.ticketCount, 10);
    });

    test('should respect museum ticket limit', () {
      provider.setVenue(testMuseum);
      final date = DateTime(2025, 12, 2); // Martes

      // Initialize inventory manually for museum since event is null
      inventoryService.initializeVenueInventory(
        testMuseum,
        date,
        'museum_entry',
      );

      provider.setEvent(null, date, '09:00');

      // Agregar 5 boletos (límite para museo)
      for (int i = 0; i < 5; i++) {
        final added = provider.addTicket(price: 50.00);
        expect(added, true, reason: 'Ticket ${i + 1} should be added');
      }

      expect(provider.ticketCount, 5);

      // Intentar agregar uno más
      final added = provider.addTicket(price: 50.00);
      expect(added, false);
      expect(provider.ticketCount, 5);
    });

    test('should remove ticket from cart', () {
      provider.setVenue(testTheater);
      final show = testTheater.shows[0];
      final date = DateTime(2025, 12, 1);
      provider.setEvent(show, date, '19:00');

      provider.addTicket(price: 150.00);
      provider.addTicket(price: 150.00);

      expect(provider.ticketCount, 2);

      final ticketId = provider.tickets[0].id;
      provider.removeTicket(ticketId);

      expect(provider.ticketCount, 1);
      expect(provider.totalAmount, 150.00);
    });

    test('should calculate total amount correctly', () {
      provider.setVenue(testTheater);
      final show = testTheater.shows[0];
      final date = DateTime(2025, 12, 1);
      provider.setEvent(show, date, '19:00');

      provider.addTicket(price: 150.00);
      provider.addTicket(price: 200.00);
      provider.addTicket(price: 100.00);

      expect(provider.totalAmount, 450.00);
    });

    test('should set payment method', () {
      provider.setPaymentMethod(PaymentMethod.creditCard);

      expect(provider.selectedPaymentMethod, PaymentMethod.creditCard);
      expect(analyticsService.getAllEvents().length, 1);
    });

    test('should set payment details', () {
      final details = CardPaymentDetails(
        cardNumber: '1234',
        cardholderName: 'John Doe',
        expiryDate: '12/25',
        cvv: '123',
      );

      provider.setPaymentDetails(details);

      expect(
        provider.selectedPaymentMethod,
        isNull,
      ); // No ha sido establecido aún
    });

    test('should complete purchase successfully', () async {
      provider.setVenue(testTheater);
      final show = testTheater.shows[0];
      final date = DateTime(2025, 12, 1);
      provider.setEvent(show, date, '19:00');
      provider.addTicket(price: 150.00);

      provider.setPaymentMethod(PaymentMethod.creditCard);
      provider.setPaymentDetails(
        CardPaymentDetails(
          cardNumber: '1234',
          cardholderName: 'John Doe',
          expiryDate: '12/25',
          cvv: '123',
        ),
      );

      final completed = await provider.completePurchase();

      expect(completed, true);
    });

    test('should not complete purchase without tickets', () async {
      provider.setPaymentMethod(PaymentMethod.creditCard);
      provider.setPaymentDetails(
        CardPaymentDetails(
          cardNumber: '1234',
          cardholderName: 'John Doe',
          expiryDate: '12/25',
          cvv: '123',
        ),
      );

      final completed = await provider.completePurchase();

      expect(completed, false);
    });

    test('should not complete purchase without payment method', () async {
      provider.setVenue(testTheater);
      final show = testTheater.shows[0];
      final date = DateTime(2025, 12, 1);
      provider.setEvent(show, date, '19:00');
      provider.addTicket(price: 150.00);

      final completed = await provider.completePurchase();

      expect(completed, false);
    });

    test('should cancel purchase and release tickets', () {
      provider.setVenue(testTheater);
      final show = testTheater.shows[0];
      final date = DateTime(2025, 12, 1);
      provider.setEvent(show, date, '19:00');
      provider.addTicket(price: 150.00);

      final availableBefore = inventoryService.getAvailableTickets(
        testTheater.id,
        date,
        show.id,
      );

      provider.cancelPurchase();

      expect(provider.ticketCount, 0);
      expect(provider.hasItems, false);

      final availableAfter = inventoryService.getAvailableTickets(
        testTheater.id,
        date,
        show.id,
      );

      expect(availableAfter, availableBefore + 1);
    });

    test('should clear cart', () {
      provider.setVenue(testTheater);
      final show = testTheater.shows[0];
      final date = DateTime(2025, 12, 1);
      provider.setEvent(show, date, '19:00');
      provider.addTicket(price: 150.00);
      provider.setPaymentMethod(PaymentMethod.creditCard);

      provider.clearCart();

      expect(provider.tickets, isEmpty);
      expect(provider.selectedVenue, isNull);
      expect(provider.selectedEvent, isNull);
      expect(provider.selectedDate, isNull);
      expect(provider.selectedTime, isNull);
      expect(provider.selectedPaymentMethod, isNull);
    });

    test('should set additional details', () {
      provider.setAdditionalDetails({'section': 'VIP'});

      // Los detalles adicionales se usan al agregar boletos
      provider.setVenue(testTheater);
      final show = testTheater.shows[0];
      final date = DateTime(2025, 12, 1);
      provider.setEvent(show, date, '19:00');
      provider.addTicket(price: 150.00);

      expect(provider.tickets[0].details['section'], 'VIP');
    });

    test('should respect inventory limits', () {
      // Crear un venue con capacidad muy limitada
      final smallVenue = Theater(
        id: 'small-theater',
        name: 'Small Theater',
        location: 'Centro',
        capacity: 2,
        operatingDays: {
          1: true,
          2: true,
          3: true,
          4: true,
          5: true,
          6: true,
          7: false,
        },
        holidays: [],
        openingTime: '18:00',
        closingTime: '23:00',
        img: 'theater.jpg',
        sectionPrices: {},
        shows: [
          TheaterShow(
            id: 'show-1',
            title: 'Test',
            description: 'Test',
            showTimes: ['19:00'],
            durationMinutes: 120,
          ),
        ],
        dressCode: 'Casual',
      );

      provider.setVenue(smallVenue);
      final show = smallVenue.shows[0];
      final date = DateTime(2025, 12, 1);
      provider.setEvent(show, date, '19:00');

      // Agregar 2 boletos (toda la capacidad)
      expect(provider.addTicket(price: 100.00), true);
      expect(provider.addTicket(price: 100.00), true);

      // Intentar agregar uno más debería fallar
      expect(provider.addTicket(price: 100.00), false);
      expect(provider.ticketCount, 2);
    });

    test('should track analytics events correctly', () {
      provider.setVenue(testTheater);
      final show = testTheater.shows[0];
      final date = DateTime(2025, 12, 1);
      provider.setEvent(show, date, '19:00');
      provider.addTicket(price: 150.00);
      provider.setPaymentMethod(PaymentMethod.creditCard);

      final events = analyticsService.getAllEvents();

      // Debe haber 4 eventos: venueSelected, eventSelected, ticketQuantityChanged, paymentMethodSelected
      expect(events.length, 4);
      expect(events[0].event, AnalyticsEvent.venueSelected);
      expect(events[1].event, AnalyticsEvent.eventSelected);
      expect(events[2].event, AnalyticsEvent.ticketQuantityChanged);
      expect(events[3].event, AnalyticsEvent.paymentMethodSelected);
    });
  });
}
