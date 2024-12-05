import 'package:cwsdo/views/admin/side_bar.dart';
import 'package:cwsdo/widget/custom/numberInput.dart';
import 'package:flutter/material.dart';
import 'package:cwsdo/widget/admin/nextStep.dart';
import 'package:cwsdo/widget/admin/totaltally.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:html' as html; // Import dart:html for web storage
import 'dart:io'; // For platform-specific checks
import 'package:flutter/foundation.dart'; // For web-specific checks


class RequestList extends StatefulWidget {
  const RequestList({super.key});

  @override
  State<RequestList> createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  @override
  Widget build(BuildContext context) {
    return const Sidebar(content: OngoingList());
  }
}

class OngoingList extends StatelessWidget {
  const OngoingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 10.0, left: 50.0, right: 50, bottom: 20),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total Food Assistance List',
              style: TextStyle(fontSize: 30),
            ),
            Column(
              children: [
                Container(
                  color: Color.fromARGB(255, 45, 127, 226),
                  height: 30,
                  width: double.infinity,
                  // child: Tex t('data'),
                ),
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Column(
                      children: [
                        Container(
                          child: const Row(children: [
                            Text(
                              'Show',
                            ),
                            NumberInputWidget()
                          ]),
                        ),
                        const TableDataList(),
                      ],
                    ),
                  ),
                  // child: Tex t('data'),
                )
              ],
            ),
          ]),
    );
  }
}

class TableDataList extends StatefulWidget {
  const TableDataList({super.key});

  @override
  State<TableDataList> createState() => _TableDataListState();
}

class _TableDataListState extends State<TableDataList> {
  @override
  Widget build(BuildContext context) {
    print( html.window.localStorage['office'].toString());
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('beneficiaries')
  // .where('status', isNotEqualTo: 'Completed')
  .where('barangay', isEqualTo: html.window.localStorage['office'].toString())
          .snapshots(),
      builder: (context, snapshot) {
        List<TableRow> clientWidgets = [
          const TableRow(
            children: <Widget>[
              TcellHeader(
                txtcell: 'Beneficiary No.',
                heightcell: 50,
              ),
             
              TcellHeader(
                txtcell: 'Fullname',
                heightcell: 50,
              ),
             
              TcellHeader(
                txtcell: 'Needs',
                heightcell: 50,
              ),
            ],
          )
        ];

        if (snapshot.hasData) {
          final clients = snapshot.data?.docs.toList();
          var index = 0;
          for (var client in clients!) {
            index = index + 1;
            var txt = index.toString();
            final clientWidget = TableRow(
              children: <Widget>[
                TcellData(txtcell: client.id, heightcell: 50, pad: 15, fsize: 15),
                                TcellData(
                    txtcell: client['fullname'],
                    heightcell: 50,
                    pad: 15,
                    fsize: 15),   
                
                    TcellData(
                    txtcell: client['needs'],
                    heightcell: 50,
                    pad: 15,
                    fsize: 15),
               
              ],
            );
            clientWidgets.add(clientWidget);
          }
        }

        // return ListView(
        //   scrollDirection: Axis.vertical,
        //   shrinkWrap: true,
        //   children: clientWidgets,
        // );
        return Table(
          border: TableBorder.all(),
          columnWidths: const <int, TableColumnWidth>{
            //   0: FixedColumnWidth(MediaQuery.of(context).size.width * .14),
            //   1: FixedColumnWidth(MediaQuery.of(context).size.width * .14),
            //   2: FixedColumnWidth(MediaQuery.of(context).size.width * .14),
            //   3: FixedColumnWidth(MediaQuery.of(context).size.width * .14),
            //   4: FixedColumnWidth(MediaQuery.of(context).size.width * .14),
            //   5: FixedColumnWidth(MediaQuery.of(context).size.width * .14),
            //   6: FixedColumnWidth(MediaQuery.of(context).size.width * .14),

            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
            5: FlexColumnWidth(1),
            6: FlexColumnWidth(1),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: clientWidgets,
        );
      },
    );
  }
}