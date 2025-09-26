import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RequestPage extends StatefulWidget {
  final String bikeId;
  final String bikeColor;
  final String bikeLocation;
  final String allocatedTo;

  const RequestPage({
    super.key,
    required this.bikeId,
    required this.bikeColor,
    required this.bikeLocation,
    required this.allocatedTo,
  });

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  bool _canGoBack = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canGoBack,
      onPopInvokedWithResult: (didPop, result) => !_canGoBack,
      child: Scaffold(
        appBar: AppBar(title: Text('Wheel Ways'), centerTitle: true),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text('BiCycle Allocated'),
                const SizedBox(height: 10),
                Lottie.asset('assets/lotties/Bicycle_return.json'),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/bike_img.jpg',
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 10),
                            const Text('HCL Bikes'),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text('Color: ${widget.bikeColor}'),
                        const SizedBox(height: 5),
                        Text('Bike Id: ${widget.bikeId}'),
                        const SizedBox(height: 5),
                        Text('Location: ${widget.bikeLocation}'),
                        const SizedBox(height: 5),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    setState(() {
                                      _canGoBack = true;
                                      _isLoading = true;
                                    });
                                    try {
                                      await db
                                          .collection('BikesData')
                                          .doc(widget.bikeId)
                                          .update({
                                            'returnedAt': FieldValue.serverTimestamp(),
                                            'isAllocated': false,
                                            'isReturned':true,
                                            'returnBy': {widget.allocatedTo},
                                          });

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Return Successful'),
                                        ),
                                      );

                                      Navigator.pop(context);
                                    } catch (e) {
                                      print(e);
                                    } finally {
                                      if (mounted) {
                                        setState(() => _isLoading = false);
                                      }
                                    }
                                  },
                            child: _isLoading
                                ? SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Lottie.asset(
                                      'assets/lotties/Loading.json',
                                    ),
                                  )
                                : const Text('Return'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
