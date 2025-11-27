/// Categorías de eventos disponibles
enum EventCategory {
  theater,
  cinema,
  museum,
}

/// Métodos de pago soportados
enum PaymentMethod {
  debitCard,
  creditCard,
  paypal,
}

/// Tipos de servicio de cine
enum CinemaServiceType {
  traditional,
  pluus,
  vip,
  macroXE,
  cinepolisJunior,
  fourDX,
  imax,
  vr,
  screenX,
}

/// Secciones de teatro
enum TheaterSection {
  luneta,
  palco,
  balcon,
  general,
}

/// Clasificación de películas
enum MovieRating {
  aa, // Todas las edades
  a, // Adolescentes
  b, // Adolescentes con reservas
  b15, // Mayores de 15 años
  c, // Adultos
  d, // Solo adultos
}

extension EventCategoryExtension on EventCategory {
  String get displayName {
    switch (this) {
      case EventCategory.theater:
        return 'Teatro';
      case EventCategory.cinema:
        return 'Cine';
      case EventCategory.museum:
        return 'Museo';
    }
  }
}

extension PaymentMethodExtension on PaymentMethod {
  String get displayName {
    switch (this) {
      case PaymentMethod.debitCard:
        return 'Tarjeta de Débito';
      case PaymentMethod.creditCard:
        return 'Tarjeta de Crédito';
      case PaymentMethod.paypal:
        return 'PayPal';
    }
  }
}

extension CinemaServiceTypeExtension on CinemaServiceType {
  String get displayName {
    switch (this) {
      case CinemaServiceType.traditional:
        return 'Tradicional';
      case CinemaServiceType.pluus:
        return 'PLUUS';
      case CinemaServiceType.vip:
        return 'VIP';
      case CinemaServiceType.macroXE:
        return 'Macro XE';
      case CinemaServiceType.cinepolisJunior:
        return 'Cinépolis Junior';
      case CinemaServiceType.fourDX:
        return '4DX';
      case CinemaServiceType.imax:
        return 'IMAX';
      case CinemaServiceType.vr:
        return 'VR';
      case CinemaServiceType.screenX:
        return 'Screen X';
    }
  }
}

extension TheaterSectionExtension on TheaterSection {
  String get displayName {
    switch (this) {
      case TheaterSection.luneta:
        return 'Luneta';
      case TheaterSection.palco:
        return 'Palco';
      case TheaterSection.balcon:
        return 'Balcón';
      case TheaterSection.general:
        return 'General';
    }
  }
}

extension MovieRatingExtension on MovieRating {
  String get displayName {
    switch (this) {
      case MovieRating.aa:
        return 'AA - Todas las edades';
      case MovieRating.a:
        return 'A - Adolescentes';
      case MovieRating.b:
        return 'B - Adolescentes con reservas';
      case MovieRating.b15:
        return 'B15 - Mayores de 15 años';
      case MovieRating.c:
        return 'C - Adultos';
      case MovieRating.d:
        return 'D - Solo adultos';
    }
  }
}
