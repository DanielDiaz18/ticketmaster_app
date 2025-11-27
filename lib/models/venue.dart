import '../core/constants/enums.dart';

/// Modelo base para un venue (teatro, cine, museo)
class Venue {
  final String id;
  final String name;
  final String img;
  final String location;
  final EventCategory category;
  final int capacity;
  final Map<int, bool> operatingDays; // 1=Lunes, 7=Domingo
  final List<DateTime> holidays;
  final String openingTime;
  final String closingTime;

  Venue({
    required this.id,
    required this.name,
    required this.location,
    required this.category,
    required this.capacity,
    required this.operatingDays,
    required this.holidays,
    required this.openingTime,
    required this.closingTime,
    required this.img,
  });

  bool isOperatingOnDate(DateTime date) {
    // Verificar si es día festivo
    for (var holiday in holidays) {
      if (date.year == holiday.year &&
          date.month == holiday.month &&
          date.day == holiday.day) {
        return false;
      }
    }

    // Verificar si es día laborable (1=Lunes, 7=Domingo)
    int weekday = date.weekday;
    return operatingDays[weekday] ?? false;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'category': category.toString(),
      'capacity': capacity,
      'operatingDays': operatingDays,
      'holidays': holidays.map((d) => d.toIso8601String()).toList(),
      'openingTime': openingTime,
      'closingTime': closingTime,
    };
  }
}

/// Teatro específico con sus características
class Theater extends Venue {
  final Map<TheaterSection, double> sectionPrices;
  final List<TheaterShow> shows;
  final String dressCode;

  Theater({
    required super.id,
    required super.name,
    required super.location,
    required super.capacity,
    required super.operatingDays,
    required super.holidays,
    required super.openingTime,
    required super.closingTime,
    required super.img,
    required this.sectionPrices,
    required this.shows,
    required this.dressCode,
  }) : super(category: EventCategory.theater);

  double getPriceForSection(TheaterSection section) {
    return sectionPrices[section] ?? 0.0;
  }
}

/// Obra de teatro
class TheaterShow {
  final String id;
  final String title;
  final String description;
  final List<String> showTimes;
  final int durationMinutes;

  TheaterShow({
    required this.id,
    required this.title,
    required this.description,
    required this.showTimes,
    required this.durationMinutes,
  });
}

/// Cine específico
class Cinema extends Venue {
  final String chain; // Cinemark, Cinépolis, etc.
  final List<CinemaServiceType> availableServices;
  final Map<CinemaServiceType, double> servicePrices;
  final List<Movie> movies;
  final List<String> restrictions;

  Cinema({
    required super.id,
    required super.name,
    required super.location,
    required super.capacity,
    required super.operatingDays,
    required super.holidays,
    required super.openingTime,
    required super.closingTime,
    required super.img,
    required this.chain,
    required this.availableServices,
    required this.servicePrices,
    required this.movies,
    required this.restrictions,
  }) : super(category: EventCategory.cinema);

  bool hasService(CinemaServiceType service) {
    return availableServices.contains(service);
  }

  double getPriceForService(CinemaServiceType service) {
    return servicePrices[service] ?? 0.0;
  }
}

/// Película
class Movie {
  final String id;
  final String title;
  final String description;
  final MovieRating rating;
  final List<String> showTimes;
  final int durationMinutes;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.rating,
    required this.showTimes,
    required this.durationMinutes,
  });
}

/// Museo específico
class Museum extends Venue {
  final double ticketPrice;
  final List<String> accessRestrictions;
  final List<String> entryTimes;

  Museum({
    required super.id,
    required super.name,
    required super.location,
    required super.capacity,
    required super.operatingDays,
    required super.holidays,
    required super.openingTime,
    required super.closingTime,
    required super.img,
    required this.ticketPrice,
    required this.accessRestrictions,
    required this.entryTimes,
  }) : super(category: EventCategory.museum);
}
