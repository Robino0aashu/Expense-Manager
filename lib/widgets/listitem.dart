import 'package:expense_manager/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListItem extends StatelessWidget {
  String id;
  double price;
  String title;
  DateTime date;
  Transaction T;
  Function del;
  ListItem(this.id, this.price, this.title, this.date, this.del);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromRGBO(87, 191, 156, 1),
      elevation: 20,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
            child: Row(
          children: [
            Container(
              child: Text(
                '  \₹ ${price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color.fromRGBO(12, 12, 10, 1),
                ),
              ),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red,
                  width: 2,
                ),
              ),
              padding: EdgeInsets.all(10),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color.fromRGBO(12, 12, 10, 1),
                    ),
                  ),
                  margin: EdgeInsets.all(2),
                ),
                Container(
                  child: Text(
                    DateFormat.yMMMMd().format(date),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(0, 56, 62, 1),
                    ),
                  ),
                  padding: EdgeInsets.all(5),
                ),
              ],
            ),
          ],
        )),
        Container(
          child: IconButton(
            
            onPressed: () {
              del(id);
            },
            icon: Icon(Icons.delete,color: Colors.red[700],),
          ),
        )
      ]),
    );
  }
}
