import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../model/contact_model.dart';
import '../provider/contact_provider.dart';
import '../utils/helper_function.dart';

class ContactDetails extends StatefulWidget {
  static const String routeName = '/detais';
  const ContactDetails({super.key});

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  late ContactModel contactModel;
  late ContactProvider contactProvider;
  bool isFirst = true;
  @override
  void didChangeDependencies() {
    if (isFirst) {
      contactProvider = Provider.of<ContactProvider>(context);
      contactModel = ModalRoute.of(context)!.settings.arguments as ContactModel;
      isFirst = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contactModel.name),
      ),
      body: FutureBuilder<ContactModel>(
        future: contactProvider.getContactById(contactModel.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final contact = snapshot.data!;
            return ListView(
              children: [
                contact.image.isEmpty
                    ? Image.asset(
                        'images/placeholder.png',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(contact.image),
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                ListTile(
                  leading: IconButton(
                    onPressed: () {
                      showSingleTextInputDialog(
                        context: context,
                        title: 'Mobile',
                        inputType: TextInputType.phone,
                        onUpdate: (value) {
                          contactProvider
                              .updateContact(
                                contact.id,
                                tblContactColMobile,
                                value,
                              )
                              .then((value) => setState(() {}));
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  title: Text(contact.mobile),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          _callContact(contact.mobile);
                        },
                        icon: const Icon(Icons.call),
                      ),
                      IconButton(
                        onPressed: () {
                          _sendSms(contact.mobile);
                        },
                        icon: const Icon(Icons.sms),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: IconButton(
                    onPressed: () {
                      showSingleTextInputDialog(
                        context: context,
                        title: 'Email',
                        inputType: TextInputType.emailAddress,
                        onUpdate: (value) {
                          contactProvider
                              .updateContact(
                                contact.id,
                                tblContactColEmail,
                                value,
                              )
                              .then((value) => setState(() {}));
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  title: Text(contact.email.isEmpty
                      ? 'Email not set yet'
                      : contact.email),
                  trailing: IconButton(
                    onPressed: () {
                      if (contact.email.isEmpty) {
                        showMsg(context, 'Please add an email first');
                        return;
                      }
                      _sendEmail(contact.email);
                    },
                    icon: const Icon(Icons.email),
                  ),
                ),
                ListTile(
                  leading: IconButton(
                    onPressed: () {
                      showSingleTextInputDialog(
                        context: context,
                        title: 'Address',
                        inputType: TextInputType.streetAddress,
                        onUpdate: (value) {
                          contactProvider
                              .updateContact(
                                contact.id,
                                tblContactColAddress,
                                value,
                              )
                              .then((value) => setState(() {}));
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  title: Text(contact.address.isEmpty
                      ? 'Address not set yet'
                      : contact.address),
                  trailing: IconButton(
                    onPressed: () {
                      if (contact.address.isEmpty) {
                        showMsg(context, 'Please add an address first');
                        return;
                      }
                      _showAddressOnMap(contact.address);
                    },
                    icon: const Icon(Icons.location_on),
                  ),
                ),
                ListTile(
                  leading: IconButton(
                    onPressed: () {
                      showSingleTextInputDialog(
                        context: context,
                        title: 'Website',
                        onUpdate: (value) {
                          contactProvider
                              .updateContact(
                                contact.id,
                                tblContactColWeb,
                                value,
                              )
                              .then((value) => setState(() {}));
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  title: Text(contact.website.isEmpty
                      ? 'Website not set yet'
                      : contact.website),
                  trailing: IconButton(
                    onPressed: () {
                      if (contact.website.isEmpty) {
                        showMsg(context, 'Please add a website first');
                        return;
                      }
                      _showSiteOnBrowser(contact.website);
                    },
                    icon: const Icon(Icons.web),
                  ),
                ),
              ],
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to fetch data'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  void _callContact(String mobile) async {
    final url = 'tel:$mobile';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Could not perform this operation');
    }
  }

  void _sendSms(String mobile) async {
    final url = 'sms:$mobile';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Could not perform this operation');
    }
  }

  void _sendEmail(String email) async {
    final url = 'mailto:$email';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Could not perform this operation');
    }
  }

  void _showAddressOnMap(String address) async {
    String url = '';
    if (Platform.isAndroid) {
      url = 'geo:0,0?q=$address';
    } else {
      url = 'http://maps.apple.com/?q=$address';
    }
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Could not perform this operation');
    }
  }

  void _showSiteOnBrowser(String website) async {
    final url = 'https://$website';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Could not perform this operation');
    }
  }
}
