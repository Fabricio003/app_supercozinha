import 'package:firebase_database/firebase_database.dart';

final databaseReference = FirebaseDatabase.instance.ref();

void readData() {
  databaseReference.child("1").onValue.listen((DatabaseEvent event) {
    print('Data: ${event.snapshot.value}');
  });
}
