import 'package:flutter/material.dart';
import 'package:resto/Admin/EditMenu/API.dart';
import '../EditMenu/EditForm.dart';
import 'package:resto/main.dart';

class FoodCard extends StatelessWidget {
  final FoodCardData cardData;
  final Function update;

  const FoodCard({
    required this.cardData,
    required this.update,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      //constraints: BoxConstraints.expand(),
      child: Card(
        elevation: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    clipBehavior: Clip.antiAlias,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Image.network(
                      '$serverUrl/images/${cardData.firstImage}',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    color: Theme.of(context).canvasColor,
                    width: 3.5,
                    height: 80,
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            Flexible(
              flex: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${cardData.name}',
                          style: const TextStyle(fontSize: 20)),
                      Text('Price: \$${cardData.price}'.toString(),
                          style: const TextStyle(
                              fontSize: 20, color: Colors.green)),
                      Text('Stock: ${cardData.stock}'.toString(),
                          style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton.filledTonal(
                          onPressed: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return EditForm(this.update, cardData, true);
                              },
                            );
                          },
                          icon: Icon(Icons.edit)),
                      IconButton.filledTonal(
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirm"),
                                    content: const Text(
                                        "Are you sure you want to delete this item?\nThis proccess can't be undone."),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Yes'),
                                        onPressed: () async {
                                          APIStatus status =
                                              await deleteFoodCardData(
                                                  cardData);
                                          if (context.mounted) {
                                            Navigator.of(context).pop();

                                            if (status.statusCode == 200) {
                                              update(true);
                                            }
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                  
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    content:
                                                        Text(status.message)));
                                          }
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('No'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          icon: Icon(Icons.delete))
                    ],
                  )
                ],
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
