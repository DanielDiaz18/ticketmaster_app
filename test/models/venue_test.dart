import 'package:flutter_test/flutter_test.dart';
import 'package:ticketmaster_app/models/venue.dart';
import 'package:ticketmaster_app/core/constants/enums.dart';

void main() {
  group('Venue', () {
    late Venue venue;

    setUp(() {
      venue = Venue(
        id: 'venue-1',
        name: 'Test Venue',
        location: 'Test Location',
        category: EventCategory.theater,
        capacity: 500,
        operatingDays: {
          1: true, // Lunes
          2: true, // Martes
          3: true, // Miércoles
          4: true, // Jueves
          5: true, // Viernes
          6: true, // Sábado
          7: false, // Domingo
        },
        holidays: [
          DateTime(2025, 12, 25), // Navidad
          DateTime(2026, 1, 1), // Año Nuevo
        ],
        openingTime: '10:00',
        closingTime: '22:00',
        img: 'test.jpg',
      );
    });

    test('should create venue with all properties', () {
      expect(venue.id, 'venue-1');
      expect(venue.name, 'Test Venue');
      expect(venue.location, 'Test Location');
      expect(venue.category, EventCategory.theater);
      expect(venue.capacity, 500);
      expect(venue.openingTime, '10:00');
      expect(venue.closingTime, '22:00');
    });

    test('should return true for operating day', () {
      // Lunes (weekday = 1)
      final monday = DateTime(2025, 12, 1); // Es lunes
      expect(venue.isOperatingOnDate(monday), true);
    });

    test('should return false for non-operating day', () {
      // Domingo (weekday = 7)
      final sunday = DateTime(2025, 12, 7); // Es domingo
      expect(venue.isOperatingOnDate(sunday), false);
    });

    test('should return false for holiday', () {
      final christmas = DateTime(2025, 12, 25);
      expect(venue.isOperatingOnDate(christmas), false);
    });

    test('should return true for regular operating day', () {
      final regularDay = DateTime(2025, 12, 3); // Miércoles
      expect(venue.isOperatingOnDate(regularDay), true);
    });

    test('should convert venue to JSON', () {
      final json = venue.toJson();

      expect(json['id'], 'venue-1');
      expect(json['name'], 'Test Venue');
      expect(json['location'], 'Test Location');
      expect(json['category'], 'EventCategory.theater');
      expect(json['capacity'], 500);
      expect(json['openingTime'], '10:00');
      expect(json['closingTime'], '22:00');
    });
  });

  group('Theater', () {
    late Theater theater;

    setUp(() {
      theater = Theater(
        id: 'theater-1',
        name: 'Teatro Nacional',
        location: 'Centro',
        capacity: 800,
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
        sectionPrices: {
          TheaterSection.luneta: 150.00,
          TheaterSection.palco: 250.00,
          TheaterSection.balcon: 100.00,
          TheaterSection.general: 80.00,
        },
        shows: [
          TheaterShow(
            id: 'show-1',
            title: 'Hamlet',
            description: 'Classic Shakespeare',
            showTimes: ['19:00', '21:00'],
            durationMinutes: 180,
          ),
        ],
        dressCode: 'Formal',
      );
    });

    test('should create theater with specific properties', () {
      expect(theater.category, EventCategory.theater);
      expect(theater.dressCode, 'Formal');
      expect(theater.shows.length, 1);
      expect(theater.sectionPrices.length, 4);
    });

    test('should get price for section', () {
      expect(theater.getPriceForSection(TheaterSection.luneta), 150.00);
      expect(theater.getPriceForSection(TheaterSection.palco), 250.00);
      expect(theater.getPriceForSection(TheaterSection.balcon), 100.00);
      expect(theater.getPriceForSection(TheaterSection.general), 80.00);
    });

    test('should return 0 for unknown section', () {
      // Crear un enum value que no existe en el mapa
      final theater2 = Theater(
        id: 'theater-2',
        name: 'Teatro 2',
        location: 'Centro',
        capacity: 800,
        operatingDays: {1: true},
        holidays: [],
        openingTime: '18:00',
        closingTime: '23:00',
        img: 'theater.jpg',
        sectionPrices: {}, // Mapa vacío
        shows: [],
        dressCode: 'Casual',
      );

      expect(theater2.getPriceForSection(TheaterSection.luneta), 0.0);
    });
  });

  group('Cinema', () {
    late Cinema cinema;

    setUp(() {
      cinema = Cinema(
        id: 'cinema-1',
        name: 'Cinépolis',
        location: 'Plaza Comercial',
        capacity: 300,
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
        availableServices: [
          CinemaServiceType.traditional,
          CinemaServiceType.imax,
          CinemaServiceType.vip,
        ],
        servicePrices: {
          CinemaServiceType.traditional: 100.00,
          CinemaServiceType.imax: 180.00,
          CinemaServiceType.vip: 220.00,
        },
        movies: [
          Movie(
            id: 'movie-1',
            title: 'Avatar 3',
            description: 'Epic sci-fi',
            rating: MovieRating.b15,
            showTimes: ['14:00', '17:00', '20:00'],
            durationMinutes: 180,
          ),
        ],
        restrictions: ['No food from outside'],
      );
    });

    test('should create cinema with specific properties', () {
      expect(cinema.category, EventCategory.cinema);
      expect(cinema.chain, 'Cinépolis');
      expect(cinema.availableServices.length, 3);
      expect(cinema.movies.length, 1);
      expect(cinema.restrictions.length, 1);
    });

    test('should check if service is available', () {
      expect(cinema.hasService(CinemaServiceType.imax), true);
      expect(cinema.hasService(CinemaServiceType.fourDX), false);
    });

    test('should get price for service', () {
      expect(cinema.getPriceForService(CinemaServiceType.traditional), 100.00);
      expect(cinema.getPriceForService(CinemaServiceType.imax), 180.00);
      expect(cinema.getPriceForService(CinemaServiceType.vip), 220.00);
    });

    test('should return 0 for unknown service', () {
      expect(cinema.getPriceForService(CinemaServiceType.fourDX), 0.0);
    });
  });

  group('Museum', () {
    late Museum museum;

    setUp(() {
      museum = Museum(
        id: 'museum-1',
        name: 'Museo Nacional',
        location: 'Centro Histórico',
        capacity: 200,
        operatingDays: {
          1: false, // Cerrado lunes
          2: true,
          3: true,
          4: true,
          5: true,
          6: true,
          7: true,
        },
        holidays: [DateTime(2025, 12, 25)],
        openingTime: '09:00',
        closingTime: '18:00',
        img: 'museum.jpg',
        ticketPrice: 50.00,
        accessRestrictions: ['No flash photography', 'No large bags'],
        entryTimes: ['09:00', '11:00', '13:00', '15:00'],
      );
    });

    test('should create museum with specific properties', () {
      expect(museum.category, EventCategory.museum);
      expect(museum.ticketPrice, 50.00);
      expect(museum.accessRestrictions.length, 2);
      expect(museum.entryTimes.length, 4);
    });

    test('should not operate on Mondays', () {
      final monday = DateTime(2025, 12, 1);
      expect(museum.isOperatingOnDate(monday), false);
    });

    test('should operate on other days', () {
      final tuesday = DateTime(2025, 12, 2);
      expect(museum.isOperatingOnDate(tuesday), true);
    });
  });

  group('TheaterShow', () {
    test('should create theater show', () {
      final show = TheaterShow(
        id: 'show-1',
        title: 'Romeo y Julieta',
        description: 'Tragedia romántica',
        showTimes: ['19:00', '21:30'],
        durationMinutes: 150,
      );

      expect(show.id, 'show-1');
      expect(show.title, 'Romeo y Julieta');
      expect(show.description, 'Tragedia romántica');
      expect(show.showTimes.length, 2);
      expect(show.durationMinutes, 150);
    });
  });

  group('Movie', () {
    test('should create movie', () {
      final movie = Movie(
        id: 'movie-1',
        title: 'Inception',
        description: 'Mind-bending thriller',
        rating: MovieRating.b15,
        showTimes: ['16:00', '19:00', '22:00'],
        durationMinutes: 148,
      );

      expect(movie.id, 'movie-1');
      expect(movie.title, 'Inception');
      expect(movie.description, 'Mind-bending thriller');
      expect(movie.rating, MovieRating.b15);
      expect(movie.showTimes.length, 3);
      expect(movie.durationMinutes, 148);
    });
  });
}
