const functions = require('firebase-functions');

exports.createNotificationAdopted = functions.firestore
    .document('Users/{userId}/Pets/adopted')
    .onCreate((snap, context) => {
        console.log(snap.data);
        // const newValue = snap.data()
        // const name = newValue.name
    })