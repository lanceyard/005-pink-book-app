import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pink_book_app/logic/bloc/history_action/history_action_bloc.dart';
import 'package:pink_book_app/logic/model/save_history.dart';
import 'package:pink_book_app/ui/widget/Dialog/custom_alert_dialog.dart';
import 'package:pink_book_app/ui/widget/button/filled_button.dart';
import 'package:pink_book_app/ui/widget/field/dropdown.dart';
import 'package:pink_book_app/ui/widget/field/inputField.dart';
import 'package:pink_book_app/ui/widget/theme/color_theme.dart';
import 'package:pink_book_app/ui/widget/theme/text_theme.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final ogttController = TextEditingController();
  final oximeterController = TextEditingController();
  final stomachController = TextEditingController();
  final weightController = TextEditingController();
  final momsageController = TextEditingController();
  final notesController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final numberRegExp = RegExp(r'^[0-9]+$');

  final ImagePicker imagePicker = ImagePicker();

  List<XFile> imageFileList = [];

//! Logic buat pengambilan image dari local
  void selectImage() async {
    if (imageFileList.length >= 3) {
      const snackBar = SnackBar(
        content: Text('Max 3 Picture'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
      if (imageFileList.length > 3) {
        imageFileList.removeRange(3, imageFileList.length);
      }
    }
    setState(() {});
  }

//! buat menghapus image yang sudah dipilih
  void removeImage(int index) {
    imageFileList.removeAt(index);
    setState(() {});
  }

  bool isLoading = false;

//! ini buat nyatuin outputnya di class saveHistory
//* skrng cuma ku print ngga di tampilin di class save_input
  String? _selectedAlcoholTest;
  String? _selectedPregnancyAge;

  SaveHistory saveInput() {
    // Simpan semua data input ke dalam objek InputHistory
    SaveHistory saveHistory = SaveHistory(
      ogttTest: int.parse(ogttController.text),
      oximeterTest: int.parse(oximeterController.text),
      stomachDiameter: int.parse(stomachController.text),
      weightGain: int.parse(weightController.text),
      momsAge: int.parse(momsageController.text),
      alcoholTest: _selectedAlcoholTest ?? '',
      pregnancyAge: int.parse(_selectedPregnancyAge ?? '0'),
      imagePaths: imageFileList.map((image) => image.path).toList(),
      additionalNotes: notesController.text,
    );
    return saveHistory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: shadePinkColor,
        title: Text(
          'INPUT YOUR DATA',
          style: titleTextStyle.copyWith(
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: shadePinkColor),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'OGTT Test',
                            style: subHeaderTextStyle.copyWith(fontSize: 16),
                          ),
                          IconButton(
                            iconSize: 18,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const CustomAlertDialog(
                                      title: Icons.info_outlined,
                                      content:
                                          'Oral Glucose Tolerance Test (OGTT) example result is (140 mg/dl) only input the number',
                                    );
                                  });
                            },
                            icon: Icon(
                              Icons.info_outlined,
                              color: oldRedColor,
                            ),
                          ),
                        ],
                      ),
                      DataInputFIeld(
                        controller: ogttController,
                        isLoading: isLoading,
                        keyType: TextInputType.number,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'The OGTT Test field must be filled in';
                          }
                          if (!numberRegExp.hasMatch(val)) {
                            return 'Only numbers are allowed for OGTT Test';
                          }
                          return null;
                        },
                      ),
                      Row(
                        children: [
                          Text(
                            'Oximeter Test',
                            style: subHeaderTextStyle.copyWith(fontSize: 16),
                          ),
                          IconButton(
                            iconSize: 18,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const CustomAlertDialog(
                                      title: Icons.info_outlined,
                                      content:
                                          'test for oxygen carried in your red blood cells, if it was 90% input as 90',
                                    );
                                  });
                            },
                            icon: Icon(
                              Icons.info_outlined,
                              color: oldRedColor,
                            ),
                          ),
                        ],
                      ),
                      DataInputFIeld(
                        controller: oximeterController,
                        isLoading: isLoading,
                        keyType: TextInputType.number,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'The Oximeter Test field must be filled in';
                          }
                          if (!numberRegExp.hasMatch(val)) {
                            return 'Only numbers are allowed for Oximeter Test';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Stomach Diameter',
                        style: subHeaderTextStyle.copyWith(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DataInputFIeld(
                        controller: stomachController,
                        isLoading: isLoading,
                        keyType: TextInputType.number,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'The Stomach Diameter field must be filled in';
                          }
                          if (!numberRegExp.hasMatch(val)) {
                            return 'Only numbers are allowed for Stomach Diameter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Weight Gain',
                        style: subHeaderTextStyle.copyWith(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DataInputFIeld(
                        controller: weightController,
                        isLoading: isLoading,
                        keyType: TextInputType.number,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'The Weight Gain field must be filled in';
                          }
                          if (!numberRegExp.hasMatch(val)) {
                            return 'Only numbers are allowed for Weight Gain';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Moms Age',
                        style: subHeaderTextStyle.copyWith(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DataInputFIeld(
                        controller: momsageController,
                        isLoading: isLoading,
                        keyType: TextInputType.number,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'The Moms Age field must be filled in';
                          }
                          if (!numberRegExp.hasMatch(val)) {
                            return 'Only numbers are allowed for Moms Age';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Alcohol Test',
                        style: subHeaderTextStyle.copyWith(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownField(
                        isLoading: false,
                        items: const ['Positive', 'Negative'],
                        selectedItem: _selectedAlcoholTest,
                        onChanged: (value) {
                          setState(() {
                            _selectedAlcoholTest =
                                value; // Simpan nilai yang dipilih
                          });
                        },
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please select a Alcochol Test';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Pregnancy Age',
                        style: subHeaderTextStyle.copyWith(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownField(
                        isLoading: false,
                        items: const [
                          '0',
                          '1',
                          '2',
                          '3',
                          '4',
                          '5',
                          '6',
                          '7',
                          '8',
                          '9',
                          '10',
                          '11',
                          '12'
                        ],
                        selectedItem: _selectedPregnancyAge,
                        onChanged: (value) {
                          setState(() {
                            _selectedPregnancyAge =
                                value; // Simpan nilai yang dipilih
                          });
                        },
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please select a Pregnancy Age';
                          }
                          return null;
                        },
                      ),
                      Row(
                        children: [
                          Text(
                            'Attach USG Picture',
                            style: subHeaderTextStyle.copyWith(fontSize: 16),
                          ),
                          IconButton(
                            iconSize: 18,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const CustomAlertDialog(
                                      title: Icons.info_outlined,
                                      content: 'Max 3 picture',
                                    );
                                  });
                            },
                            icon: Icon(
                              Icons.info_outlined,
                              color: oldRedColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: backgroundColor),
                            child: IconButton(
                                onPressed: () {
                                  selectImage();
                                },
                                icon: Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 60,
                                  color: oldRedColor,
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: oldRedColor),
                            borderRadius: BorderRadius.circular(18)),
                        height: 135,
                        child: imageFileList.isEmpty
                            ? const Center(
                                child: Text('No images selected'),
                              )
                            : GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisSpacing: 6,
                                        crossAxisSpacing: 6,
                                        crossAxisCount: 3),
                                itemCount: imageFileList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Stack(
                                    children: [
                                      Image.file(
                                        File(imageFileList[index].path),
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        top: -10,
                                        right: -10,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.red,
                                          child: IconButton(
                                            onPressed: () {
                                              removeImage(index);
                                            },
                                            icon: const Icon(
                                              Icons.remove,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Adittional Notes',
                        style: subHeaderTextStyle.copyWith(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: oldRedColor),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width - 40,
                          ),
                          child: TextField(
                            controller: notesController,
                            maxLines: null,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Type here...',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'The Autism detection Result will be calculated once you saved it!',
                        style: subHeaderTextStyle.copyWith(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      CustomFilledButton(
                        title: 'Save',
                        width: MediaQuery.of(context).size.width,
                        height: 48,
                        bgColor: oldRedColor,
                        hvColor: basePinkColor,
                        // onPressed: saveInput,
                        onPressed: () {
                        // context.read<HistoryActionAddEvent>().add(HistoryActionAddEvent(saveInput()));
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
