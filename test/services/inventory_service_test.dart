import 'package:flutter_test/flutter_test.dart';
import 'package:ticketmaster_app/services/inventory_service.dart';
import 'package:ticketmaster_app/models/venue.dart';
import 'package:ticketmaster_app/core/constants/enums.dart';

void main() {
  group('InventoryService', () {
    late InventoryService service;
    late Venue testVenue;

    setUp(() {
      service = InventoryService();
      testVenue = Venue(
        id: 'venue-1',
        name: 'Test Venue',
        location: 'Test Location',
        category: EventCategory.theater,
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
        openingTime: '10:00',
        closingTime: '22:00',
        img: 'test.jpg',
      );
    });

    tearDown(() {
      service.clearInventory();
    });

    test('should initialize venue inventory', () {
      final date = DateTime(2025, 12, 1);
      const eventId = 'event-1';

      service.initializeVenueInventory(testVenue, date, eventId);

      final available = service.getAvailableTickets(
        testVenue.id,
        date,
        eventId,
      );

      expect(available, 100);
    });

    test('should return 0 for uninitialized inventory', () {
      final date = DateTime(2025, 12, 1);
      const eventId = 'event-1';

      final available = service.getAvailableTickets(
        testVenue.id,
        date,
        eventId,
      );

      expect(available, 0);
    });

    test('should reserve tickets successfully', () {
      final date = DateTime(2025, 12, 1);
      const eventId = 'event-1';

      service.initializeVenueInventory(testVenue, date, eventId);

      final reserved = service.reserveTickets(testVenue.id, date, eventId, 5);

      expect(reserved, true);

      final available = service.getAvailableTickets(
        testVenue.id,
        date,
        eventId,
      );

      expect(available, 95);
    });

    test('should fail to reserve more tickets than available', () {
      final date = DateTime(2025, 12, 1);
      const eventId = 'event-1';

      service.initializeVenueInventory(testVenue, date, eventId);

      final reserved = service.reserveTickets(testVenue.id, date, eventId, 150);

      expect(reserved, false);

      final available = service.getAvailableTickets(
        testVenue.id,
        date,
        eventId,
      );

      expect(available, 100);
    });

    test('should release reserved tickets', () {
      final date = DateTime(2025, 12, 1);
      const eventId = 'event-1';

      service.initializeVenueInventory(testVenue, date, eventId);
      service.reserveTickets(testVenue.id, date, eventId, 10);

      expect(service.getAvailableTickets(testVenue.id, date, eventId), 90);

      service.releaseTickets(testVenue.id, date, eventId, 10);

      expect(service.getAvailableTickets(testVenue.id, date, eventId), 100);
    });

    test('should handle multiple reservations', () {
      final date = DateTime(2025, 12, 1);
      const eventId = 'event-1';

      service.initializeVenueInventory(testVenue, date, eventId);

      service.reserveTickets(testVenue.id, date, eventId, 20);
      service.reserveTickets(testVenue.id, date, eventId, 30);
      service.reserveTickets(testVenue.id, date, eventId, 25);

      final available = service.getAvailableTickets(
        testVenue.id,
        date,
        eventId,
      );

      expect(available, 25);
    });

    test('should handle different dates independently', () {
      const eventId = 'event-1';
      final date1 = DateTime(2025, 12, 1);
      final date2 = DateTime(2025, 12, 2);

      service.initializeVenueInventory(testVenue, date1, eventId);
      service.initializeVenueInventory(testVenue, date2, eventId);

      service.reserveTickets(testVenue.id, date1, eventId, 30);
      service.reserveTickets(testVenue.id, date2, eventId, 50);

      expect(service.getAvailableTickets(testVenue.id, date1, eventId), 70);
      expect(service.getAvailableTickets(testVenue.id, date2, eventId), 50);
    });

    test('should handle different events independently', () {
      final date = DateTime(2025, 12, 1);
      const eventId1 = 'event-1';
      const eventId2 = 'event-2';

      service.initializeVenueInventory(testVenue, date, eventId1);
      service.initializeVenueInventory(testVenue, date, eventId2);

      service.reserveTickets(testVenue.id, date, eventId1, 40);
      service.reserveTickets(testVenue.id, date, eventId2, 20);

      expect(service.getAvailableTickets(testVenue.id, date, eventId1), 60);
      expect(service.getAvailableTickets(testVenue.id, date, eventId2), 80);
    });

    test('should confirm sale without changing inventory', () {
      final date = DateTime(2025, 12, 1);
      const eventId = 'event-1';

      service.initializeVenueInventory(testVenue, date, eventId);
      service.reserveTickets(testVenue.id, date, eventId, 10);

      final beforeSale = service.getAvailableTickets(
        testVenue.id,
        date,
        eventId,
      );

      service.confirmSale(testVenue.id, date, eventId, 10);

      final afterSale = service.getAvailableTickets(
        testVenue.id,
        date,
        eventId,
      );

      expect(beforeSale, afterSale);
    });

    test('should clear inventory', () {
      final date = DateTime(2025, 12, 1);
      const eventId = 'event-1';

      service.initializeVenueInventory(testVenue, date, eventId);
      service.reserveTickets(testVenue.id, date, eventId, 10);

      service.clearInventory();

      final available = service.getAvailableTickets(
        testVenue.id,
        date,
        eventId,
      );

      expect(available, 0);
    });

    test('should not re-initialize existing inventory', () {
      final date = DateTime(2025, 12, 1);
      const eventId = 'event-1';

      service.initializeVenueInventory(testVenue, date, eventId);
      service.reserveTickets(testVenue.id, date, eventId, 30);

      // Intentar reinicializar
      service.initializeVenueInventory(testVenue, date, eventId);

      // El inventario debe permanecer en 70, no resetearse a 100
      final available = service.getAvailableTickets(
        testVenue.id,
        date,
        eventId,
      );

      expect(available, 70);
    });
  });
}
