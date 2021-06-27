// Future<void> sendEmail() async {
//   final mailOptions = MailOptions(
//     body: 'Hello Nagesh.',
//     subject: 'Test Message',
//     recipients: ['18h61a0521@cvsr.ac.in'],
//     isHTML: true,
//     //bccRecipients: ['other@example.com'],
//     //ccRecipients: ['third@example.com'],
//     attachments: [
//       'path/to/image.png',
//     ],
//   );

//   try {
//     final res = await FlutterMailer.send(mailOptions);
//     switch (res) {
//       case MailerResponse.sent:
//         print('Mail Sent');
//         break;

//       case MailerResponse.saved:
//         print('Mail saved as draft');
//         break;

//       case MailerResponse.cancelled:
//         print('Mail cancelled');
//         break;

//       case MailerResponse.android:
//         print('Action successfull');
//         break;

//       default:
//         print('Unknown error');
//         break;
//     }
//   } on PlatformException catch (e) {
//     print(e.toString());
//   }
// }

// sendEmail() async {
//   String username = 'nahara542120@gmail.com';
//   String password = 'n54h21r20';

//   SmtpServer smtpServer = gmailSaslXoauth2(username,
//       "ya29.a0AfH6SMCxu2ag_GomsglVbBZAo8vZVlwjtLmi0QZ7KQAlvK3vUA2DSOJtKx-sLLo3lGDzuEOP-bIfnspbHvy1bTZHdGJt2sbNUZAoXiqGeDp9VNz2dyGQ212stvfIxmTZZQxM7U-5F18Tvfjo-lgfRD56KWSs");
//   // SmtpServer smtpServer = SmtpServer(
//   //   'smtp.gmail.com',
//   //   username: username,
//   //   password: password,
//   //   xoauth2Token:
//   //       "ya29.a0AfH6SMCxu2ag_GomsglVbBZAo8vZVlwjtLmi0QZ7KQAlvK3vUA2DSOJtKx-sLLo3lGDzuEOP-bIfnspbHvy1bTZHdGJt2sbNUZAoXiqGeDp9VNz2dyGQ212stvfIxmTZZQxM7U-5F18Tvfjo-lgfRD56KWSs",
//   //   ssl: true,
//   //   port: 465,
//   //   //ssl: true,
//   //   //ignoreBadCertificate: true,
//   // );
//   // Use the SmtpServer class to configure an SMTP server:
//   // final smtpServer = SmtpServer('smtp.domain.com');
//   // See the named arguments of SmtpServer for further configuration
//   // options.

//   // Create our message.
//   final message = Message()
//     ..from = Address(username, 'Harsha')
//     ..recipients.add('18h61a0520@cvsr.ac.in')
//     // ..ccRecipients.addAll(['18h61a0554@cvsr.ac.in'])
//     //..bccRecipients.add(Address('bccAddress@example.com'))
//     ..subject = 'Good morning from bhuvika 😀 :: ${DateTime.now()}'
//     ..text = 'This is the plain text.\nThis is line 2 of the text part.';

//   ///..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

//   try {
//     final sendReport = await send(message, smtpServer);
//     print('Message sent: ' + sendReport.toString());
//   } on MailerException catch (e) {
//     print('Message not sent.');
//     for (var p in e.problems) {
//       print('Problem: ${p.code}: ${p.msg}');
//     }
//   }
//   // DONE

//   // Let's send another message using a slightly different syntax:
//   //
//   // Addresses without a name part can be set directly.
//   // For instance `..recipients.add('destination@example.com')`
//   // If you want to display a name part you have to create an
//   // Address object: `new Address('destination@example.com', 'Display name part')`
//   // Creating and adding an Address object without a name part
//   // `new Address('destination@example.com')` is equivalent to
//   // adding the mail address as `String`.
//   // final equivalentMessage = Message()
//   //   ..from = Address(username, 'Your name 😀')
//   //   ..recipients.add(Address('destination@example.com'))
//   //   ..ccRecipients.addAll([Address('destCc1@example.com'), 'destCc2@example.com'])
//   //   ..bccRecipients.add('bccAddress@example.com')
//   //   ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
//   //   ..text = 'This is the plain text.\nThis is line 2 of the text part.'
//   //   ..html = '<h1>Test</h1>\n<p>Hey! Here is some HTML content</p><img src="cid:myimg@3.141"/>'
//   //   ..attachments = [
//   //     FileAttachment(File('exploits_of_a_mom.png'))
//   //       ..location = Location.inline
//   //       ..cid = '<myimg@3.141>'
//   //   ];

//   // final sendReport2 = await send(equivalentMessage, smtpServer);

//   // Sending multiple messages with the same connection
//   //
//   // Create a smtp client that will persist the connection
//   var connection = PersistentConnection(smtpServer);

//   // Send the first message
//   await connection.send(message);

//   // send the equivalent message
//   //await connection.send(equivalentMessage);

//   // close the connection
//   await connection.close();
// }
