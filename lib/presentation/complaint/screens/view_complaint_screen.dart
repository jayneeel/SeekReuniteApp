import 'package:flutter/material.dart';
import 'package:seek_reunite/constants/constant_fonts.dart';
import 'package:seek_reunite/constants/contant_colors.dart';

class ViewComplaintScreen extends StatelessWidget {
  const ViewComplaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Complaint'),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 200,
              width: 400,
              decoration: BoxDecoration(
                color: ConstantColors.primaryColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ]
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      height: 200,
                      width: 150,
                      child: Image.asset("assets/images/person.png",
                      height: 150,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        children: [
                          Text(
                            "Amol Pande",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Age : 45",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Gender Male",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.white60,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text("The Simple English Wikipedia is a modified English-language edition of Wikipedia written primarily in Basic English and Learning English. It is one of seven Wikipedias written in an Anglic language or English-based pidgin or creole. ",
                    style: TextStyle(
                      fontSize: 15
                    ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.lightBlueAccent,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "Complete Address",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Sector 4, Airoli, Navi Mumbai",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
