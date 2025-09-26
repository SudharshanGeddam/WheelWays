import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wheelways/models/user_provider.dart';
import 'package:wheelways/widgets/paginated_list_screen_available_bikes.dart';

class SecurityHome extends ConsumerStatefulWidget {
  const SecurityHome({super.key});

  @override
  ConsumerState<SecurityHome> createState() => _SecurityHomeState();
}

class _SecurityHomeState extends ConsumerState<SecurityHome> {
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
          SnackBar(content: Text('Bike with this ID already exists.')),
        );
      } else {
        await db.collection('BikesData').doc(bikeId).set({
          'bikeId': bikeId,
          'bikeColor': bikeColor,
          'bikeLocation': location,
          'isAllocated': false,
          'isDamaged': false,
          'isReturned': false,
          'allocatedTo': '',
          'returnBy': '',
          'createdAt': FieldValue.serverTimestamp(),
          'returnedAt': ''
        });
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Bike added Successfully')));
      }
    } catch (e) {
      print(e);
    }
  }

  void _onFilterSelection(String selectedFilter) {
    switch (selectedFilter) {
      case 'Available Bikes':
        PaginatedListScreenAvailableBikes();
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _bikeLocation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProviderValue = ref.watch(userProvider);
    final userName = userProviderValue?.name ?? '';
    return Scaffold(
      appBar: AppBar(title: Text('Wheel Ways'), centerTitle: true),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello $userName! Welcome.'),

              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: const Color.fromARGB(255, 188, 222, 250),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 238, 233, 233),
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
                        textCapitalization: TextCapitalization.none,
                        validator: (value) =>
                            value!.isEmpty ? 'Id required' : null,
                        decoration: InputDecoration(
                          label: Text('Bike Id'),
                          prefixIcon: Icon(Icons.add_circle_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          label: Text('Choose color'),
                          prefixIcon: Icon(Icons.color_lens_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        initialValue: choosenColor,
                        items: selectedColor.map((val) {
                          return DropdownMenuItem(value: val, child: Text(val));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            choosenColor = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please choose a color' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _bikeLocation,
                        textCapitalization: TextCapitalization.none,
                        validator: (value) =>
                            value!.isEmpty ? 'Mention Location' : null,
                        decoration: InputDecoration(
                          label: Text('Bike Location'),
                          prefixIcon: Icon(Icons.location_on_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
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
                          child: Text('Add Bike'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    final filter = filters[index];
                    return GestureDetector(
                      onTap: () {
                        _selectedFilter = filter;
                        _onFilterSelection(_selectedFilter);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Chip(
                          backgroundColor: (_selectedFilter == filter)
                              ? const Color.fromARGB(255, 240, 172, 237)
                              : Colors.white,

                          label: Text(filter),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
