const functions = require('firebase-functions');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');

// Initialize Firebase Admin
admin.initializeApp();

// Email configuration (you'll need to set up your email service)
const transporter = nodemailer.createTransporter({
  service: 'gmail', // or your preferred email service
  auth: {
    user: functions.config().email.user, // Set with: firebase functions:config:set email.user="your-email@gmail.com"
    pass: functions.config().email.password, // Set with: firebase functions:config:set email.password="your-app-password"
  },
});

// Send email notification
exports.sendEmailNotification = functions.firestore
  .document('email_notifications/{notificationId}')
  .onCreate(async (snap, context) => {
    const notification = snap.data();
    
    try {
      const mailOptions = {
        from: functions.config().email.user,
        to: notification.email,
        subject: notification.subject,
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <div style="background: linear-gradient(135deg, #ff6b9d, #c44569); padding: 20px; text-align: center;">
              <h1 style="color: white; margin: 0;">🐾 PawfectCare</h1>
            </div>
            <div style="padding: 20px; background: #f8f9fa;">
              <div style="background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                ${notification.body.replace(/\n/g, '<br>')}
              </div>
              <div style="text-align: center; margin-top: 20px; color: #666;">
                <p>Thank you for using PawfectCare!</p>
                <p>Visit our app for more pet care tips and services.</p>
              </div>
            </div>
          </div>
        `,
      };

      await transporter.sendMail(mailOptions);
      
      // Update notification status
      await snap.ref.update({
        status: 'sent',
        sentAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      
      console.log('Email sent successfully to:', notification.email);
    } catch (error) {
      console.error('Error sending email:', error);
      
      // Update notification status
      await snap.ref.update({
        status: 'failed',
        error: error.message,
        failedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }
  });

// Send push notification
exports.sendPushNotification = functions.https.onCall(async (data, context) => {
  const { userId, title, body, data: notificationData } = data;
  
  try {
    // Get user's FCM tokens
    const userDoc = await admin.firestore().collection('users').doc(userId).get();
    if (!userDoc.exists) {
      throw new functions.https.HttpsError('not-found', 'User not found');
    }
    
    const userData = userDoc.data();
    const fcmTokens = userData.fcmTokens || [];
    
    if (fcmTokens.length === 0) {
      throw new functions.https.HttpsError('failed-precondition', 'No FCM tokens found');
    }
    
    // Send notification to all user's devices
    const messages = fcmTokens.map(token => ({
      token: token,
      notification: {
        title: title,
        body: body,
      },
      data: notificationData || {},
    }));
    
    const response = await admin.messaging().sendAll(messages);
    console.log('Successfully sent messages:', response);
    
    return { success: true, response: response };
  } catch (error) {
    console.error('Error sending push notification:', error);
    throw new functions.https.HttpsError('internal', error.message);
  }
});

// Notify users about new pet
exports.notifyNewPet = functions.firestore
  .document('pets/{petId}')
  .onCreate(async (snap, context) => {
    const pet = snap.data();
    
    try {
      // Get all users who have new pet notifications enabled
      const usersSnapshot = await admin.firestore()
        .collection('users')
        .where('notificationSettings.newPets', '==', true)
        .get();
      
      const notifications = [];
      
      for (const userDoc of usersSnapshot.docs) {
        const userData = userDoc.data();
        const fcmTokens = userData.fcmTokens || [];
        
        if (fcmTokens.length > 0) {
          // Send push notification
          const messages = fcmTokens.map(token => ({
            token: token,
            notification: {
              title: 'New Pet Available! 🐾',
              body: `${pet.name} (${pet.species}) is now available for adoption`,
            },
            data: {
              type: 'new_pet',
              petId: context.params.petId,
              petName: pet.name,
              petType: pet.species,
            },
          }));
          
          await admin.messaging().sendAll(messages);
        }
        
        // Send email notification if enabled
        if (userData.notificationSettings?.emailNotifications === true && userData.email) {
          notifications.push({
            email: userData.email,
            subject: `New Pet Available - ${pet.name}`,
            body: `
Hello ${userData.name},

Great news! A new pet is now available for adoption:

🐾 Pet Name: ${pet.name}
🐕 Species: ${pet.species}
🐕 Breed: ${pet.breed}
🏠 Age: ${pet.age} years old
💚 Health Status: ${pet.healthStatus}
💰 Adoption Fee: $${pet.adoptionFee}

${pet.description}

Visit the app to learn more about this adorable pet and start the adoption process!

Best regards,
PawfectCare Team
            `,
            data: {
              type: 'new_pet',
              petId: context.params.petId,
              petName: pet.name,
              petType: pet.species,
            },
          });
        }
      }
      
      // Send email notifications
      for (const notification of notifications) {
        await admin.firestore().collection('email_notifications').add(notification);
      }
      
      console.log(`Notified ${usersSnapshot.docs.length} users about new pet: ${pet.name}`);
    } catch (error) {
      console.error('Error notifying users about new pet:', error);
    }
  });

// Handle adoption request
exports.handleAdoptionRequest = functions.firestore
  .document('adoptions/{adoptionId}')
  .onCreate(async (snap, context) => {
    const adoption = snap.data();
    
    try {
      // Get pet information
      const petDoc = await admin.firestore().collection('pets').doc(adoption.petId).get();
      if (!petDoc.exists) {
        throw new Error('Pet not found');
      }
      
      const pet = petDoc.data();
      
      // Get shelter information
      const shelterDoc = await admin.firestore().collection('shelters').doc(pet.shelterId).get();
      if (!shelterDoc.exists) {
        throw new Error('Shelter not found');
      }
      
      const shelter = shelterDoc.data();
      
      // Send email to shelter
      await admin.firestore().collection('email_notifications').add({
        email: shelter.email,
        subject: `New Adoption Request - ${pet.name}`,
        body: `
Hello ${shelter.name},

You have received a new adoption request:

🐾 Pet: ${pet.name} (${pet.species} - ${pet.breed})
👤 Adopter: ${adoption.adopterName}
📧 Email: ${adoption.adopterEmail}
📞 Phone: ${adoption.adopterPhone}
💭 Reason: ${adoption.adoptionReason}

Please review this request and contact the adopter to proceed with the adoption process.

Best regards,
PawfectCare Team
        `,
        data: {
          type: 'adoption_request',
          adoptionId: context.params.adoptionId,
          petId: adoption.petId,
          petName: pet.name,
          adopterName: adoption.adopterName,
          adopterEmail: adoption.adopterEmail,
        },
      });
      
      console.log(`Adoption request notification sent to shelter: ${shelter.name}`);
    } catch (error) {
      console.error('Error handling adoption request:', error);
    }
  });

// Clean up old notifications
exports.cleanupOldNotifications = functions.pubsub
  .schedule('0 2 * * *') // Run daily at 2 AM
  .onRun(async (context) => {
    try {
      const thirtyDaysAgo = new Date();
      thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
      
      const oldNotifications = await admin.firestore()
        .collection('notifications')
        .where('createdAt', '<', thirtyDaysAgo)
        .get();
      
      const batch = admin.firestore().batch();
      
      oldNotifications.docs.forEach(doc => {
        batch.delete(doc.ref);
      });
      
      await batch.commit();
      
      console.log(`Cleaned up ${oldNotifications.docs.length} old notifications`);
    } catch (error) {
      console.error('Error cleaning up old notifications:', error);
    }
  });

// Send appointment reminders
exports.sendAppointmentReminders = functions.pubsub
  .schedule('0 9 * * *') // Run daily at 9 AM
  .onRun(async (context) => {
    try {
      const tomorrow = new Date();
      tomorrow.setDate(tomorrow.getDate() + 1);
      tomorrow.setHours(0, 0, 0, 0);
      
      const dayAfter = new Date(tomorrow);
      dayAfter.setDate(dayAfter.getDate() + 1);
      
      // Get appointments for tomorrow
      const appointmentsSnapshot = await admin.firestore()
        .collection('appointments')
        .where('appointmentDate', '>=', tomorrow)
        .where('appointmentDate', '<', dayAfter)
        .where('status', '==', 'confirmed')
        .get();
      
      for (const appointmentDoc of appointmentsSnapshot.docs) {
        const appointment = appointmentDoc.data();
        
        // Get user information
        const userDoc = await admin.firestore().collection('users').doc(appointment.userId).get();
        if (!userDoc.exists) continue;
        
        const user = userDoc.data();
        
        // Send reminder notification
        if (user.notificationSettings?.appointments === true) {
          const fcmTokens = user.fcmTokens || [];
          
          if (fcmTokens.length > 0) {
            const messages = fcmTokens.map(token => ({
              token: token,
              notification: {
                title: 'Appointment Reminder 📅',
                body: `Don't forget your appointment tomorrow for ${appointment.petName}`,
              },
              data: {
                type: 'appointment_reminder',
                appointmentId: appointmentDoc.id,
                petName: appointment.petName,
                appointmentType: appointment.appointmentType,
              },
            }));
            
            await admin.messaging().sendAll(messages);
          }
          
          // Send email reminder
          if (user.notificationSettings?.emailNotifications === true && user.email) {
            await admin.firestore().collection('email_notifications').add({
              email: user.email,
              subject: 'Appointment Reminder - Tomorrow',
              body: `
Hello ${user.name},

This is a reminder about your upcoming appointment:

🐾 Pet: ${appointment.petName}
🏥 Type: ${appointment.appointmentType}
📅 Date: Tomorrow
⏰ Time: ${appointment.appointmentTime}

Please arrive 10 minutes early for your appointment.

Best regards,
PawfectCare Team
              `,
              data: {
                type: 'appointment_reminder',
                appointmentId: appointmentDoc.id,
                petName: appointment.petName,
                appointmentType: appointment.appointmentType,
              },
            });
          }
        }
      }
      
      console.log(`Sent reminders for ${appointmentsSnapshot.docs.length} appointments`);
    } catch (error) {
      console.error('Error sending appointment reminders:', error);
    }
  });
