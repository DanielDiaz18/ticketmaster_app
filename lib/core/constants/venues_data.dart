import '../../models/venue.dart';
import 'enums.dart';

/// Días festivos comunes (2025)
final List<DateTime> commonHolidays2025 = [
  DateTime(2025, 1, 1), // Año Nuevo
  DateTime(2025, 12, 25), // Navidad
];

/// Días laborables estándar (Lunes a Domingo)
final Map<int, bool> standardOperatingDays = {
  1: true, // Lunes
  2: true, // Martes
  3: true, // Miércoles
  4: true, // Jueves
  5: true, // Viernes
  6: true, // Sábado
  7: true, // Domingo
};

/// Días laborables sin domingo
final Map<int, bool> mondayToSaturday = {
  1: true,
  2: true,
  3: true,
  4: true,
  5: true,
  6: true,
  7: false,
};

// ============================================================================
// TEATROS
// ============================================================================

final Theater teatroColon = Theater(
  id: 'theater_colon',
  img:
      'https://imgs.search.brave.com/YbjmNf7gs0xJF5AoWz1bGZu-usPbrFRZw53NYuBdQ_o/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5nZXR0eWltYWdl/cy5jb20vaWQvMTIy/MDYxNjkxNi9lcy9m/b3RvL2J1ZW5vcy1h/aXJlcy1hcmdlbnRp/bmEtZnJvbnQtdmll/dy1vZi10ZWF0cm8t/Y29sb24tb24tYXBy/aWwtMjMtMjAyMC1p/bi1idWVub3MtYWly/ZXMtYXJnZW50aW5h/LmpwZz9zPTYxMng2/MTImdz0wJms9MjAm/Yz1hc1lrU3diNHR5/Z0RxdENiSjVFRG9k/aFg3X1dCSGN3blp1/a3VwbUhUeXBRPQ',
  name: 'Teatro Colón',
  location: 'Buenos Aires, Argentina',
  capacity: 2478,
  operatingDays: mondayToSaturday,
  holidays: [
    ...commonHolidays2025,
    DateTime(2025, 5, 25), // Revolución de Mayo
    DateTime(2025, 7, 9), // Independencia de Argentina
  ],
  openingTime: '14:00',
  closingTime: '23:00',
  sectionPrices: {
    TheaterSection.luneta: 150.0,
    TheaterSection.palco: 250.0,
    TheaterSection.balcon: 100.0,
    TheaterSection.general: 80.0,
  },
  shows: [
    TheaterShow(
      id: 'show_colon_1',
      title: 'La Traviata',
      description: 'Ópera de Giuseppe Verdi',
      showTimes: ['19:00', '21:30'],
      durationMinutes: 180,
    ),
    TheaterShow(
      id: 'show_colon_2',
      title: 'El Lago de los Cisnes',
      description: 'Ballet clásico de Tchaikovsky',
      showTimes: ['18:00', '20:30'],
      durationMinutes: 150,
    ),
    TheaterShow(
      id: 'show_colon_3',
      title: 'Carmen',
      description: 'Ópera de Georges Bizet',
      showTimes: ['19:30'],
      durationMinutes: 165,
    ),
  ],
  dressCode: 'Formal - Traje o vestido elegante',
);

final Theater teatroScala = Theater(
  id: 'theater_scala',
  img:
      'https://imgs.search.brave.com/ckoCp3kxQIX8OxFygBavSGyvCiVzbRGeE-lfv6uBMEc/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90cmlw/YWltLmNvbS9ibG9n/L3dwLWNvbnRlbnQv/dXBsb2Fkcy8yMDIx/LzEyL1RlYXRyby1M/YS1TY2FsYS1kZS1N/aWxhbi5qcGc',
  name: 'Teatro de la Scala',
  location: 'Milán, Italia',
  capacity: 2030,
  operatingDays: mondayToSaturday,
  holidays: [
    ...commonHolidays2025,
    DateTime(2025, 4, 25), // Día de la Liberación (Italia)
    DateTime(2025, 6, 2), // Día de la República (Italia)
  ],
  openingTime: '14:00',
  closingTime: '23:30',
  sectionPrices: {
    TheaterSection.luneta: 200.0,
    TheaterSection.palco: 350.0,
    TheaterSection.balcon: 120.0,
    TheaterSection.general: 90.0,
  },
  shows: [
    TheaterShow(
      id: 'show_scala_1',
      title: 'Rigoletto',
      description: 'Ópera de Giuseppe Verdi',
      showTimes: ['19:00', '21:00'],
      durationMinutes: 170,
    ),
    TheaterShow(
      id: 'show_scala_2',
      title: 'La Bohème',
      description: 'Ópera de Giacomo Puccini',
      showTimes: ['18:30', '21:30'],
      durationMinutes: 140,
    ),
    TheaterShow(
      id: 'show_scala_3',
      title: 'Tosca',
      description: 'Ópera de Giacomo Puccini',
      showTimes: ['20:00'],
      durationMinutes: 155,
    ),
  ],
  dressCode: 'Etiqueta - Esmoquin o vestido de gala',
);

