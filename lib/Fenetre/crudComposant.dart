import 'package:flutter/material.dart';
import 'package:jareb/Fenetre/sql_helper.dart';


import '../models/composant.dart';



class Crudcom extends StatefulWidget {
  const Crudcom({Key? key}) : super(key: key);

  @override
  _CrudcomState createState() => _CrudcomState();
}

class _CrudcomState extends State<Crudcom> {
  List<Map<String, dynamic>> _journals1 = [];
  var _selectedValueFamille;
  List<DropdownMenuItem<String>> _famille = [];



  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await SQLHelper.getComposnats();
    setState(() {
      _journals1 = data;
      _isLoading = false;
    });
  }

  _loadComposants() async {
    var composants = await SQLHelper.getItems();

    composants.forEach((items) {
      setState(() {
        _famille.add(DropdownMenuItem(
          child: Text(items['title']),
          value: items['title'],
        ));
      });
    });
  }
  @override
  void initState() {
    super.initState();
    _refreshJournals();
    _loadComposants();// Loading the diary when the app starts
  }





  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // This function w$ill be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
      _journals1.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        builder: (_) => Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          height: 300,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(hintText: 'Title'),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _descriptionController,
                  decoration:
                  const InputDecoration(hintText: 'Quantité'),
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField(
                  value: _selectedValueFamille,
                  items: _famille,
                  hint: Text('Composant'),
                  onChanged: (value) {
                    setState(() {
                      _selectedValueFamille = value;
                    });
                  },
                ),

                ElevatedButton(
                  onPressed: () async {
                    // Save new journal
                    if (id == null) {
                      await _addIt();
                    }

                    if (id != null) {
                      await _updateItem(id);
                    }

                    // Clear the text fields
                    _titleController.text = '';
                    _descriptionController.text = '';

                    // Close the bottom sheet
                    Navigator.of(context).pop();
                  },
                  child: Text(id == null ? 'Create New' : 'Update'),
                )
              ],
            ),
          ),
        ));
  }

// Insert a new journal to the database
  Future<void> _addIt() async {
    await SQLHelper.createComposant(
        _titleController.text, _descriptionController.text,_selectedValueFamille.toString());
    _refreshJournals();
  }

  // Update an existing journal
  Future<void> _updateItem(int id) async {
    await SQLHelper.updateComposant(
        id, _titleController.text, _descriptionController.text,_selectedValueFamille.toString());
    _refreshJournals();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelper.deleteComposant(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    _refreshJournals();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _journals1.length,
        itemBuilder: (context, index) => Card(
          color: Colors.orange[200],
          margin: const EdgeInsets.all(15),
          child: ListTile(
              title: Text("nom: "+_journals1[index]['title']),
              subtitle: Text(_journals1[index]['quantite']),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showForm(_journals1[index]['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          _deleteItem(_journals1[index]['id']),
                    )],

                ),
              )
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
  Future<List<Composant>> searchContacts(String keyword) async {
    final db = await SQLHelper.db();
    List<Map<String, dynamic>> allRows = await db
        .query('composant', where: 'title LIKE ', whereArgs: ['%$keyword%']);
    List<Contact> contacts =
    allRows.map((contact) => Contact.fromMap(contact)).toList();
    return contacts;
  }
}

}


