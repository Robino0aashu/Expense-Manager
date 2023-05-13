import './listitem.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function deleteTransaction;
  TransactionList(this.userTransactions, this.deleteTransaction);

  double _totalAmount() {
    double finalSum = 0;
    List<Transaction> thisMonthTransaction = userTransactions
        .where((chosenDate) => chosenDate.date.month == DateTime.now().month)
        .toList();
    for (int i = 0; i < thisMonthTransaction.length; i++) {
      finalSum += thisMonthTransaction[i].amount;
    }
    ;
    return finalSum;
  }

  @override
  Widget build(BuildContext context) {
    final isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return userTransactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraint) {
            return Column(
              children: [
                Text(
                  "No Transactions added yet!",
                  style: TextStyle(
                      fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: constraint.maxHeight * 0.6,
                    child: Image.asset('assets/images/waiting.png',
                        fit: BoxFit.cover)),
              ],
            );
          })
        : Stack(
            children: [
              ListView.builder(
                  itemBuilder: (ctx, index) {
                    // can alternatively use ListTile()
                    return ListItem(
                        userTransactions[index].id,
                        userTransactions[index].amount,
                        userTransactions[index].title,
                        userTransactions[index].date,
                        deleteTransaction);
                  },
                  itemCount: userTransactions.length),
              Positioned(
                bottom: 80,
                child: !isLandScape?Card(
                  elevation: 20,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.red, Colors.redAccent],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Total Amount spent: ${_totalAmount()}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ): Card(),
              ),
            ],
          );
  }
}
