const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.createNotificationChat = functions.firestore
    .document('tiutiu/env/{environment}/contacts/{userId}/{contactId}/messages/{messageId}')
    .onCreate((snap, context) => {

        console.log(`>> Data ${JSON.stringify(snap.data())}`);
        console.log(`>> Params ${JSON.stringify(context.params)}`);
        console.log(`>> Resource ${JSON.stringify(context.resource)}`);

        let senderParamsUid = context.params['userId']
        let senderDataUid = snap.data()['sender']['uid']

        if (senderDataUid !== senderParamsUid) {
            admin.messaging().sendToDevice(`${snap.data()['receiver']['notificationToken']}`, {
                notification: {
                    title: `Nova mensagem de ${snap.data()['sender']['displayName']}`,
                    body: `${snap.data()['text']}`,
                },
                data: {
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK',
                    data: JSON.stringify(snap.data())
                }
            })
        }
    })