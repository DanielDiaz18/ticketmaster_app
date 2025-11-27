import 'package:flutter_test/flutter_test.dart';
import 'package:ticketmaster_app/models/ticket.dart';
import 'package:ticketmaster_app/core/constants/enums.dart';

void main() {
  group('Ticket', () {
    test('should create ticket with all properties', () {
      final ticket = Ticket(
        id: 'ticket-123',
        venueId: 'venue-1',
        venueName: 'Teatro Nacional',
        category: EventCategory.theater,
        eventId: 'event-1',
        eventName: 'Hamlet',
        eventDate: DateTime(2025, 12, 1),
        eventTime: '20:00',
        price: 150.00,
        details: {'section': 'Luneta'},
      );

      expect(ticket.id, 'ticket-123');
      expect(ticket.venueId, 'venue-1');
      expect(ticket.venueName, 'Teatro Nacional');
      expect(ticket.category, EventCategory.theater);
      expect(ticket.eventId, 'event-1');
      expect(ticket.eventName, 'Hamlet');
      expect(ticket.eventDate, DateTime(2025, 12, 1));
      expect(ticket.eventTime, '20:00');
      expect(ticket.price, 150.00);
      expect(ticket.details['section'], 'Luneta');
    });

    test('should convert ticket to JSON', () {
      final ticket = Ticket(
        id: 'ticket-123',
        venueId: 'venue-1',
        venueName: 'Teatro Nacional',
        category: EventCategory.theater,
        eventId: 'event-1',
        eventName: 'Hamlet',
        eventDate: DateTime(2025, 12, 1),
        eventTime: '20:00',
        price: 150.00,
        details: {'section': 'Luneta'},
      );

      final json = ticket.toJson();

      expect(json['id'], 'ticket-123');
      expect(json['venueId'], 'venue-1');
      expect(json['venueName'], 'Teatro Nacional');
      expect(json['category'], 'EventCategory.theater');
      expect(json['eventId'], 'event-1');
      expect(json['eventName'], 'Hamlet');
      expect(json['eventDate'], '2025-12-01T00:00:00.000');
      expect(json['eventTime'], '20:00');
      expect(json['price'], 150.00);
      expect(json['details'], {'section': 'Luneta'});
    });

    test('should create ticket from JSON', () {
      final json = {
        'id': 'ticket-456',
        'venueId': 'venue-2',
        'venueName': 'Cinépolis',
        'category': 'EventCategory.cinema',
        'eventId': 'movie-1',
        'eventName': 'Avatar 3',
        'eventDate': '2025-12-15T00:00:00.000',
        'eventTime': '18:30',
        'price': 120.00,
        'details': {'serviceType': 'IMAX'},
      };

      final ticket = Ticket.fromJson(json);

      expect(ticket.id, 'ticket-456');
      expect(ticket.venueId, 'venue-2');
      expect(ticket.venueName, 'Cinépolis');
      expect(ticket.category, EventCategory.cinema);
      expect(ticket.eventId, 'movie-1');
      expect(ticket.eventName, 'Avatar 3');
      expect(ticket.eventDate, DateTime(2025, 12, 15));
      expect(ticket.eventTime, '18:30');
      expect(ticket.price, 120.00);
      expect(ticket.details['serviceType'], 'IMAX');
    });
  });

  group('TheaterTicket', () {
    test('should create theater ticket with specific properties', () {
      final ticket = TheaterTicket(
        id: 'ticket-789',
        venueId: 'theater-1',
        venueName: 'Teatro de la Ciudad',
        eventId: 'show-1',
        eventName: 'El Fantasma de la Ópera',
        eventDate: DateTime(2025, 12, 20),
        eventTime: '19:00',
        price: 200.00,
        section: TheaterSection.palco,
        dressCode: 'Formal',
      );

      expect(ticket.category, EventCategory.theater);
      expect(ticket.section, TheaterSection.palco);
      expect(ticket.dressCode, 'Formal');
      expect(ticket.details['section'], 'Palco');
      expect(ticket.details['dressCode'], 'Formal');
    });
  });

  group('CinemaTicket', () {
    test('should create cinema ticket with specific properties', () {
      final ticket = CinemaTicket(
        id: 'ticket-101',
        venueId: 'cinema-1',
        venueName: 'Cinemark',
        eventId: 'movie-2',
        eventName: 'Dune Part 3',
        eventDate: DateTime(2025, 12, 25),
        eventTime: '21:00',
        price: 180.00,
        serviceType: CinemaServiceType.imax,
        seatNumber: 'F12',
        movieRating: MovieRating.b15,
      );

      expect(ticket.category, EventCategory.cinema);
      expect(ticket.serviceType, CinemaServiceType.imax);
      expect(ticket.seatNumber, 'F12');
      expect(ticket.movieRating, MovieRating.b15);
      expect(ticket.details['serviceType'], 'IMAX');
      expect(ticket.details['seatNumber'], 'F12');
      expect(ticket.details['movieRating'], 'B15 - Mayores de 15 años');
    });
  });

  group('MuseumTicket', () {
    test('should create museum ticket with specific properties', () {
      final ticket = MuseumTicket(
        id: 'ticket-202',
        venueId: 'museum-1',
        venueName: 'Museo Nacional',
        eventId: 'museum_entry',
        eventName: 'Museo Nacional',
        eventDate: DateTime(2025, 12, 30),
        eventTime: '10:00',
        price: 50.00,
        entryTime: '10:00 AM',
      );

      expect(ticket.category, EventCategory.museum);
      expect(ticket.entryTime, '10:00 AM');
      expect(ticket.details['entryTime'], '10:00 AM');
    });
  });
}
