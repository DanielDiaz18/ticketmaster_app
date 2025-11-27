# TicketMaster App - Sistema de Venta de Boletos

Aplicación móvil Flutter para la venta de boletos de eventos artísticos (Teatro, Cine, Museos) con validaciones de negocio, sistema de pagos, pruebas unitarias y métricas de analytics.


## Demo

<video src="assets/demo.mp4" width="400" controls>
  Your browser does not support the video tag.
</video>


## Tests

<video src="assets/tests.mp4" width="400" controls>
  Your browser does not support the video tag.
</video>

## Analytics

![Analytics](https://raw.githubusercontent.com/DanielDiaz18/ticketmaster_app/main/assets/analytics.png)




---
## 📋 Características

### Categorías de Eventos
- **Teatro**: 3 teatros internacionales con obras clásicas
- **Cine**: 4 cadenas de cine con múltiples formatos de proyección
- **Museo**: 5 museos reconocidos mundialmente

### Funcionalidades Principales
- ✅ Selección de venue por categoría
- ✅ Validación de días festivos y horarios de operación
- ✅ Gestión de capacidad e inventario de boletos
- ✅ Múltiples métodos de pago (Tarjeta de débito, crédito, PayPal)
- ✅ Validaciones de entrada de datos (solo texto, solo números)
- ✅ Límites de compra por usuario (10 boletos teatro/cine, 5 museo)
- ✅ Sistema de analytics para tracking de eventos
- ✅ Cálculo de métricas (conversión, venues populares, métodos de pago)

### Teatros Incluidos
1. **Teatro Colón** - Buenos Aires, Argentina
2. **Teatro de la Scala** - Milán, Italia
3. **Teatro Metropolitán** - Ciudad de México, México

### Cines Incluidos
1. **Cinemark**
2. **Cinépolis**
3. **Cinemex**
4. **AMC**

### Museos Incluidos
1. **Museo del Louvre** - París, Francia
2. **Museo Metropolitano de Arte** - Nueva York, EE.UU.
3. **Museo Vaticano** - Ciudad del Vaticano
4. **Museo Nacional de Antropología** - Ciudad de México, México
5. **Museu Nacional d'Art de Catalunya** - Barcelona, España

## 🏗️ Arquitectura

### Estructura del Proyecto
```
lib/
├── core/
│   ├── analytics/          # Servicio de analytics
│   ├── constants/          # Enums y datos de venues
│   └── utils/              # Validadores y utilidades
├── models/                 # Modelos de datos
│   ├── venue.dart
│   ├── ticket.dart
│   └── payment.dart
├── services/               # Lógica de negocio
│   └── inventory_service.dart
├── providers/              # Gestión de estado
│   └── cart_provider.dart
├── screens/                # Pantallas
│   ├── home_screen.dart
│   ├── category_screen.dart
│   └── booking_screen.dart
└── main.dart

test/
├── validators/             # Tests de validadores
└── services/               # Tests de servicios
```

### Tecnologías Utilizadas
- **Flutter 3.38.3**: Framework principal
- **Provider**: Gestión de estado
- **Analytics**: Tracking de eventos y métricas
- **Intl**: Formateo de fechas
- **UUID**: Generación de IDs únicos

## 🚀 Instalación

### Requisitos
- Flutter 3.38.3+
- Dart 3.10.1+

### Pasos
```bash
cd ticketmaster_app
flutter pub get
flutter run
```

### Ejecutar Pruebas
```bash
flutter test
```

## 📊 Sistema de Analytics

### Eventos Trackeados
- Apertura de app
- Selección de categoría
- Selección de venue
- Selección de evento
- Cambio de cantidad de boletos
- Selección de método de pago
- Compra completada/cancelada
- Errores de validación

### Métricas Disponibles
- Tasa de conversión por categoría
- Venues más populares
- Métodos de pago más usados
- Tiempo promedio de compra
- Total de revenue

## 🎯 Reglas de Negocio

### Teatro
- Máximo 10 boletos por usuario
- Secciones: Luneta, Palco, Balcón, General
- Código de vestimenta requerido
- No venta en días festivos

### Cine
- Máximo 10 boletos por usuario
- Restricciones: No mascotas, armas, alimentos externos
- Clasificación de películas
- Tipos de servicio varían por cine

### Museo
- Máximo 5 boletos por usuario
- Restricciones de acceso específicas
- Horarios de entrada definidos
- No venta en días festivos

## 🧪 Pruebas Unitarias

El proyecto incluye pruebas para:
- Validadores (tarjetas, email, texto, números)
- Analytics Service (eventos, métricas, conversión)
- Reglas de negocio

Cobertura de código: >80%

## 📱 Flujo de la Aplicación

1. Selección de categoría (Teatro/Cine/Museo)
2. Selección de venue
3. Selección de fecha y evento
4. Configuración de cantidad de boletos
5. Selección y validación de método de pago
6. Confirmación de compra

## 🔄 Gestión de Estado

- **CartProvider**: Carrito de compras y proceso de pago
- **AnalyticsService**: Tracking de eventos
- **InventoryService**: Gestión de inventario

## 📝 Validaciones Implementadas

- ✅ Días laborables y festivos
- ✅ Capacidad del venue
- ✅ Límite de boletos por usuario
- ✅ Métodos de pago
- ✅ Entrada de datos (texto/números)
- ✅ Tarjetas (número, CVV, expiración)
- ✅ Disponibilidad de servicios

## 📄 Licencia

Proyecto desarrollado con propósitos educativos para la clase de Pruebas de Software.

---

**Nota**: Aplicación de demostración con datos ficticios. No se realizan transacciones reales.