final Theater teatroMetropolitan = Theater(
  id: 'theater_metropolitan',
  img:
      'https://imgs.search.brave.com/FxDZXNtJ3sujV9Zg5IfM2c3noiU6w2ENHeC8Xryj_Dw/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9lMDEt/cGhhbnRvbS1tYXJj/YS1teC51ZWNkbi5l/cy81MmZlZmFkZmRk/YmRkNDdmOWQ3Y2Vh/NTUzYTliYWE4My9y/ZXNpemUvMTMyMC9m/L2pwZy9teC9hc3Nl/dHMvbXVsdGltZWRp/YS9pbWFnZW5lcy8y/MDI1LzA0LzAxLzE3/NDM1MjkyNzk4NzM1/LmpwZw',
  name: 'Teatro Metropólitan',
  location: 'Ciudad de México, México',
  capacity: 3000,
  operatingDays: standardOperatingDays,
  holidays: [
    ...commonHolidays2025,
    DateTime(2025, 9, 16), // Independencia de México
    DateTime(2025, 11, 20), // Revolución Mexicana
  ],
  openingTime: '12:00',
  closingTime: '00:00',
  sectionPrices: {
    TheaterSection.luneta: 120.0,
    TheaterSection.palco: 200.0,
    TheaterSection.balcon: 80.0,
    TheaterSection.general: 60.0,
  },
  shows: [
    TheaterShow(
      id: 'show_metro_1',
      title: 'Romeo y Julieta',
      description: 'Obra clásica de William Shakespeare',
      showTimes: ['18:00', '21:00'],
      durationMinutes: 140,
    ),
    TheaterShow(
      id: 'show_metro_2',
      title: 'Don Juan Tenorio',
      description: 'Drama romántico de José Zorrilla',
      showTimes: ['19:00'],
      durationMinutes: 160,
    ),
    TheaterShow(
      id: 'show_metro_3',
      title: 'La Casa de Bernarda Alba',
      description: 'Drama de Federico García Lorca',
      showTimes: ['20:00', '22:00'],
      durationMinutes: 130,
    ),
  ],
  dressCode: 'Semi-formal - Ropa elegante casual',
);

final List<Theater> allTheaters = [
  teatroColon,
  teatroScala,
  teatroMetropolitan,
];

// ============================================================================
// CINES
// ============================================================================

final Cinema cinemark = Cinema(
  id: 'cinema_cinemark',
  img:
      'https://imgs.search.brave.com/dKnEYzX6mbOQ0Pvhe87bKgyaeroH8H_3acwB1uZKzKU/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9jZG4u/Zm9yYmVzLmNvbS5t/eC8yMDEzLzA4L2Np/bmVtYXJrMS5qcGc',
  name: 'Cinemark',
  location: 'Ciudad de México, México',
  chain: 'Cinemark',
  capacity: 250,
  operatingDays: standardOperatingDays,
  holidays: commonHolidays2025,
  openingTime: '10:00',
  closingTime: '00:00',
  availableServices: [
    CinemaServiceType.traditional,
    CinemaServiceType.vip,
    CinemaServiceType.imax,
    CinemaServiceType.fourDX,
  ],
  servicePrices: {
    CinemaServiceType.traditional: 80.0,
    CinemaServiceType.vip: 150.0,
    CinemaServiceType.imax: 120.0,
    CinemaServiceType.fourDX: 180.0,
  },
  movies: [
    Movie(
      id: 'movie_cm_1',
      title: 'Aventura Espacial',
      description: 'Ciencia ficción épica',
      rating: MovieRating.b,
      showTimes: ['12:00', '15:00', '18:00', '21:00'],
      durationMinutes: 150,
    ),
    Movie(
      id: 'movie_cm_2',
      title: 'Comedia Familiar',
      description: 'Diversión para toda la familia',
      rating: MovieRating.aa,
      showTimes: ['11:00', '14:00', '17:00', '20:00'],
      durationMinutes: 105,
    ),
  ],
  restrictions: [
    'No se permiten mascotas',
    'No se permiten armas',
    'No se permiten alimentos externos',
  ],
);

