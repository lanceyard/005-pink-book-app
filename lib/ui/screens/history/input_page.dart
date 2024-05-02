import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pink_book_app/logic/bloc/history/history_bloc.dart';
import 'package:pink_book_app/logic/bloc/history_action/history_action_bloc.dart';
import 'package:pink_book_app/logic/model/save_history.dart';
import 'package:pink_book_app/ui/utils.dart';
import 'package:pink_book_app/ui/widget/Dialog/custom_alert_dialog.dart';
import 'package:pink_book_app/ui/widget/button/filled_button.dart';
import 'package:pink_book_app/ui/widget/field/inputField.dart';
import 'package:pink_book_app/ui/widget/theme/color_theme.dart';
import 'package:pink_book_app/ui/widget/theme/text_theme.dart';

// class InputPage adalah halaman di mana pengguna dapat memasukkan data baru atau mengedit data yang sudah ada. Halaman ini memiliki beberapa bidang input untuk data seperti tes OGTT, tes oksimeter, diameter perut, penambahan berat badan, usia ibu, tes alkohol, usia kehamilan, gambar USG terlampir, dan catatan tambahan. Pengguna juga dapat menambahkan atau menghapus gambar USG. Setelah memasukkan semua informasi yang diperlukan, pengguna dapat menyimpan data tersebut. Jika pengguna sedang mengedit data yang sudah ada, tombol aksi akan disesuaikan untuk melakukan pembaruan data.
class InputPage extends StatefulWidget {
  final SaveHistory? saveHistory;
  final bool isEditing;
  const InputPage({super.key, this.saveHistory, this.isEditing = false});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _formKey = GlobalKey<FormState>();
  final ogttController = TextEditingController();
  final oximeterController = TextEditingController();
  final stomachController = TextEditingController();
  final weightController = TextEditingController();
  final momsageController = TextEditingController();
  final notesController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();

  List<XFile> imageFileList = [];

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.saveHistory != null) {
      ogttController.text = widget.saveHistory!.ogttTest.toString();
      oximeterController.text = widget.saveHistory!.oximeterTest.toString();
      stomachController.text = widget.saveHistory!.stomachDiameter.toString();
      weightController.text = widget.saveHistory!.weightGain.toString();
      momsageController.text = widget.saveHistory!.momsAge.toString();
      _selectedAlcoholTest = widget.saveHistory!.alcoholTest;
      _selectedPregnancyAge = widget.saveHistory!.pregnancyAge.toString();
      imageFileList =
          widget.saveHistory!.imagePaths.map((path) => XFile(path)).toList();
      notesController.text = widget.saveHistory!.additionalNotes.toString();
    }
  }

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
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'The OGTT Test field must be filled in';
                          }
                          if (int.parse(val) < 100 || int.parse(val) > 200) {
                            return 'Please enter a number between 100 and 200';
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
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'The Oximeter Test field must be filled in';
                          }
                          if (int.parse(val) < 1 || int.parse(val) > 100) {
                            return 'Please enter a number between 1 and 100';
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
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'The Stomach Diameter field must be filled in';
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
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'The Weight Gain field must be filled in';
                          }
                          if (int.parse(val) < 9 || int.parse(val) > 50) {
                            return 'Please enter a number between 9 and 50';
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
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'The Moms Age field must be filled in';
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
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: oldRedColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: oldRedColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        value: _selectedAlcoholTest,
                        items: ['Positive', 'Negative'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: hintTextStyle,
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedAlcoholTest = newValue;
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
                        'Pregnancy Age (Month)',
                        style: subHeaderTextStyle.copyWith(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: oldRedColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: oldRedColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        value: _selectedPregnancyAge,
                        items: List.generate(13, (index) => index.toString())
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: hintTextStyle,
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedPregnancyAge = newValue;
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
                                      showImage(imageFileList[index].path),
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
                      BlocConsumer<HistoryActionBloc, HistoryActionState>(
                        listener: (context, state) async {
                          if (state is HistoryActionSuccess) {
                            Navigator.pop(context);
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const CustomAlertDialog(
                                    title: Icons.info_outlined,
                                    content: "History Input Saved!",
                                  );
                                });
                          }

                          if (state is HistoryActionError) {
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomAlertDialog(
                                    title: Icons.info_outlined,
                                    content: state.msg,
                                  );
                                });
                          }
                        },
                        builder: (context, state) {
                          if (state is HistoryActionLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return CustomFilledButton(
                            title: widget.isEditing ? 'Update' : 'Save',
                            width: MediaQuery.of(context).size.width,
                            height: 48,
                            bgColor: oldRedColor,
                            hvColor: basePinkColor,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (widget.isEditing) {
                                  context.read<HistoryActionBloc>().add(
                                      HistoryActionUpdateDetailEvent(
                                          widget.saveHistory!.id, saveInput()));
                                } else {
                                  context
                                      .read<HistoryActionBloc>()
                                      .add(HistoryActionAddEvent(saveInput()));
                                }
                                context
                                    .read<HistoryBloc>()
                                    .add(HistoryGetAllEvent());
                              }
                            },
                          );
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
