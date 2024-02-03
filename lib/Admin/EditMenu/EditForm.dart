import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resto/Admin/EditMenu/API.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:uuid/uuid.dart';

import 'package:image_picker/image_picker.dart';
import 'package:resto/main.dart';

class EditForm extends StatefulWidget {
  final bool isEdit;

  final Function updateList;
  final FoodCardData cardData;
  EditForm(this.updateList, this.cardData, this.isEdit);

  @override
  State<EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  final _formKey = GlobalKey<FormState>();

  XFile? image1;
  XFile? image2;
  late String image1Name;
  late String image2Name;
  bool image1State = true;
  bool image2State = true;
  late bool image1Changed;
  late bool image2Changed;

  late TextEditingController nameControl;
  late TextEditingController descControl;
  late TextEditingController stockControl;
  late TextEditingController priceControl;
  late Future<List<CategoryData>> categories;
  late List<CategoryData> selectedCategories;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      image1Changed = false;
      image2Changed = false;
    } else {
      image1Changed = true;
      image2Changed = true;
    }
    if (widget.cardData.firstImage.isNotEmpty) {
      image1 = XFile('$serverUrl/images/${widget.cardData.firstImage}');
      image1Name = image1!.path.split("images/")[1];
    }

    if (widget.cardData.secondImage.isNotEmpty) {
      image2 = XFile('$serverUrl/images/${widget.cardData.secondImage}');
      image2Name = image2!.path.split("images/")[1];
    }

    categories = fetchCatagories();
    nameControl = TextEditingController();
    descControl = TextEditingController();
    priceControl = TextEditingController();
    stockControl = TextEditingController();
    nameControl.text = widget.cardData.name;
    descControl.text = widget.cardData.description;
    priceControl.text = widget.cardData.price.toString();
    stockControl.text = widget.cardData.stock.toString();
    selectedCategories = widget.cardData.catagories ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: 680,
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 15),
                    const Divider(
                      thickness: 5,
                      indent: 210,
                      endIndent: 210,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                        widget.isEdit
                            ? "Edit item properties"
                            : "Add a food item to the menu:",
                        style: const TextStyle(fontSize: 22)),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          clipBehavior: Clip.antiAlias,
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30))),
                          child: Stack(
                            children: [
                              if (image1 != null)
                                Container(
                                    height: 150,
                                    width: 150,
                                    child: Image.network(
                                      image1!.path,
                                      fit: BoxFit.cover,
                                    )),
                              Container(
                                alignment: Alignment.bottomRight,
                                padding: const EdgeInsets.all(10),
                                child: IconButton.filledTonal(
                                  padding: const EdgeInsets.all(10),
                                  iconSize: 30,
                                  icon: const Icon(Icons.image_search_outlined),
                                  onPressed: () async {
                                    image1 = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);
                                    image1State = true;
                                    image1Name =
                                        '${const Uuid().v1()}.${image1!.name.split(".").last}';

                                    // image1Name = kIsWeb
                                    //     ? image1!.path
                                    //             .split('http://')[1]
                                    //             .split('/')[1] +
                                    //         "." +
                                    //         image1!.name.split(".").last
                                    //     : image1!.path.split('/')[6] +
                                    //         "." +
                                    //         image1!.name.split(".").last;
                                    await sendProductPics(image1!, image1Name);
                                    setState(() {
                                      image1 = XFile(
                                          '$serverUrl/images/$image1Name');
                                    });
                                  },
                                ),
                              ),
                              if (image1State == false)
                                Center(
                                    child: Text(
                                  "Please insert image",
                                  style: TextStyle(color: Colors.red.shade700),
                                )),
                            ],
                          ),
                        ),
                        Container(
                          clipBehavior: Clip.antiAlias,
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: Stack(
                            children: [
                              if (image2 != null)
                                Container(
                                    height: 150,
                                    width: 150,
                                    child: Image.network(
                                      image2!.path,
                                      fit: BoxFit.cover,
                                    )),
                              Container(
                                alignment: Alignment.bottomRight,
                                padding: const EdgeInsets.all(10),
                                child: IconButton.filledTonal(
                                  padding: const EdgeInsets.all(10),
                                  iconSize: 30,
                                  icon: const Icon(Icons.image_search_outlined),
                                  onPressed: () async {
                                    image2 = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery)
                                        .whenComplete(() {
                                      if (image2 != null) {
                                        image2Changed = true;
                                      }
                                    });
                                    image2State = true;
                                    image2Name =
                                        '${const Uuid().v1()}.${image2!.name.split(".").last}';

                                    // image2Name = kIsWeb || !image2Changed
                                    //     ? image2!.path
                                    //             .split('http://')[1]
                                    //             .split('/')[1] +
                                    //         "." +
                                    //         image2!.name.split(".").last
                                    //     : image2!.path.split('/')[6] +
                                    //         "." +
                                    //         image2!.name.split(".").last;
                                    await sendProductPics(image2!, image2Name);
                                    setState(() {
                                      image2 = XFile(
                                          '$serverUrl/images/$image2Name');
                                    });
                                  },
                                ),
                              ),
                              if (image2State == false)
                                Center(
                                    child: Text(
                                  "Please insert image",
                                  style: TextStyle(color: Colors.red.shade700),
                                )),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder(
                        future: categories,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<CategoryData> data = snapshot.data!;
                            if (data.isNotEmpty) {
                              return Container(
                                  height: 50,
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 0, 5, 0),
                                          child: ActionChip.elevated(
                                              avatar: Icon(selectedCategories
                                                      .contains(data[index])
                                                  ? Icons.check
                                                  : Icons.circle_outlined),
                                              elevation: 5,
                                              onPressed: () {
                                                setState(() {
                                                  if (selectedCategories
                                                      .contains(data[index])) {
                                                    selectedCategories
                                                        .remove(data[index]);
                                                  } else {
                                                    selectedCategories
                                                        .add(data[index]);
                                                  }
                                                });
                                              },
                                              label: Text(
                                                data[index].catagoryName,
                                                style: TextStyle(
                                                    color: selectedCategories
                                                            .contains(
                                                                data[index])
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .onSurface),
                                              )),
                                        );
                                      }));
                            } else {
                              return Container();
                            }
                          } else if (snapshot.hasError) {
                            return Container(
                                alignment: Alignment.topCenter,
                                child: Card(
                                  color: Theme.of(context).colorScheme.onError,
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      snapshot.error.toString(),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onErrorContainer),
                                    ),
                                  ),
                                ));
                          } else {
                            return const LinearProgressIndicator();
                          }
                        }),
                    Flex(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      direction: Axis.horizontal,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                            child: TextFormField(
                              controller: nameControl,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Name'),
                              validator: (String? value) {
                                return (value == null || value.isEmpty)
                                    ? 'Can\'t be empty!'
                                    : null;
                              },
                            ),
                          ),
                        ),
                        // Flexible(
                        //   flex: 1,
                        //   child: Container(
                        //     alignment: Alignment.center,
                        //     padding: const EdgeInsets.fromLTRB(5, 15, 20, 0),
                        //     child:
                        //   ),
                        // ),
                      ],
                    ),
                    Flex(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      direction: Axis.horizontal,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 15, 5, 0),
                            child: TextFormField(
                              //expands: true,
                              controller: priceControl,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Price',
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Can\'t be empty!';
                                } else if (double.parse(value) > 999 ||
                                    double.parse(value) < 0.1) {
                                  return 'Only 0.1 to 999';
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'(^\d*\.?\d*)'))
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(5, 15, 20, 0),
                            child: TextFormField(
                              //expands: true,
                              controller: stockControl,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Stock',
                              ),
                              validator: (String? value) {
                                return (value == null || value.isEmpty)
                                    ? 'Can\'t be empty!'
                                    : null;
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'(^[0-9]*$)'))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      child: TextFormField(
                        maxLines: 4,
                        controller: descControl,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Description',
                        ),
                        validator: (String? value) {
                          return (value == null || value.isEmpty)
                              ? 'Can\'t be empty!'
                              : null;
                        },
                      ),
                    ),
                    FilledButton.tonal(
                      child: const Text(
                        'Confirm',
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () async {
                        setState(() {
                          if (image1 == null || image2 == null) {
                            if (image1 == null) {
                              image1State = false;
                            } else {
                              image1State = true;
                            }
                            if (image2 == null) {
                              image2State = false;
                            } else {
                              image2State = true;
                            }
                            return;
                          }
                        });

                        if (_formKey.currentState!.validate()) {
                          if (!widget.isEdit) {
                            APIStatus status =
                                await sendFoodCardData(FoodCardData(
                              itemId: 0,
                              name: nameControl.text,
                              description: descControl.text,
                              rating: 0,
                              price: double.parse(priceControl.text),
                              timesOrdered: 0,
                              stock: int.parse(stockControl.text),
                              firstImage: image1Name,
                              secondImage: image2Name,
                              catagories: selectedCategories,
                            ));
                            if (mounted) {
                              if (status.statusCode == 200) {
                                nameControl.text = '';
                                descControl.text = '';
                                priceControl.text = '';
                                stockControl.text = '';

                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          topRight: Radius.circular(5))),
                                  duration: const Duration(seconds: 1),
                                  content: Text(status.message),
                                ));
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Error"),
                                        content: Text(status.message),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              }
                            }
                          } else {
                            APIStatus status =
                                await updateFoodCardData(FoodCardData(
                              itemId: widget.cardData.itemId,
                              name: nameControl.text,
                              description: descControl.text,
                              rating: widget.cardData.rating,
                              price: double.parse(priceControl.text),
                              timesOrdered: widget.cardData.timesOrdered,
                              stock: int.parse(stockControl.text),
                              firstImage: image1Name,
                              secondImage: image2Name,
                              catagories: selectedCategories,
                            ));
                            if (mounted) {
                              if (status.statusCode == 200) {
                                Navigator.of(context).pop();

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          topRight: Radius.circular(5))),
                                  duration: const Duration(seconds: 1),
                                  content: Text(status.message),
                                ));
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Error"),
                                        content: Text(status.message),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              }
                            }
                          }

                          widget.updateList(true);
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
