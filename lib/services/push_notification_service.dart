import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService
{
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    print("Handling a background message: ${message.messageId}");
  }
  Future initialize() async{
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  }

}