final Cinema cinepolis = Cinema(
  id: 'cinema_cinepolis',
  img:
      'https://imgs.search.brave.com/atrx2Hj8RMcONdiSbuP2CJv6BP0VphQ5m5-dNkHTwbU/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pLnBp/bmltZy5jb20vb3Jp/Z2luYWxzLzM0Lzgz/LzYzLzM0ODM2M2Rl/YmY0OTg2MGM0ODg3/ZDMzNGEyODllNzNl/LmpwZw',
  name: 'Cinépolis',
  location: 'Ciudad de México, México',
  chain: 'Cinépolis',
  capacity: 300,
  operatingDays: standardOperatingDays,
  holidays: commonHolidays2025,
  openingTime: '09:00',
  closingTime: '01:00',
  availableServices: [
    CinemaServiceType.traditional,
    CinemaServiceType.pluus,
    CinemaServiceType.vip,
    CinemaServiceType.macroXE,
    CinemaServiceType.cinepolisJunior,
    CinemaServiceType.fourDX,
    CinemaServiceType.imax,
  ],
  servicePrices: {
    CinemaServiceType.traditional: 75.0,
    CinemaServiceType.pluus: 120.0,
    CinemaServiceType.vip: 180.0,
    CinemaServiceType.macroXE: 140.0,
    CinemaServiceType.cinepolisJunior: 60.0,
    CinemaServiceType.fourDX: 200.0,
    CinemaServiceType.imax: 130.0,
  },
  movies: [
    Movie(
      id: 'movie_cp_1',
      title: 'Thriller Misterioso',
      description: 'Suspenso y misterio',
      rating: MovieRating.b15,
      showTimes: ['13:00', '16:00', '19:00', '22:00'],
      durationMinutes: 125,
    ),
    Movie(
      id: 'movie_cp_2',
      title: 'Animación Mágica',
      description: 'Aventura animada',
      rating: MovieRating.aa,
      showTimes: ['10:00', '12:30', '15:00', '17:30', '20:00'],
      durationMinutes: 95,
    ),
  ],
  restrictions: [
    'No se permiten mascotas',
    'No se permiten armas',
    'No se permiten alimentos externos',
  ],
);

final Cinema cinemex = Cinema(
  id: 'cinema_cinemex',
  img:
      'https://imgs.search.brave.com/iWtXxm1-H-sYw9r5mjmDDXAXyr4e31DBFBLQoEDOlzw/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zLnlp/bWcuY29tL255L2Fw/aS9yZXMvMS4yLzdw/U2dncXVycE9SN05T/ZDZCYnNPcVEtLS9Z/WEJ3YVdROWFHbG5h/R3hoYm1SbGNqdDNQ/VEV5TkRJN2FEMDNO/alE3WTJZOWQyVmlj/QS0tL2h0dHBzOi8v/bWVkaWEuemVuZnMu/Y29tL2VzL3NhbmRp/ZWdvcmVkXzg4My8w/NjQ2OGQ2N2ZhZDBj/MjFkZjQxMjkyMTk1/MDdjOWRiYQ',
  name: 'Cinemex',
  location: 'Ciudad de México, México',
  chain: 'Cinemex',
  capacity: 280,
  operatingDays: standardOperatingDays,
  holidays: commonHolidays2025,
  openingTime: '10:00',
  closingTime: '00:30',
  availableServices: [
    CinemaServiceType.traditional,
    CinemaServiceType.vip,
    CinemaServiceType.imax,
    CinemaServiceType.screenX,
  ],
  servicePrices: {
    CinemaServiceType.traditional: 78.0,
    CinemaServiceType.vip: 160.0,
    CinemaServiceType.imax: 125.0,
    CinemaServiceType.screenX: 150.0,
  },
  movies: [
    Movie(
      id: 'movie_cx_1',
      title: 'Acción Extrema',
      description: 'Acción y adrenalina',
      rating: MovieRating.c,
      showTimes: ['14:00', '17:00', '20:00', '23:00'],
      durationMinutes: 135,
    ),
    Movie(
      id: 'movie_cx_2',
      title: 'Drama Histórico',
      description: 'Basada en hechos reales',
      rating: MovieRating.b,
      showTimes: ['11:00', '14:30', '18:00', '21:30'],
      durationMinutes: 155,
    ),
  ],
  restrictions: [
    'No se permiten mascotas',
    'No se permiten armas',
    'No se permiten alimentos externos',
  ],
);

