import 'package:flutter/material.dart';
import 'package:google_maps_basics/model/vehicle.dart';
import 'package:google_maps_basics/pages/transport_owner_dashboard_page.dart';

class AddNewVehiclePage extends StatefulWidget {
  @override
  _AddNewVehiclePageState createState() => _AddNewVehiclePageState();
}

class _AddNewVehiclePageState extends State<AddNewVehiclePage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _brand = '';
  String _imageUrl = '';
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Vehicle'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Brand',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a brand';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _brand = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Image URL',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _imageUrl = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Save the new vehicle to the database
                      Vehicle newVehicle = Vehicle(
                        id: '',
                        ownerId: '',
                        name: _name,
                        brand: _brand,
                        year: '',
                        type: '',
                        model: '',
                        rent: '',
                        imageUrl: _imageUrl,
                        description: _description,
                      );
                      // Add the new vehicle to the list of vehicles
                      TransportOwnerDashboardPage().vehicles.add(newVehicle);
                      // Navigate back to the TransportOwnerDashboardPage
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
