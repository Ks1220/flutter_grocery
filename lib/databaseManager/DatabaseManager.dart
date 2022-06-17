import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {
  final CollectionReference groceryList =
      FirebaseFirestore.instance.collection('Items');
  final CollectionReference orderList =
      FirebaseFirestore.instance.collection('MerchantOrders');

  Future getGroceryList(currentUser) async {
    List itemsList = [];

    try {
      Query query = groceryList
          .doc(currentUser!.uid)
          .collection('Item')
          .orderBy("itemName");
      await query.get().then((docs) {
        docs.docs.forEach((doc) {
          itemsList.add(doc);
        });
      });

      return itemsList;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Stream? getOrderList(uid) {
    try {
      Query query = orderList.doc(uid).collection('Items').orderBy("userId");
      return query.snapshots();
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
