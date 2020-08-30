import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/providers/products_provider.dart';

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
  ProductProvider _editedProduct = ProductProvider(
      id: null, price: null, title: '', description: '', imageUrl: '');
  var _isInit = false;
  var _isLoading = false;

  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(() {
      _updateImageUrl();
    });
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findProductById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
        };
        _imageUrlEditingController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  _updateImageUrl() {
    if (!_imageUrlFocus.hasFocus) {
      if ((!_imageUrlEditingController.text.startsWith('http') &&
              !_imageUrlEditingController.text.startsWith('https')) ||
          (!_imageUrlEditingController.text.endsWith('.jpg') &&
              !_imageUrlEditingController.text.endsWith('.jpeg') &&
              !_imageUrlEditingController.text.endsWith('.png'))) {
        return;
      }
      setState(() {});
    }
  }

  _saveForm() {
    if (!_form.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _form.currentState.save();
    print(_editedProduct);
    if (_editedProduct.id != null) {
      Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      Navigator.of(context).pop();
    } else
      Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(_editedProduct)
          .then((value) {
        Navigator.of(context).pop();
      });
  }

  @override
  void dispose() {
    // step 4. this to prevent memory leaks if the screen isn't visible anymore
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    // remember to remove listener fist before dispose(destroy) object
    _imageUrlFocus.removeListener(_updateImageUrl);
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter product title';
                          }
                          // null here mean it's a valid input
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          //step 2. these fields for go to nest field in form
                          FocusScope.of(context).requestFocus(_priceFocus);
                          _editedProduct = ProductProvider(
                              id: _editedProduct.id,
                              price: _editedProduct.price,
                              title: value,
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              isFavourite: _editedProduct.isFavourite);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        // step 3. these fields for go to nest field in form
                        focusNode: _priceFocus,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a product price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid price';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter a price > 0';
                          }
                          // null here mean it's a valid input
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocus);
                          _editedProduct = ProductProvider(
                              id: _editedProduct.id,
                              price: double.parse(value),
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              isFavourite: _editedProduct.isFavourite);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter product description';
                          }
                          if (value.length < 10) {
                            return 'Please enter more than 10 characters ';
                          }
                          // null here mean it's a valid input
                          return null;
                        },
                        onSaved: (value) {
                          FocusScope.of(context).requestFocus(_imageUrlFocus);
                          _editedProduct = ProductProvider(
                              id: _editedProduct.id,
                              price: _editedProduct.price,
                              title: _editedProduct.title,
                              description: value,
                              isFavourite: _editedProduct.isFavourite,
                              imageUrl: _editedProduct.imageUrl);
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
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter an image url';
                                }
                                if (!value.startsWith('http') ||
                                    !value.startsWith('https')) {
                                  return 'Please enter a valid image url';
                                }
                                if (!value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg') &&
                                    !value.endsWith('.png')) {
                                  return 'Please enter a valid image url';
                                }
                                // null here mean it's a valid input
                                return null;
                              },
                              onFieldSubmitted: (value) {
                                _editedProduct = ProductProvider(
                                    id: _editedProduct.id,
                                    price: _editedProduct.price,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    isFavourite: _editedProduct.isFavourite,
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