final Cinema amc = Cinema(
  id: 'cinema_amc',
  img:
      'https://imgs.search.brave.com/qM8SsoSm4bTGQGDgDzveA5Bcy8SQuQpJkjntHW6w0OI/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9jNy5h/bGFteS5jb20vY29t/cC8yRDhKMk05L2Ns/b3NlZC1yZWdhbC1h/bmQtYW1jLWVtcGly/ZS0yNS1jaW5lbWFz/LWluLXRpbWVzLXNx/dWFyZS1pbi1uZXct/eW9yay1kdWUtdG8t/dGhlLWNvdmlkLTE5/LXBhbmRlbWljLW9u/LXNhdHVyZGF5LW9j/dG9iZXItMjQtMjAy/MC1yaWNoYXJkLWIt/bGV2aW5lLTJEOEoy/TTkuanBn',
  name: 'AMC',
  location: 'Ciudad de México, México',
  chain: 'AMC',
  capacity: 320,
  operatingDays: standardOperatingDays,
  holidays: commonHolidays2025,
  openingTime: '09:30',
  closingTime: '01:00',
  availableServices: [
    CinemaServiceType.traditional,
    CinemaServiceType.vip,
    CinemaServiceType.imax,
    CinemaServiceType.vr,
  ],
  servicePrices: {
    CinemaServiceType.traditional: 82.0,
    CinemaServiceType.vip: 170.0,
    CinemaServiceType.imax: 135.0,
    CinemaServiceType.vr: 190.0,
  },
  movies: [
    Movie(
      id: 'movie_amc_1',
      title: 'Terror Nocturno',
      description: 'Horror psicológico',
      rating: MovieRating.c,
      showTimes: ['15:00', '18:00', '21:00', '00:00'],
      durationMinutes: 110,
    ),
    Movie(
      id: 'movie_amc_2',
      title: 'Romance Inolvidable',
      description: 'Historia de amor',
      rating: MovieRating.b,
      showTimes: ['12:00', '15:30', '19:00', '22:00'],
      durationMinutes: 120,
    ),
  ],
  restrictions: [
    'No se permiten mascotas',
    'No se permiten armas',
    'No se permiten alimentos externos',
  ],
);

final List<Cinema> allCinemas = [cinemark, cinepolis, cinemex, amc];

// ============================================================================
// MUSEOS
// ============================================================================

final Museum museoLouvre = Museum(
  id: 'museum_louvre',
  img:
      'https://imgs.search.brave.com/dhtWQDxMaqc9mWsvIIOhuo727CntCo3Gx6Usa0BkVtA/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pY2hl/Zi5iYmNpLmNvLnVr/L2FjZS93cy82NDAv/Y3BzcHJvZHBiL2Y3/YWYvbGl2ZS9lY2E1/MGNkMC1iMTM4LTEx/ZjAtYjlmZC0wOTIy/YWU4MDk4NGUuanBn/LndlYnA',
  name: 'Museo del Louvre',
  location: 'París, Francia',
  capacity: 30000,
  operatingDays: {
    1: false, // Cerrado los lunes
    2: true,
    3: true,
    4: true,
    5: true,
    6: true,
    7: true,
  },
  holidays: [
    ...commonHolidays2025,
    DateTime(2025, 7, 14), // Día de la Bastilla
    DateTime(2025, 5, 1), // Día del Trabajo
  ],
  openingTime: '09:00',
  closingTime: '18:00',
  ticketPrice: 17.0,
  accessRestrictions: [
    'No se permiten mochilas grandes',
    'No se permite flash en fotografías',
    'Silencio en las salas',
  ],
  entryTimes: [
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
  ],
);

final Museum museoMetropolitano = Museum(
  id: 'museum_met',
  img:
      'https://imgs.search.brave.com/Pd_MtGnOzFVepv9edet8DQffz26qWU9mQLAXOor31QA/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly92aWFq/b25hcmlvcy5jb20v/d3AtY29udGVudC91/cGxvYWRzLzIwMTgv/MDcvbWV0NDctNjMw/eDQyMC5qcGc',
  name: 'Museo Metropolitano de Arte',
  location: 'Nueva York, Estados Unidos',
  capacity: 25000,
  operatingDays: standardOperatingDays,
  holidays: [
    ...commonHolidays2025,
    DateTime(2025, 7, 4), // Día de la Independencia (EE.UU.)
    DateTime(2025, 11, 27), // Thanksgiving
  ],
  openingTime: '10:00',
  closingTime: '17:00',
  ticketPrice: 30.0,
  accessRestrictions: [
    'No se permiten bebidas',
    'No se permite tocar las obras',
    'Se requiere silencio',
  ],
  entryTimes: ['10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00'],
);

