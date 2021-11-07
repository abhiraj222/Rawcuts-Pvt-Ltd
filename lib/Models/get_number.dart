import 'package:cloud_firestore/cloud_firestore.dart';

String queryString = 'number';
getPhNum() async {
  var orderPhoneNumber;
  var collection = FirebaseFirestore.instance.collection('Users');
  var querySnapshot =
      await collection.where('number', isEqualTo: queryString).get();

  for (var snapshot in querySnapshot.docs) {
    Map<String, dynamic> data = snapshot.data();
    orderPhoneNumber = await data['number'];
  }
  return orderPhoneNumber;
}
