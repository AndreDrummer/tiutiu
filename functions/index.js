const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.createNotificationConfirmAdoption = functions.firestore
    .document('Users/{userId}/Pets/adopted/Adopteds/{id}')
    .onCreate(async(snap, context) => {            
        await admin.messaging().sendToDevice(`${snap.data()['interestedNotificationToken']}`, {            
            notification: {                
                title: 'Confirme adoção!',
                body: `${snap.data()['userThatDonate']} pediu que você confirme a adoção de ${snap.data()['petName']}.`,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'
            }
        })
    })

exports.createNotificationAdoptionConfirmed = functions.firestore
    .document('Users/{userId}/Pets/adopted/Adopteds/{id}')
    .onUpdate((change, context) => {        
        if(change.after.data()['confirmed'] === true) {
            admin.messaging().sendToDevice(`${change.after.data()['ownerNotificationToken']}`, {
                notification: {
                    title: 'Adoção confirmada!',
                    body: `${change.after.data()['userName']} confirmou a adoção de ${change.after.data()['petName']}.`,
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK'
                }
            })
        }
    })

exports.createNotificationAdoptionDenied = functions.firestore
    .document('Users/{userId}/Pets/posted/Donate/{petId}/adoptInteresteds/{id}')
    .onUpdate((change, context) => {        
        if (change.after.data()['gaveup'] === true) {
            admin.messaging().sendToDevice(`${change.after.data()['ownerNotificationToken']}`, {
                notification: {
                    title: 'Adoção NÃO confirmada!',
                    body: `${change.after.data()['userName']} negou que tenha adotado ${change.after.data()['petName']}.`,
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK'
                }
            })
        }
    })

exports.createNotificationWannaAdopt = functions.firestore
    .document('Users/{userId}/Pets/posted/Donate/{petId}/adoptInteresteds/{id}')
    .onCreate( async (snap, context) => {           
       await admin.messaging().sendToDevice(`${snap.data()['ownerNotificationToken']}`, {
            notification: {
                title: 'Quero adotar!',
                body: `${snap.data()['userName']} tem interesse na adoção de ${snap.data()['petName']}.`,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK',            
            }
        })
    })

exports.createNotificationInfo = functions.firestore
    .document('Users/{userId}/Pets/posted/Disappeared/{petId}/infoInteresteds/{id}')
    .onCreate((snap, context) => {        
        admin.messaging().sendToDevice(`${snap.data()['ownerNotificationToken']}`, {
            notification: {
                title: 'Informações sobre seu PET desaparecido',
                body: `${snap.data()['userName']} viu seu PET próximo a localização dele.`,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'
            }
        })
    })
