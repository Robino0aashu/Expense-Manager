import './listitem.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function deleteTransaction;
  TransactionList(this.userTransactions, this.deleteTransaction);
  @override
  Widget build(BuildContext context) {
    return userTransactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraint){
          return Column(
            children: [
              Text("No Transactions added yet!", 
              style: TextStyle(fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
              Container(
                height: constraint.maxHeight*0.6,
                  child: Image.asset('assets/images/waiting.png',
                      fit: BoxFit.cover)),
            ],
          );
        })
        : ListView.builder(
            itemBuilder: (ctx, index) {
              // can alternatively use ListTile()
              return ListItem(
                  userTransactions[index].id,
                  userTransactions[index].amount,
                  userTransactions[index].title,
                  userTransactions[index].date,
                  deleteTransaction);
            },
            itemCount: userTransactions.length);
  }
}
