import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/venue.dart';
import '../models/payment.dart';
import '../core/constants/enums.dart';
import '../core/utils/validators.dart';
import '../providers/cart_provider.dart';

class BookingScreen extends StatefulWidget {
  final Venue venue;

  const BookingScreen({super.key, required this.venue});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _selectedDate;
  String? _selectedTime;
  dynamic _selectedEvent;
  int _ticketQuantity = 1;
  PaymentMethod? _selectedPaymentMethod;

  final _ccMask = MaskTextInputFormatter(
    mask: '#### #### #### ####',
    filter: {'#': RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.eager,
  );

  final _expiryMask = MaskTextInputFormatter(
    mask: '?#/##',
    filter: {'#': RegExp(r'[0-9]'), '?': RegExp(r'[0-1]')},
  );

  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardholderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardholderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, shrink) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.venue.name,
                style: TextStyle(color: !shrink ? Colors.white : Colors.black),
              ),
              background: CachedNetworkImage(
                imageUrl: widget.venue.img,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              _buildDateSelection(),
              if (_selectedDate != null) ...[
                const SizedBox(height: 16),
                _buildEventSelection(),
              ],
              if (_selectedEvent != null) ...[
                const SizedBox(height: 16),
                _buildTicketQuantitySelector(),
                const SizedBox(height: 16),
                _buildTotalAmount(),
                const SizedBox(height: 24),
                _buildPaymentMethodSelection(),
              ],
              if (_selectedPaymentMethod != null) ...[
                const SizedBox(height: 16),
                _buildPaymentForm(),
                const SizedBox(height: 24),
                _buildPurchaseButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecciona una fecha',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 90)),
                );

                if (date != null && widget.venue.isOperatingOnDate(date)) {
                  setState(() {
                    _selectedDate = date;
                    _selectedEvent = null;
                    _selectedTime = null;
                  });
                } else if (date != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'El venue no está disponible en esta fecha',
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: Text(
                _selectedDate == null
                    ? 'Seleccionar fecha'
                    : DateFormat('dd/MM/yyyy').format(_selectedDate!),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventSelection() {
    final events = _getEventsForVenue();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecciona un evento',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...events.map((event) {
              final isSelected = _selectedEvent == event;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedEvent = event;
                      _selectedTime = _getFirstShowTime(event);
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: isSelected
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                  ),
                  child: Text(_getEventTitle(event)),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketQuantitySelector() {
    final maxTickets = widget.venue.category == EventCategory.museum ? 5 : 10;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Cantidad de boletos',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: _ticketQuantity > 1
                      ? () => setState(() => _ticketQuantity--)
                      : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text(
                  '$_ticketQuantity',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: _ticketQuantity < maxTickets
                      ? () => setState(() => _ticketQuantity++)
                      : null,
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalAmount() {
    final price = _getTicketPrice();
    final total = price * _ticketQuantity;

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total a pagar',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '\$${total.toStringAsFixed(2)}',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Método de pago',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...PaymentMethod.values.map((method) {
              return RadioListTile<PaymentMethod>(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text(method.displayName)),
                    if (method != PaymentMethod.paypal) ...[
                      Row(
                        spacing: 4,
                        children: [
                          SvgPicture.network(
                            'https://cdn.svglogos.dev/logos/mastercard.svg',
                            width: 30,
                          ),
                          SvgPicture.network(
                            'https://cdn.svglogos.dev/logos/visa.svg',
                            width: 30,
                          ),
                        ],
                      ),
                    ] else ...[
                      SvgPicture.network(
                        'https://cdn.svglogos.dev/logos/paypal.svg',
                        height: 25,
                      ),
                    ],
                  ],
                ),
                value: method,
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() => _selectedPaymentMethod = value);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentForm() {
    return Form(
      key: _formKey,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detalles de pago',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              if (_selectedPaymentMethod == PaymentMethod.paypal) ...[
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email de PayPal',
                    border: OutlineInputBorder(),
                  ),
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (v) =>
                      Validators.validateNotEmpty(v, 'Contraseña'),
                ),
              ] else ...[
                TextFormField(
                  controller: _cardNumberController,
                  inputFormatters: [_ccMask],
                  decoration: const InputDecoration(
                    labelText: 'Número de tarjeta',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: Validators.validateCardNumber,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _cardholderController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del titular',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  validator: (v) => Validators.validateOnlyText(v, 'Nombre'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _expiryController,
                        inputFormatters: [_expiryMask],
                        decoration: const InputDecoration(
                          labelText: 'MM/AA',
                          hintText: '01/32',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: Validators.validateExpiryDate,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _cvvController,
                        decoration: const InputDecoration(
                          labelText: 'CVV',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: Validators.validateCVV,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPurchaseButton() {
    return FilledButton(
      onPressed: _processPurchase,
      child: const Text('Completar compra', style: TextStyle(fontSize: 18)),
    );
  }

  void _processPurchase() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cartProvider = context.read<CartProvider>();

    // Configurar el evento y fecha
    cartProvider.setEvent(_selectedEvent, _selectedDate!, _selectedTime!);

    // Agregar boletos
    final price = _getTicketPrice();
    for (int i = 0; i < _ticketQuantity; i++) {
      final success = cartProvider.addTicket(price: price);
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No hay suficientes boletos disponibles'),
          ),
        );
        return;
      }
    }

    // Configurar método de pago
    cartProvider.setPaymentMethod(_selectedPaymentMethod!);

    PaymentDetails paymentDetails;
    if (_selectedPaymentMethod == PaymentMethod.paypal) {
      paymentDetails = PayPalPaymentDetails(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } else {
      paymentDetails = CardPaymentDetails(
        cardNumber: _cardNumberController.text,
        cardholderName: _cardholderController.text,
        expiryDate: _expiryController.text,
        cvv: _cvvController.text,
      );
    }
    cartProvider.setPaymentDetails(paymentDetails);

    // Mostrar diálogo de procesamiento
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Completar compra
    final success = await cartProvider.completePurchase();

    Navigator.pop(context); // Cerrar diálogo de carga

    if (success) {
      _showSuccessDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al procesar el pago')),
      );
    }
  }

  Future<void> _showSuccessDialog() async {
    final cartProvider = context.read<CartProvider>();
    final tickets = cartProvider.tickets;

    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Aqui tienes tus boletos!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.confirmation_num),
                title: Text('Boleto para ${_getEventTitle(_selectedEvent)}'),
                subtitle: Text(
                  DateFormat.MMMMEEEEd().format(tickets.first.eventDate) +
                      ' $_selectedTime hrs.',
                ),
                trailing: Text('X${tickets.length}'),
              ),
              SizedBox(height: 16),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.network(
                  'https://api.qrserver.com/v1/create-qr-code/?size=100x100&data=TicketID-${tickets.first.id}',
                  width: 100,
                  height: 100,
                ),
              ),
              SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cerrar'),
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );

    if (mounted) {
      cartProvider.clearCart();
      Navigator.of(context).popUntil((route) => route.isFirst);
    }

    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: const Text('¡Compra exitosa!'),
    //     content: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text('Boletos comprados: ${tickets.length}'),
    //         Text(
    //           'Total pagado: \$${cartProvider.totalAmount.toStringAsFixed(2)}',
    //         ),
    //         const SizedBox(height: 16),
    //         if (widget.venue is Theater) ...[
    //           Text(
    //             'Código de vestimenta: ${(widget.venue as Theater).dressCode}',
    //           ),
    //         ] else if (widget.venue is Cinema) ...[
    //           const Text('Restricciones:'),
    //           ...(widget.venue as Cinema).restrictions
    //               .map((r) => Text('• $r'))
    //               .toList(),
    //         ] else if (widget.venue is Museum) ...[
    //           const Text('Restricciones de acceso:'),
    //           ...(widget.venue as Museum).accessRestrictions
    //               .map((r) => Text('• $r'))
    //               .toList(),
    //         ],
    //       ],
    //     ),
    //     actions: [
    //       TextButton(
    //         onPressed: () {
    //           cartProvider.clearCart();
    //           Navigator.of(context).popUntil((route) => route.isFirst);
    //         },
    //         child: const Text('Aceptar'),
    //       ),
    //     ],
    //   ),
    // );
  }

  List<dynamic> _getEventsForVenue() {
    if (widget.venue is Theater) {
      return (widget.venue as Theater).shows;
    } else if (widget.venue is Cinema) {
      return (widget.venue as Cinema).movies;
    }
    return ['Entrada al museo'];
  }

  String _getEventTitle(dynamic event) {
    if (event is TheaterShow) return event.title;
    if (event is Movie) return event.title;
    return event.toString();
  }

  String _getFirstShowTime(dynamic event) {
    if (event is TheaterShow) return event.showTimes.first;
    if (event is Movie) return event.showTimes.first;
    if (widget.venue is Museum) {
      return (widget.venue as Museum).entryTimes.first;
    }
    return '10:00';
  }

  double _getTicketPrice() {
    if (widget.venue is Theater) {
      return (widget.venue as Theater).getPriceForSection(
        TheaterSection.luneta,
      );
    } else if (widget.venue is Cinema) {
      return (widget.venue as Cinema).getPriceForService(
        CinemaServiceType.traditional,
      );
    } else if (widget.venue is Museum) {
      return (widget.venue as Museum).ticketPrice;
    }
    return 0.0;
  }
}
