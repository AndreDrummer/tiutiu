const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.createNotificationConfirmAdoption = functions.firestore
    .document('Users/{userId}/Pets/adopted/Adopteds/{id}')
    .onCreate((snap, context) => {
        console.log(snap.data());
        admin.messaging().sendToTopic('confirmAdotpion', {
            notification: {
                title: 'Confirme adoção',
                body: 'Texto de confirmação',
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'
            }
        })
    })

exports.createNotificationAdoptionConfirmed = functions.firestore
    .document('Users/{userId}/Pets/posted/Donated/{petId}')
    .onUpdate((snap, context) => {
        console.log(snap.data());
        admin.messaging().sendToTopic('confirmAdotpion', {
            notification: {
                title: 'Doação confirmada',
                body: 'Texto de confirmação',
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'
            }
        })
    })

exports.createNotificationAdoptionDenied = functions.firestore
    .document('Users/{userId}/Pets/posted/Donated/{petId}/adoptInteresteds/{id}')
    .onUpdate((snap, context) => {
        console.log(snap.data());
        if (snap.data()['gaveup'] == true) {
            admin.messaging().sendToTopic('confirmAdotpion', {
                notification: {
                    title: 'Doação negada',
                    body: 'Texto de confirmação',
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK'
                }
            })
        }
    })

exports.createNotificationWannaAdopt = functions.firestore
    .document('Users/{userId}/Pets/posted/Donate/{petId}/adoptInteresteds/{id}')
    .onCreate((snap, context) => {
        console.log(snap.data());
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
        console.log(snap.data());
        admin.messaging().sendToTopic('petInfo', {
            notification: {
                title: 'Informações sobre seu PET desaparecido',
                body: 'Vi ele aqui aperto!',
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'
            }
        })
    })
