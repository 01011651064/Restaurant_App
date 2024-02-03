import 'package:flutter/material.dart';
import 'package:resto/Admin/EditMenu/API.dart';

class CatagoryForm extends StatefulWidget {
  const CatagoryForm({super.key});

  @override
  State<CatagoryForm> createState() => _CatagoryFormState();
}

class _CatagoryFormState extends State<CatagoryForm> {
  late Future<List<CategoryData>> futureCatagoryData;
  late TextEditingController catagoryControl;

  final ScrollController yourScrollController = ScrollController();
  @override
  void initState() {
    futureCatagoryData = fetchCatagories();
    catagoryControl = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: 500,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            bottomSheet: Container(
              alignment: Alignment.topCenter,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.center,
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          Flexible(
                            flex: 9,
                            child: TextField(
                              controller: catagoryControl,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Catagory Name'),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Flexible(
                              flex: 6,
                              child: SizedBox(
                                height: 40,
                                child: FilledButton.tonalIcon(
                                    onPressed: () async {
                                      if (catagoryControl.text.isNotEmpty) {
                                        APIStatus status = await sendCatagory(
                                            CategoryData(
                                                categoryId: 0,
                                                catagoryName:
                                                    catagoryControl.text));

                                        setState(() {
                                          catagoryControl.text = '';
                                          if (status.statusCode == 200) {
                                            futureCatagoryData =
                                                fetchCatagories();
                                          }
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  shape: const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft:
                                                                  Radius
                                                                      .circular(
                                                                          5),
                                                              topRight: Radius
                                                                  .circular(
                                                                      5))),
                                                  duration: const Duration(
                                                      seconds: 1),
                                                  content:
                                                      Text(status.message)));
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(5),
                                                            topRight:
                                                                Radius.circular(
                                                                    5))),
                                                duration: Duration(seconds: 1),
                                                content: Text(
                                                    'Name cant be empty!')));
                                      }
                                    },
                                    icon: const Icon(Icons.add),
                                    label: const Text('Add catagory')),
                              ))
                        ],
                      ),
                    ),
                    const Divider(),
                    Flexible(
                      child: FutureBuilder(
                          future: futureCatagoryData,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Container(
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Error: Request to server failed',
                                    style: TextStyle(fontSize: 20),
                                  ));
                            } else if (snapshot.hasData) {
                              if (snapshot.data!.isEmpty) {
                                return Container(
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'No Data within the specified filters',
                                      style: TextStyle(fontSize: 20),
                                    ));
                              } else {
                                return Container(
                                  //constraints: const BoxConstraints(maxWidth: 600),
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    controller: yourScrollController,
                                    scrollDirection: Axis.vertical,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        onTap: () {},
                                        title: Text(
                                            snapshot.data![index].catagoryName),
                                        trailing: IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () async {
                                              APIStatus status =
                                                  await deleteCatagory(
                                                      snapshot.data![index]);
                                              setState(() {
                                                if (status.statusCode == 200) {
                                                  futureCatagoryData =
                                                      fetchCatagories();
                                                }
                                                ScaffoldMessenger.of(
                                                        context)
                                                    .showSnackBar(SnackBar(
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        5),
                                                                topRight: Radius
                                                                    .circular(
                                                                        5))),
                                                        duration: const Duration(
                                                            seconds: 1),
                                                        content: Text(
                                                            status.message)));
                                              });
                                            }),
                                      );
                                    },
                                  ),
                                );
                              }
                            } else {
                              return Container(
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(),
                              );
                            }
                          }),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
