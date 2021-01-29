
import 'package:cloud_firestore/cloud_firestore.dart';

class AttachDoc {
  final String docTitle;
  final String docTime;
  final String docUrl;
  final String docId;

  AttachDoc({
    this.docTitle,
    this.docTime,
    this.docUrl,
    this.docId,
  });

  Map<String, dynamic> toMap() {
    return {
      'docTitle': docTitle,
      'docTime': docTime,
      'docUrl': docUrl,
      'docId': docId,
    };
  }

  factory AttachDoc.fromMap(DocumentSnapshot map) {
    if (map == null) return null;

    return AttachDoc(
      docTitle: map.data()['docTitle'],
      docTime: map.data()['docTime'],
      docUrl: map.data()['docUrl'],
      docId: map['docId'],
    );
  }
}
