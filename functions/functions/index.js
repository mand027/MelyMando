const functions = require('firebase-functions')
const admin = require('firebase-admin')
admin.initializeApp()


exports.sendNotificationChat = functions.firestore
  .document('messages/{groupId1}/{groupId2}/{message}')
  .onCreate((snap, context) => {
    console.log('----------------start function--------------------')
    console.log('----------------test--------------------')
    const doc = snap.data()
    console.log(doc)

    const idFrom = doc.idFrom
    const idTo = doc.idTo
    const contentMessage = doc.content

    // Get push token user to (receive)
    admin
      .firestore()
      .collection('users')
      .where('id', '==', idTo)
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(userTo => {
          console.log('----------------test1--------------------')
          console.log(`Found user to: ${userTo.data().nombre}`)
          console.log(`Found user to Push Token: ${userTo.data().pushToken}`)
          const auxTargetToken = userTo.data().pushToken
          if (auxTargetToken !== idFrom) {
            // Get info user from (sent)
            admin
              .firestore()
              .collection('users')
              .doc('id', '==', idFrom)
              .get()
              .then(querySnapshot2 => {
                querySnapshot2.forEach(userFrom => {
                  console.log('----------------test1--------------------')
                  console.log(`Found user from: ${userFrom.data().nombre}`)
                  console.log(`Found user from Push Token: ${userTo.data().pushToken}`)
                  const payload = {
                    notification: {
                      title: `Tienes un mensaje de "${userFrom.data().nombre}"`,
                      body: contentMessage,
                      badge: '1',
                      sound: 'default'
                    }
                  }
                  // Let push to the target device
                  admin
                    .messaging()
                    .sendToDevice(auxTargetToken, payload)
                    .then(response => {
                      console.log('Successfully sent message:', response)
                    })
                    .catch(error => {
                      console.log('Error sending message:', error)
                    })
                })
              })
          } else {
            console.log('Can not find pushToken target user')
          }
        })
      })
    return null
  })
