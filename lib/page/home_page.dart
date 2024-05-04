import 'package:contact_card_scanner/page/contact_details_page.dart';
import 'package:contact_card_scanner/page/contact_form_page.dart';
import 'package:contact_card_scanner/page/scan_page.dart';
import 'package:contact_card_scanner/provider/contact_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../model/contact_model.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  @override
  void didChangeDependencies() {
    Provider.of<ContactProvider>(context, listen: false).getAllContacts();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            ScanPage.routeName,
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.contacts), label: 'All Contacts'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
          _fetchData();
        },
      ),
      appBar: AppBar(
        title: const Text('Contact List'),
      ),
      extendBody: true,
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.contactList.length,
          itemBuilder: (context, index) {
            final contact = provider.contactList[index];
            return Dismissible(
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
              confirmDismiss: showDeleteConfirmationDialog,
              onDismissed: (_) {
                provider.delete(contact.id);
              },
              key: UniqueKey(),
              child: ListTile(
                onTap: () => Navigator.pushNamed(
                  context,
                  ContactDetails.routeName,
                  arguments: contact,
                ),
                title: Text(contact.name),
                trailing: IconButton(
                  onPressed: () {
                    final value = contact.favorite ? 0 : 1;
                    provider.updateContact(
                        contact.id, tblContactColFavorite, value);
                  },
                  icon: Icon(contact.favorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<bool?> showDeleteConfirmationDialog(DismissDirection direction) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Confirm Delete'),
              content: const Text('Are you sure to delete this contact?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('YES'),
                ),
              ],
            ));
  }

  void _fetchData() {
    if (index == 0) {
      Provider.of<ContactProvider>(context, listen: false).getAllContacts();
    } else {
      Provider.of<ContactProvider>(context, listen: false)
          .getAllFavoriteContacts();
    }
  }
}
