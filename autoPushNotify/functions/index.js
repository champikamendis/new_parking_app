const functions = require('firebase-functions');

const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

var msgData;

exports.bookedTrigger = functions.firestore.document('booked/{bookedId}').onCreate((snapshot, context) => {

    msgData = snapshot.data();

    admin.firestore().collection('pushtokens').get().then((snapshots) => {
        var tokens = [];
        if (snapshots.empty) {
            console.log('No devices');
        }
        else {
            for (var token of snapshots.docs) {
                tokens.push(token.data().devtoken);
            }
            var payload = {
                "notification": {
                    "title": "From" + msgData.parkingName,
                    "body": "UserID" + msgData.userID,
                    "sound": "default"
                },
                "data": {
                    "sendername": msgData.parkingName,
                    "message": msgData.userID,
                    // "message": "Dear Customer you have successfully booked our parking with your id- $msgData.offerValue",
                }
            }

            return admin.messaging().sendToDevice(tokens, payload).then((response) => {
                console.log('Pushed them all');
            }).catch((err) => {
                console.log(err);
            })
        }

    })
});
