import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/EditProductScreen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // these fields for go to nest field in form
  // 4 steps
  // 1.
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlEditingController = TextEditingController();
  final _form = GlobalKey<FormState>();
  ProductProvider _existingProduct = ProductProvider(
      id: null, price: null, title: '', description: '', imageUrl: '');

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(() {
      _updateFocus();
    });
  }

  _updateFocus() {
    if (!_imageUrlFocus.hasFocus) {
      setState(() {});
    }
  }

  _saveForm() {
    _form.currentState.save();
    print(_existingProduct);
  }

  @override
  void dispose() {
    // step 4. this to prevent memory leaks if the screen isn't visible anymore
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    // remember to remove listener fist before dispose(destroy) object
    _imageUrlFocus.removeListener(_updateFocus);
    _imageUrlFocus.dispose();
    _imageUrlEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    //step 2. these fields for go to nest field in form
                    FocusScope.of(context).requestFocus(_priceFocus);
                    _existingProduct = ProductProvider(
                        id: _existingProduct.id,
                        price: _existingProduct.price,
                        title: value,
                        description: _existingProduct.description,
                        imageUrl: _existingProduct.imageUrl);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Price',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  // step 3. these fields for go to nest field in form
                  focusNode: _priceFocus,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_descriptionFocus);
                    _existingProduct = ProductProvider(
                        id: _existingProduct.id,
                        price: double.parse(value),
                        title: _existingProduct.title,
                        description: _existingProduct.description,
                        imageUrl: _existingProduct.imageUrl);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  onSaved: (value) {
                    FocusScope.of(context).requestFocus(_imageUrlFocus);
                    _existingProduct = ProductProvider(
                        id: _existingProduct.id,
                        price: _existingProduct.price,
                        title: _existingProduct.title,
                        description: value,
                        imageUrl: _existingProduct.imageUrl);
                  },
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocus,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: _imageUrlEditingController.text.isEmpty
                          ? Text('Enter a url')
                          : FittedBox(
                              child: Image.network(
                                _imageUrlEditingController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    // expanded fix: An InputDecorator, which is typically created by a TextField, cannot have an unbounded width. inside a row
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Image url',
                        ),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.url,
                        // step 3. these fields for go to nest field in form
                        focusNode: _imageUrlFocus,
                        controller: _imageUrlEditingController,
                        onFieldSubmitted: (value) {
                          _existingProduct = ProductProvider(
                              id: _existingProduct.id,
                              price: _existingProduct.price,
                              title: _existingProduct.title,
                              description: _existingProduct.description,
                              imageUrl: value);
                          _saveForm();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
