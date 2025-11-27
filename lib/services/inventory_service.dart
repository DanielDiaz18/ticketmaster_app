import '../models/venue.dart';

/// Servicio para gestionar el inventario de boletos
class InventoryService {
  // Simulación de inventario en memoria
  // En producción, esto vendría de una base de datos
  final Map<String, int> _inventory = {};

  InventoryService() {
    _initializeInventory();
  }

  void _initializeInventory() {
    // Inicializar inventario con capacidades de los venues
    // En producción, esto vendría de una base de datos
  }

  /// Obtiene la cantidad disponible de boletos para un venue y fecha
  int getAvailableTickets(String venueId, DateTime date, String eventId) {
    final key = _getInventoryKey(venueId, date, eventId);
    return _inventory[key] ?? 0;
  }

  /// Reserva boletos temporalmente (antes de completar el pago)
  bool reserveTickets(String venueId, DateTime date, String eventId, int quantity) {
    final key = _getInventoryKey(venueId, date, eventId);
    final available = _inventory[key] ?? 0;

    if (available >= quantity) {
      _inventory[key] = available - quantity;
      return true;
    }
    return false;
  }

  /// Libera boletos reservados (si se cancela la compra)
  void releaseTickets(String venueId, DateTime date, String eventId, int quantity) {
    final key = _getInventoryKey(venueId, date, eventId);
    final current = _inventory[key] ?? 0;
    _inventory[key] = current + quantity;
  }

  /// Confirma la venta de boletos (después del pago exitoso)
  void confirmSale(String venueId, DateTime date, String eventId, int quantity) {
    // En este caso, los boletos ya están descontados del inventario
    // Esta función registraría la venta en una base de datos
  }

  /// Inicializa el inventario para un venue específico
  void initializeVenueInventory(Venue venue, DateTime date, String eventId) {
    final key = _getInventoryKey(venue.id, date, eventId);
    if (!_inventory.containsKey(key)) {
      _inventory[key] = venue.capacity;
    }
  }

  String _getInventoryKey(String venueId, DateTime date, String eventId) {
    return '$venueId-${date.toIso8601String().split('T')[0]}-$eventId';
  }

  /// Limpia el inventario (solo para testing)
  void clearInventory() {
    _inventory.clear();
  }
}
