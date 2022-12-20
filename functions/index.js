const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.createNotificationChat = functions.firestore
    .document('tiutiu/env/{environment}/contacts/{userId}/{contactId}/messages/{messageId}')
    .onCreate((snap, context) => {

        console.log(`>> Data ${snap.data()}`);
        console.log(`>> Resource ${context.resource}`);
        console.log(`>> Resource ${context.resource}`);
        
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
    })