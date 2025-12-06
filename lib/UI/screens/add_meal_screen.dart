// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/utils/validators.dart';
import '../../domain/entity/meal.dart';
import '../cubit/cubit_meal.dart';
import '../cubit/cubit_meal_intent.dart';

class AddMealScreen extends StatefulWidget {
  final Meal? mealToUpdate;

  const AddMealScreen({super.key, this.mealToUpdate});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _imagePicker = ImagePicker();
  DateTime _selectedDateTime = DateTime.now();
  MealType _selectedType = MealType.breakfast;
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    if (widget.mealToUpdate != null) {
      _nameController.text = widget.mealToUpdate!.name;
      _caloriesController.text = widget.mealToUpdate!.calories.toString();
      _selectedDateTime = widget.mealToUpdate!.dateTime;
      _selectedType = widget.mealToUpdate!.type;
      _selectedImagePath = widget.mealToUpdate!.imageUrl;
    }
  }

  Future<void> _pickImage() async {
    try {
      final source = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () => Navigator.pop(context, 'gallery'),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => Navigator.pop(context, 'camera'),
              ),
              ListTile(
                leading: const Icon(Icons.folder),
                title: const Text('File Explorer'),
                onTap: () => Navigator.pop(context, 'file'),
              ),
            ],
          ),
        ),
      );

      if (source != null) {
        if (source == 'file') {
          final result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['jpg', 'jpeg', 'png'],
            allowMultiple: false,
          );
          if (result != null && result.files.isNotEmpty) {
            final path = result.files.first.path;
            if (path != null) {
              setState(() {
                _selectedImagePath = path;
              });
            }
          }
        } else {
          final XFile? image = await _imagePicker.pickImage(
            source:
                source == 'gallery' ? ImageSource.gallery : ImageSource.camera,
            maxWidth: 1200,
            maxHeight: 1200,
            imageQuality: 85,
          );
          if (image != null) {
            setState(() {
              _selectedImagePath = image.path;
            });
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.mealToUpdate == null ? 'Add Meal' : 'Update Meal'),
        actions: [
          if (_selectedImagePath != null &&
              _selectedImagePath != 'assets/nophoto.jpg')
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _selectedImagePath = 'assets/nophoto.jpg';
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: _selectedImagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _selectedImagePath == 'assets/nophoto.jpg'
                              ? Image.asset(
                                  'assets/nophoto.jpg',
                                  fit: BoxFit.cover,
                                )
                              : _selectedImagePath!.startsWith('http')
                                  ? Image.network(
                                      _selectedImagePath!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              _buildImagePlaceholder(),
                                    )
                                  : Image.file(
                                      File(_selectedImagePath!),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.asset(
                                        'assets/nophoto.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                        )
                      : _buildImagePlaceholder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Meal Name',
                  border: OutlineInputBorder(),
                ),
                validator: Validators.validateMealName,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<MealType>(
                initialValue: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Meal Type',
                  border: OutlineInputBorder(),
                ),
                items: MealType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a meal type' : null,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDateTime(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date & Time',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MMM dd, yyyy - hh:mm a')
                            .format(_selectedDateTime),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _caloriesController,
                decoration: const InputDecoration(
                  labelText: 'Calories',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: Validators.validateCalories,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveMeal,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  widget.mealToUpdate == null ? 'Add Meal' : 'Update Meal',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.add_photo_alternate,
          size: 48,
          color: Colors.grey,
        ),
        SizedBox(height: 8),
        Text(
          'Add Meal Image',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _saveMeal() async {
    if (_formKey.currentState!.validate()) {
      String? finalImagePath = _selectedImagePath;

      if (finalImagePath != null && !finalImagePath.startsWith('http')) {
        try {
          final appDir = await getApplicationDocumentsDirectory();
          final String fileName = '${const Uuid().v4()}.jpg';
          final directory = Directory('${appDir.path}/meal_images');
          final String newPath = '${directory.path}/$fileName';

          if (!directory.existsSync()) {
            directory.createSync(recursive: true);
          }

          final File originalFile = File(finalImagePath);
          if (await originalFile.exists()) {
            final File newFile = await originalFile.copy(newPath);
            finalImagePath = newFile.path;
          } else {}
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save image: $e')),
          );
          return;
        }
      }

      final meal = Meal(
        id: widget.mealToUpdate?.id ?? const Uuid().v4(),
        name: _nameController.text,
        type: _selectedType,
        dateTime: _selectedDateTime,
        calories: int.parse(_caloriesController.text),
        imageUrl: finalImagePath,
      );

      if (widget.mealToUpdate == null) {
        context.read<CubitMeal>().onIntent(AddMealIntent(meal));
      } else {
        context.read<CubitMeal>().onIntent(UpdateMealIntent(meal));
      }

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }
}
