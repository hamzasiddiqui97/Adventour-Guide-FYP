import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_basics/model/vehicle.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../core/constant/color_constants.dart';
import '../model/firebase_reference.dart';
import '../widgets/myContainer.dart';

class AddNewVehiclePage extends StatefulWidget {
  final String uid;

  AddNewVehiclePage({Key? key, required this.uid}) : super(key: key);
  @override
  _AddNewVehiclePageState createState() => _AddNewVehiclePageState();
}

class _AddNewVehiclePageState extends State<AddNewVehiclePage> {
  bool isUploading = false;

  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _brand = '';
  String _imageUrl = '';
  String _description = '';
  String _type = '';
  String _model = '';
  int _year = 0;
  double _rent = 0.0;
  File? vehicleImageFile;
  String vehicleImagePath = '';

  final picker = ImagePicker();

  getVehicleImage() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        vehicleImageFile = File(pickedFile.path);
        isUploading = true; // Start the upload
      });
    }
    if (vehicleImageFile == null) return;
    //Import dart:core
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    /*Step 2: Upload to Firebase storage*/
    //Install firebase_storage
    //Import the library

    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    //Create a reference for the image to be stored
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    //Handle errors/success
    try {
      //Store the file
      await referenceImageToUpload.putFile(
        File(
          vehicleImageFile!.path,
        ),
      );
      //Success: get the download URL
      String url = await referenceImageToUpload.getDownloadURL();
      setState(() {
        vehicleImagePath = url;
        isUploading = false; // End the upload
      });
      print('Image URL: $vehicleImagePath');
    } catch (error) {
      //Some error occurred
      print('Error uploading image: $error');
      setState(() {
        isUploading = false; // End the upload
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.secondaryColor,
        foregroundColor: ColorPalette.primaryColor,
        title: const Text('Add New Vehicle'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
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
                decoration: const InputDecoration(
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
                decoration: const InputDecoration(
                  labelText: 'Model',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a model';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _model = value;
                  });
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Year',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a year';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _year = int.parse(value);
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Type',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a type';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _type = value;
                  });
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(

                  labelText: 'Rent',

                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a rent';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _rent =  double.parse(value);
                  });
                },
              ),
              // TextFormField(
              //   decoration: const InputDecoration(
              //     labelText: 'Image URL',
              //   ),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter an image URL';
              //     }
              //     return null;
              //   },
              //   onChanged: (value) {
              //     setState(() {
              //       _imageUrl = value;
              //     });
              //   },
              // ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
              ),
              SizedBox(height: 4.h),
              GestureDetector(
                onTap: () {
                  getVehicleImage();
                  // captureImage();
                  // print(image1!.path);
                },
                child: MyContainer(
                  // onTap: (){},
                  height: 66.h,
                  width: 80.w,
                  radius: 10,
                  borderColor: ColorPalette.textColor,
                  child: vehicleImageFile == null
                      ? const Icon(Icons.add_a_photo_outlined, size: 30)
                      : Image.file(
                          vehicleImageFile!,
                          fit: BoxFit.fill,
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: isUploading ? null: () {
                    String uid = FirebaseAuth.instance.currentUser!.uid;

                    if (_formKey.currentState?.validate() ?? false && vehicleImagePath.isNotEmpty) {
                      // Save the new vehicle to the database
                      VehicleModel newVehicle = VehicleModel(
                        id:uid ,
                        ownerId:
                        uid, // Replace this with the actual ownerId from Firebase Authentication
                        name: _name,
                        brand: _brand,
                        year: _year.toString(),
                        type: _type,
                        model: _model,
                        rent: _rent.toString(),
                        imageUrl: vehicleImagePath,
                        description: _description,
                      );
                      // Add the new vehicle to the database
                      AddPlacesToFirebaseDb()
                          .addVehicleToDatabase(uid, newVehicle);

                      // Navigate back to the TransportOwnerDashboardPage
                      Navigator.pop(context);
                    }
                  } ,
                  child: const Text('Post'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
