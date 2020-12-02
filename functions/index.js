const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.createNotificationConfirmAdoption = functions.firestore
    .document('Adopted/{id}')
    .onCreate(async (snap, context) => {
        await admin.messaging().sendToDevice(`${snap.data()['interestedNotificationToken']}`, {
            notification: {
                title: 'Confirme adoção!',
                body: `${snap.data()['ownerName']} aceitou seu pedido de adoção. Confirme para adotar o PET ${snap.data()['name']}.`,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'
            },
            data: {
                data: JSON.stringify(snap.data())
            }
        })
    })

exports.createNotificationAdoptionConfirmed = functions.firestore
    .document('Adopted/{id}')
    .onUpdate((change, context) => {
        if (change.after.data()['confirmed'] === true) {
            admin.messaging().sendToDevice(`${change.after.data()['ownerNotificationToken']}`, {
                notification: {
                    title: 'Adoção confirmada!',
                    body: `${change.after.data()['interestedName']} confirmou a adoção de ${change.after.data()['name']}.`,
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK'
                },
                data: {
                    data: JSON.stringify(change.after.data())
                }
            })
        }
    })

exports.createNotificationAdoptionDenied = functions.firestore
    .document('Adopted/{id}')
    .onUpdate((snap, context) => {
        if (snap.after.data()['gaveup'] === true) {
            admin.messaging().sendToDevice(`${snap.after.data()['ownerNotificationToken']}`, {
                notification: {
                    title: 'Adoção NÃO confirmada!',
                    body: `${snap.after.data()['interestedName']} negou que tenha adotado ${snap.after.data()['name']}.`,
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK'
                },
                data: {
                    data: JSON.stringify(snap.after.data())
                }
            })
        }

    })

exports.createNotificationWannaAdopt = functions.firestore
    .document('Donate/{petId}/adoptInteresteds/{id}')
    .onCreate(async (snap, context) => {
        await admin.messaging().sendToDevice(`${snap.data()['ownerNotificationToken']}`, {
            notification: {
                title: 'Quero adotar!',
                body: `${snap.data()['interestedName']} tem interesse na adoção de ${snap.data()['petName']}.`,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK',
            },
            data: {
                data: JSON.stringify(snap.data())
            }
        })
    })

exports.createNotificationInfo = functions.firestore
    .document('Disappeared/{petId}/infoInteresteds/{id}')
    .onCreate((snap, context) => {
        admin.messaging().sendToDevice(`${snap.data()['ownerNotificationToken']}`, {
            notification: {
                title: 'Informações sobre seu PET desaparecido',
                body: `${snap.data()['interestedName']} viu seu PET próximo a localização dele.`,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK'
            },
            data: {
                data: JSON.stringify(snap.data())
            }
        })
    })


module.exports.storage = functions.runWith({ memory: "2GB", timeoutSeconds: functions.MAX_TIMEOUT_SECONDS }).pubsub.schedule('0 0 * * 6').onRun(async context => {

    const users = await admin.firestore().collection('Users').get();
    let ids = [];

    users.forEach(async user => {
        let userData = user.data();
        let doNotNeedClean = false;

        const disappeared = await admin.firestore().collection('Disappeared').get();

        disappeared.forEach((pet) => {
            const data = pet.data();
            if (data.ownerId === userData.uid) {
                doNotNeedClean = true;
            }
        });

        if (!doNotNeedClean) {
            const donate = await admin.firestore().collection('Donate').get();
            donate.forEach((pet) => {
                const data = pet.data();
                if (data.ownerId === userData.uid) {
                    doNotNeedClean = true;
                }
            });
        }

        if (!doNotNeedClean) {
            ids.push(userData.uid);

            userData.photoURL = null;
            await user.ref.set(userData, { merge: true });
        }
    });

    const bucket = admin.storage().bucket();

    console.log(ids.length);

    ids.forEach((id) => {
        bucket.getFiles({
            prefix: `${id}/avatar`
        }, function (err, files) {
            if (!err) {
                files.forEach((file) => {
                    console.log(file);
                });
            }
        });


    })
    return null;
});