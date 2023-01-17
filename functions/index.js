const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.createNotificationChat = functions.firestore
    .document('tiutiu/env/{environment}/contacts/{userId}/{contactId}/messages/{messageId}')
    .onCreate((snap, context) => {

        let senderParamsUid = context.params['userId']
        let senderDataUid = snap.data()['sender']['uid']

        if (senderDataUid !== senderParamsUid) {
            admin.messaging().sendToDevice(`${snap.data()['receiver']['notificationToken']}`, {
                notification: {
                    title: `Nova mensagem de ${snap.data()['sender']['displayName']}`,
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK',
                    body: `${snap.data()['text']}`,
                },
                data: {
                    data: JSON.stringify(snap.data())
                }
            })
        }
    })

exports.deletePostOnDennouncesLimitAchived = functions.firestore
    .document('tiutiu/env/{environment}/posts/posts/{postId}')
    .onUpdate((change, _) => {
        // Get an object representing the document
        // e.g. {'name': 'Marie', 'age': 66}
        const newValue = change.after.data();

        // access a particular field as you would any JS property
        const timesDennounced = newValue.timesDennounced;

        if (timesDennounced > 3) {
            change.after.ref.delete();
        }
    });