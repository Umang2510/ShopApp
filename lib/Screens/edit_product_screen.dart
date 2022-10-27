import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key key}) : super(key: key);
  static const routName = '/edit-product';
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  /// [FocusNode] must have to dispose when we leave a screen or does not require
  /// because it stick around in memory and will lead to a memory leak😣
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    super.dispose(); // should be at last line in dispose()
    //while in initState super.initState should be first line
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Product'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  // go to next input
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descFocusNode);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 4,
                  maxLength: 150,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descFocusNode,
                ),
              ],
            ),
          ),
        ));
  }
}
