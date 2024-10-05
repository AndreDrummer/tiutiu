const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");

admin.initializeApp();

exports.createNotificationChat = functions.firestore
    .document("tiutiu/env/{environment}/contacts/{userId}/{contactId}/messages/{messageId}")
    .onCreate(async (snap, context) => {
      console.log(`>> Data ${JSON.stringify(snap.data())}`);
      console.log(`>> Params ${JSON.stringify(context.params)}`);
      console.log(`>> Resource ${JSON.stringify(context.resource)}`);

      const senderParamsUid = context.params["userId"];
      const senderDataUid = snap.data()["sender"]["uid"];

      console.log(`>> Should try to send the message ${senderDataUid !== senderParamsUid}`);

      if (senderDataUid != senderParamsUid) {
        const notificationToken = snap.data()["receiver"]["notificationToken"];
        if (!notificationToken) {
          console.log("No notification token found for receiver.");
          return;
        }

        const payload = {
          notification: {
            title: `Nova mensagem de ${snap.data()["sender"]["displayName"]}`,
            body: snap.data()["text"] || "Você recebeu uma nova mensagem.",
          },
          data: {
            clickAction: "FLUTTER_NOTIFICATION_CLICK",
            data: JSON.stringify(snap.data()),
          },
          token: `${snap.data()["receiver"]["notificationToken"]}`,
        };

        try {
          const response = await admin.messaging().send(payload);
          console.log("Successfully sent message:", response);
        } catch (error) {
          console.log("Error sending message:", error);
        }
      }
    });


exports.deletePostOnDennouncesLimitAchived = functions.firestore
    .document("tiutiu/env/{environment}/posts/posts/{postId}")
    .onUpdate((change, context) => {
    // Get an object representing the document
    // e.g. {'name': 'Marie', 'age': 66}
      const newValue = change.after.data();

      // access a particular field as you would any JS property
      const timesDennounced = newValue.timesDennounced;

      if (timesDennounced > 3) {
        change.after.ref.delete();
      }
    });

exports.updatePostReferenceOnCreate = functions.firestore
    .document("tiutiu/env/{environment}/posts/posts/{postId}")
    .onWrite((snap, _) => {
      snap.after.ref.update({"reference": snap.after.ref.path});
    });

