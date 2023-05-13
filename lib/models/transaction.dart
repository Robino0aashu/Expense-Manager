import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

const uuid=Uuid();
class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  Transaction({
    String id,
     this.title,
    this.amount,
    this.date,
  }):id=id ?? uuid.v4() ;
}