final Museum museoVaticano = Museum(
  id: 'museum_vatican',
  img:
      'https://imgs.search.brave.com/GJz506AQdMiWJRXEUXxjAdfAYwWRMgtK8vtvs3b56oU/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9tZWRp/YS5nZXR0eWltYWdl/cy5jb20vaWQvMjAw/MzY2NTA1LTAwMS9l/cy9mb3RvL2JyYW1h/bnRlcy1zdGFpcmNh/c2UtdmF0aWNhbi1t/dXNldW0tb3Zlcmhl/YWQtdmlldy5qcGc_/cz02MTJ4NjEyJnc9/MCZrPTIwJmM9ekxF/TTRhb0hjcFh2NThD/dTRtZmxyX0dIUGxU/anRpbTg2NlVhakQz/SmZpOD0',
  name: 'Museo Vaticano',
  location: 'Ciudad del Vaticano',
  capacity: 20000,
  operatingDays: {
    1: true,
    2: true,
    3: true,
    4: true,
    5: true,
    6: true,
    7: false, // Cerrado los domingos (excepto último domingo del mes)
  },
  holidays: [
    ...commonHolidays2025,
    DateTime(2025, 4, 20), // Domingo de Pascua
    DateTime(2025, 6, 29), // San Pedro y San Pablo
  ],
  openingTime: '09:00',
  closingTime: '18:00',
  ticketPrice: 17.0,
  accessRestrictions: [
    'Vestimenta apropiada (hombros y rodillas cubiertas)',
    'No se permite hablar en voz alta',
    'No se permiten alimentos',
  ],
  entryTimes: ['09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00'],
);

final Museum museoAntropologia = Museum(
  id: 'museum_antropologia',
  img:
      'https://imgs.search.brave.com/rLzp5lVBX-PfL83B_MYfgmqgeuer2mn7yGVtkVpQuB4/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9hLnRy/YXZlbC1hc3NldHMu/Y29tL2ZpbmR5b3Vy/cy1waHAvdmlld2Zp/bmRlci9pbWFnZXMv/cmVzNDAvMTY4MDAw/LzE2ODUwOC1NdXNl/by1OYWNpb25hbC1E/ZS1BbnRyb3BvbG9n/aWEuanBn',
  name: 'Museo Nacional de Antropología',
  location: 'Ciudad de México, México',
  capacity: 15000,
  operatingDays: {
    1: false, // Cerrado los lunes
    2: true,
    3: true,
    4: true,
    5: true,
    6: true,
    7: true,
  },
  holidays: [
    ...commonHolidays2025,
    DateTime(2025, 9, 16), // Independencia de México
  ],
  openingTime: '09:00',
  closingTime: '19:00',
  ticketPrice: 90.0,
  accessRestrictions: [
    'No se permite flash en fotografías',
    'No se permiten mochilas grandes',
    'Mantener distancia de las vitrinas',
  ],
  entryTimes: [
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
  ],
);

final Museum museuCatalunya = Museum(
  id: 'museum_catalunya',
  img:
      'https://imgs.search.brave.com/dGCEPYoLxUGGY_K8WSApciqTLTp3yi8jnw1lhmeeQ5Y/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93d3cu/YmFyY2Vsby5jb20v/Z3VpYS10dXJpc21v/L3dwLWNvbnRlbnQv/dXBsb2Fkcy8yMDE5/LzA1L211c2VvLW5h/Y2lvbmFsLWRlLWFy/dGUtZGUtY2F0YWx1/bnlhXzg4OC5qcGc',
  name: "Museu Nacional d'Art de Catalunya",
  location: 'Barcelona, España',
  capacity: 12000,
  operatingDays: {
    1: false, // Cerrado los lunes
    2: true,
    3: true,
    4: true,
    5: true,
    6: true,
    7: true,
  },
  holidays: [
    ...commonHolidays2025,
    DateTime(2025, 9, 11), // Diada Nacional de Catalunya
  ],
  openingTime: '10:00',
  closingTime: '18:00',
  ticketPrice: 12.0,
  accessRestrictions: [
    'No se permite comer o beber',
    'No tocar las obras de arte',
    'Fotografías sin flash',
  ],
  entryTimes: [
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
  ],
);

final List<Museum> allMuseums = [
  museoLouvre,
  museoMetropolitano,
  museoVaticano,
  museoAntropologia,
  museuCatalunya,
];
