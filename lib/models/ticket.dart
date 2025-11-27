import '../core/constants/enums.dart';

/// Modelo de boleto
class Ticket {
  final String id;
  final String venueId;
  final String venueName;
  final EventCategory category;
  final String eventId;
  final String eventName;
  final DateTime eventDate;
  final String eventTime;
  final double price;
  final Map<String, dynamic> details;

  Ticket({
    required this.id,
    required this.venueId,
    required this.venueName,
    required this.category,
    required this.eventId,
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.price,
    required this.details,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'venueId': venueId,
      'venueName': venueName,
      'category': category.toString(),
      'eventId': eventId,
      'eventName': eventName,
      'eventDate': eventDate.toIso8601String(),
      'eventTime': eventTime,
      'price': price,
      'details': details,
    };
  }

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      venueId: json['venueId'],
      venueName: json['venueName'],
      category: EventCategory.values.firstWhere(
        (e) => e.toString() == json['category'],
      ),
      eventId: json['eventId'],
      eventName: json['eventName'],
      eventDate: DateTime.parse(json['eventDate']),
      eventTime: json['eventTime'],
      price: json['price'],
      details: json['details'],
    );
  }
}

/// Boleto de teatro con información específica
class TheaterTicket extends Ticket {
  final TheaterSection section;
  final String dressCode;

  TheaterTicket({
    required super.id,
    required super.venueId,
    required super.venueName,
    required super.eventId,
    required super.eventName,
    required super.eventDate,
    required super.eventTime,
    required super.price,
    required this.section,
    required this.dressCode,
  }) : super(
          category: EventCategory.theater,
          details: {
            'section': section.displayName,
            'dressCode': dressCode,
          },
        );
}

/// Boleto de cine con información específica
class CinemaTicket extends Ticket {
  final CinemaServiceType serviceType;
  final String seatNumber;
  final MovieRating movieRating;

  CinemaTicket({
    required super.id,
    required super.venueId,
    required super.venueName,
    required super.eventId,
    required super.eventName,
    required super.eventDate,
    required super.eventTime,
    required super.price,
    required this.serviceType,
    required this.seatNumber,
    required this.movieRating,
  }) : super(
          category: EventCategory.cinema,
          details: {
            'serviceType': serviceType.displayName,
            'seatNumber': seatNumber,
            'movieRating': movieRating.displayName,
          },
        );
}

/// Boleto de museo con información específica
class MuseumTicket extends Ticket {
  final String entryTime;

  MuseumTicket({
    required super.id,
    required super.venueId,
    required super.venueName,
    required super.eventId,
    required super.eventName,
    required super.eventDate,
    required super.eventTime,
    required super.price,
    required this.entryTime,
  }) : super(
          category: EventCategory.museum,
          details: {
            'entryTime': entryTime,
          },
        );
}
