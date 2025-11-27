import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/enums.dart';
import '../core/constants/venues_data.dart';
import '../models/venue.dart';
import '../providers/cart_provider.dart';
import 'booking_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int _currentIndex = 0;

  EventCategory get category => EventCategory.values[_currentIndex];

  @override
  Widget build(BuildContext context) {
    final venues = _getVenuesForCategory();

    return Scaffold(
      appBar: AppBar(title: Text(category.displayName)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: venues.length,
        itemBuilder: (context, index) {
          final venue = venues[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Image(
                    image: NetworkImage(venue.img),
                    fit: BoxFit.cover,
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    venue.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(venue.location),
                      const SizedBox(height: 4),
                      Text(
                        'Capacidad: ${venue.capacity}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(
                        'Horario: ${venue.openingTime} - ${venue.closingTime}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    final cartProvider = context.read<CartProvider>();
                    cartProvider.setVenue(venue);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingScreen(venue: venue),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        currentIndex: _currentIndex,
        items: EventCategory.values.map((cat) {
          return BottomNavigationBarItem(
            icon: Icon(switch (cat) {
              EventCategory.theater => Icons.theater_comedy,
              EventCategory.cinema => Icons.movie,
              EventCategory.museum => Icons.museum,
            }),
            label: cat.displayName,
          );
        }).toList(),
      ),
    );
  }

  List<Venue> _getVenuesForCategory() {
    switch (category) {
      case EventCategory.theater:
        return allTheaters.cast<Venue>();
      case EventCategory.cinema:
        return allCinemas.cast<Venue>();
      case EventCategory.museum:
        return allMuseums.cast<Venue>();
    }
  }
}
