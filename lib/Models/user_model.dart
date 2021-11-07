import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const NUMBER = 'number';
  static const ID = 'id';
  static const NAME = 'Name';

  String _number;
  String _id;
  String _name;

  String get number => _number;
  String get id => _id;
  String get name => _name;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    _number = snapshot.get('NUMBER');
    _id = snapshot.get('ID');
    _name = snapshot.get('NAME');
  }
}
