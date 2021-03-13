import 'package:flutter/material.dart';
import '../Start/Home.dart';

void displayModalBottomSheet(context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return DraggableScrollableSheet(
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            height: 300,
            child: Form(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      alignment: Alignment.center,
                      height: 5,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[400]),
                    ),
                  ),
                  StatefulBuilder(
                    builder: (BuildContext context,
                        void Function(void Function()) setState) {
                      return Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 20, left: 20),
                        child: new DropdownButton<String>(
                          value: dropdownValue,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Colors.blue,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                          items: <String>['Choose a city', 'Liverpool']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                  StatefulBuilder(
                    builder: (context, setState) {
                      return new ListTile(
                        leading: Text("Radius"),
                        trailing: Text(sliderValue.toString()),
                        title: Slider(
                          label: "Radius",
                          min: 0,
                          max: 100,
                          divisions: 5,
                          value: sliderValue,
                          onChanged: (double value) {
                            setState(
                                  () {
                                sliderValue = value;
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Center(
                          child: new Wrap(
                            children: List<Widget>.generate(
                              3,
                                  (int index) {
                                return Container(
                                  padding: EdgeInsets.all(5),
                                  child: ChoiceChip(
                                    elevation: 2,
                                    selectedColor: Colors.deepPurple,
                                    label: Container(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          'Item $index',
                                          style: TextStyle(fontSize: 20, color: Colors.deepPurpleAccent),
                                        )),
                                    selected: value == index,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        value = selected ? index : null;
                                      });
                                    },
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}