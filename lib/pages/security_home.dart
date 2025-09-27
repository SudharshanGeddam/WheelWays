import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wheelways/models/user_provider.dart';
import 'package:wheelways/widgets/paginated_list_screen_allocated_bikes.dart';

import 'package:wheelways/widgets/paginated_list_screen_available_bikes_security.dart';
import 'package:wheelways/widgets/paginated_list_screen_damaged_bikes.dart';
import 'package:wheelways/widgets/paginated_list_screen_returned_bikes.dart';

class SecurityHome extends ConsumerStatefulWidget {
  const SecurityHome({super.key});

  @override
  ConsumerState<SecurityHome> createState() => _SecurityHomeState();
}

class _SecurityHomeState extends ConsumerState<SecurityHome> {
  Widget? _currentScreen;

  final List<String> filters = [
    'Available Bikes',
    'Bike Allocated',
    'Return Requests',
    'Damaged',
  ];
  late String _selectedFilter;

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _bikeLocation = TextEditingController();
  List<String> selectedColor = ['Red', 'Blue', 'Black', 'Green'];
  String? choosenColor;

  @override
  void initState() {
    super.initState();
    _selectedFilter = filters[0];
    _onFilterSelection(_selectedFilter);
  }

  Future<void> storeBikeDetails(
    String bikeId,
    String bikeColor,
    String location,
  ) async {
    try {
      final DocumentReference bikeRef = db.collection('BikesData').doc(bikeId);
      final DocumentSnapshot bikeSnapshot = await bikeRef.get();

      if (!mounted) return;

      if (bikeSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bike with this ID already exists.')),
        );
      } else {
        await bikeRef.set({
          'bikeId': bikeId,
          'bikeColor': bikeColor,
          'bikeLocation': location,
          'isAllocated': false,
          'isDamaged': false,
          'isReturned': false,
          'allocatedTo': '',
          'returnBy': '',
          'damagedBy': '',
          'createdAt': FieldValue.serverTimestamp(),
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bike added Successfully')),
        );
      }
    } catch (e) {
      debugPrint('Error in adding new bikes: $e');
    }
  }

  void _onFilterSelection(String selectedFilter) {
    setState(() {
      _selectedFilter = selectedFilter;
      switch (selectedFilter) {
        case 'Available Bikes':
          _currentScreen = const PaginatedListScreenAvailableBikesSecurity();
          break;
        case 'Bike Allocated':
          _currentScreen = const PaginatedListScreenAllocatedBikes();
          break;
        case 'Return Requests':
          _currentScreen = const PaginatedListScreenReturnedBikes();
          break;
        case 'Damaged':
          _currentScreen = const PaginatedListScreenDamagedBikes();
          break;
        default:
          _currentScreen = const Center(
            child: Text('Select a filter to view bikes'),
          );
      }
    });
  }

  @override
  void dispose() {
    _idController.dispose();
    _bikeLocation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return const Center(child: Text("No user signed in"));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Hello ${user.name}! Welcome.'),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: const Color.fromARGB(255, 188, 222, 250),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 238, 233, 233),
                      offset: Offset(4, 4),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _idController,
                      
                        decoration: const InputDecoration(
                          labelText: 'Bike Id',
                          fillColor: Color.fromARGB(255, 235, 233, 233),
                          prefixIcon: Icon(Icons.add_circle_outline),
                          
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Id required' : null,
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Choose color',
                          fillColor: Color.fromARGB(255, 235, 233, 233),
                          prefixIcon: Icon(Icons.color_lens_outlined),
                          border: OutlineInputBorder(),
                        ),
                        items: selectedColor
                            .map(
                              (val) => DropdownMenuItem(
                                value: val,
                                child: Text(val),
                              ),
                            )
                            .toList(),
                        onChanged: (value) => setState(() {
                          choosenColor = value;
                        }),
                        validator: (value) =>
                            value == null ? 'Please choose a color' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _bikeLocation,
                        decoration: const InputDecoration(
                          labelText: 'Bike Location',
                          fillColor: Color.fromARGB(255, 235, 233, 233),
                          prefixIcon: Icon(Icons.location_on_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Mention Location' : null,
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              storeBikeDetails(
                                _idController.text.trim(),
                                choosenColor!,
                                _bikeLocation.text.trim(),
                              );
                              setState(() {
                                choosenColor = null;
                                _idController.clear();
                                _bikeLocation.clear();
                              });
                            }
                          },
                          child: const Text('Add Bike'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: DraggableScrollableSheet(
                initialChildSize: 0.9,
                minChildSize: 0.5,
                maxChildSize: 0.95,
                builder: (context, controller) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(blurRadius: 8, color: Colors.black26),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 60,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: filters.length,
                            itemBuilder: (context, index) {
                              final filter = filters[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ChoiceChip(
                                  label: Text(filter),
                                  selected: _selectedFilter == filter,
                                  onSelected: (_) => _onFilterSelection(filter),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 10),

                        Expanded(
                          child:
                              _currentScreen ??
                              const Center(
                                child: Text('Select a filter to view bikes'),
                              ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
