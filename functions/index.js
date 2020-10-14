const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.createNotificationConfirmAdoption = functions.firestore
    .document('Users/{userId}/Pets/adopted')
    .onCreate((snap, context) => {
        admin.messaging().sendToTopic('confirmAdotpion', {
            notification: {
                title: 'Confirme adoção',
                body: 'Texto de confirmação',
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'
            }
        })
    })

exports.createNotificationWannaAdopt = functions.firestore
    .document('Users/{userId}/Pets/posted/Donate/{petId}/adoptInteresteds/{id}')
    .onCreate((snap, context) => {
        admin.messaging().sendToTopic('wannaAdopt', {
            notification: {
                title: 'Quero adotar',
                body: 'Tem alguém interessado em adotar um dos seus PETS.',
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'
            }
        })
    })

exports.createNotificationInfo = functions.firestore
    .document('Users/{userId}/Pets/posted/Disappeared/{petId}/infoInteresteds/{id}')
    .onCreate((snap, context) => {
        admin.messaging().sendToTopic('petInfo', {
            notification: {
                title: 'Informações sobre seu PET desaparecido',
                body: 'Vi ele aqui aperto!',
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'
            }
        })
    })
