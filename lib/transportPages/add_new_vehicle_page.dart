import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_basics/model/vehicle.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../core/constant/color_constants.dart';
import '../model/firebase_reference.dart';
import '../snackbar_utils.dart';
import '../widgets/myContainer.dart';
import '../widgets/myTextField.dart';

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

  final TextEditingController nameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController rentController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

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
    bool isNumeric(String s) {
      if (s == null) {
        return false;
      }
      return double.tryParse(s) != null;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.secondaryColor,
        foregroundColor: ColorPalette.primaryColor,
        title: const Text('Add New Vehicle'),
      ),
      body:
      SingleChildScrollView(
      child: Padding(

        padding: const EdgeInsets.all(12.0),
        child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextField(
              borderColor: ColorPalette.secondaryColor,

              controller: nameController,
              hint: 'Enter Name',
              icon: const Icon(Icons.drive_eta),
              onEditingComplete: () {
                setState(() {
                  _name = nameController.text;
                });
              },
            ),
            SizedBox(height :2.h),
            MyTextField(
              borderColor: ColorPalette.secondaryColor,
              controller: brandController,
              hint: 'Enter Brand',
              icon: const Icon(Icons.branding_watermark),
              onEditingComplete: () {
                setState(() {
                  _brand = brandController.text;
                });
              },
            ),
            SizedBox(height :2.h),
            MyTextField(
              borderColor: ColorPalette.secondaryColor,
              controller: modelController,
              hint: 'Enter Model',
              icon: const Icon(Icons.model_training),
              onEditingComplete: () {
                setState(() {
                  _model = modelController.text;
                });
              },
            ),
            SizedBox(height :2.h),

            MyTextField(
              borderColor: ColorPalette.secondaryColor,
              controller: yearController,
              keyboardType: TextInputType.number,
              hint: 'Enter Year',
              icon: const Icon(Icons.calendar_today),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a year';
                } else if (!isNumeric(value)) {
                  return 'Please enter a valid year';
                } else if (int.parse(value) < 1886 || int.parse(value) > DateTime.now().year) {
                  return 'Please enter a year between 1886 and ${DateTime.now().year}';
                }
                return null;
              },
              onEditingComplete: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _year = int.parse(yearController.text);
                  });
                }
              },
            ),

            SizedBox(height :2.h),
            MyTextField(
              borderColor: ColorPalette.secondaryColor,
              controller: typeController,
              hint: 'Enter Type',
              icon: Icon(Icons.car_rental),
              onEditingComplete: () {
                setState(() {
                  _type = typeController.text;
                });
              },
            ),
            SizedBox(height :2.h),

            MyTextField(
              borderColor: ColorPalette.secondaryColor,
              controller: rentController,
              keyboardType: TextInputType.number,
              hint: 'Enter Rent',
              icon: const Icon(Icons.attach_money),
              onEditingComplete: () {
                setState(() {
                  double enteredRent = double.tryParse(rentController.text) ?? 0.0;
                  if (enteredRent <= 0) {
                    // Display an error message or take appropriate action
                    Utils.showSnackBar('Rent should be greater than 0', false);
                  } else {
                    _rent = enteredRent;
                  }
                });
              },
            ),

            SizedBox(height :2.h),

            MyTextField(
              borderColor: ColorPalette.secondaryColor,

              controller: descriptionController,
              hint: 'Enter Description',
              icon: const Icon(Icons.description),
              onEditingComplete: () {
                setState(() {
                  _description = descriptionController.text;
                });
              },
            ),

            SizedBox(height: 4.h),
            GestureDetector(
              onTap: () {
                getVehicleImage();
              },
              child: MyContainer(
                height: 66.h,
                width: 80.w,
                radius: 10,
                borderColor: ColorPalette.textColor,
                child: isUploading
                    ? CircularProgressIndicator() // Show loading spinner when uploading
                    : vehicleImageFile == null
                    ? const Icon(Icons.add_a_photo_outlined, size: 30)
                    : Image.file(
                  vehicleImageFile!,
                  fit: BoxFit.fill,
                ),
              ),
            ),


            SizedBox(height: 4.h),

            SizedBox(

              width: MediaQuery.of(context).size.width,
              height: 50,
              child:

              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(ColorPalette.secondaryColor),
                    foregroundColor: MaterialStateProperty.all(ColorPalette.primaryColor),
                  ),
                  onPressed: isUploading
                      ? null
                      : () {
                    String uid = FirebaseAuth.instance.currentUser!.uid;
                    String name = nameController.text.toString();
                    String brand = brandController.text.toString();
                    String year = yearController.text.toString();
                    String type = typeController.text.toString();
                    String model = modelController.text.toString();
                    String rent = rentController.text.toString();
                    String description = descriptionController.text.toString();

                    if (rent.isEmpty || double.parse(rent) <= 0) {
                      Utils.showSnackBar('Rent should be greater than 0', false);
                    } else if (name.isEmpty ||
                        brand.isEmpty ||
                        year.isEmpty ||
                        type.isEmpty ||
                        model.isEmpty ||
                        description.isEmpty) {
                      Utils.showSnackBar('Please fill in all fields', false);
                    } else {
                      // Save the new vehicle to the database
                      VehicleModel newVehicle = VehicleModel(
                        id: uid,
                        ownerId: uid,
                        name: name,
                        brand: brand,
                        year: year,
                        type: type,
                        model: model,
                        rent: rent,
                        imageUrl: vehicleImagePath,
                        description: description,
                      );

                      // Add the new vehicle to the database
                      AddPlacesToFirebaseDb().addVehicleToDatabase(uid, newVehicle);

                      // Navigate back to the TransportOwnerDashboardPage
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Post'),
                ),
              ),
            ),

          ]

            ),
          ),
      ),
      ),
    );
  }
}
