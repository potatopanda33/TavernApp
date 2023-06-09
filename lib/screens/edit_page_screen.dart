import 'package:flutter/material.dart';
import '../providers/page.dart';
import '../providers/pages.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  WebPage? _editedProduct = WebPage(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  var _isLoading = false;
  var _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String?;
      if (productId != null) {
        _editedProduct =
            Provider.of<WebPages>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct!.title!,
          'description': _editedProduct!.description!,
          'price': _editedProduct!.price.toString(),
          'imageUrl': '',
        };

        _imageUrlController.text = _editedProduct!.imageUrl!;
      }

      _isInit = false;
    }
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      final value = _imageUrlController.text;

      if (!value.startsWith('http') && !value.startsWith('https')) {
        return;
      }

      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    if (_editedProduct!.id != null) {
      await Provider.of<WebPages>(context, listen: false).updateProduct(
        _editedProduct!.id,
        _editedProduct,
      );
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<WebPages>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('Okay'),
              )
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Plaese provide a value.';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = WebPage(
                          id: _editedProduct!.id,
                          isFavorite: _editedProduct!.isFavorite,
                          title: value,
                          description: _editedProduct!.description,
                          price: _editedProduct!.price,
                          imageUrl: _editedProduct!.imageUrl,
                        );
                      },
                    ),
                    CheckboxListTile(
                      value: _editedProduct!.price == 2,
                      onChanged: (value) {
                        setState(() {
                          _editedProduct = WebPage(
                            id: _editedProduct!.id,
                            isFavorite: _editedProduct!.isFavorite,
                            title: _editedProduct!.title,
                            description: _editedProduct!.description,
                            price: value! ? 2 : 1,
                            imageUrl: _editedProduct!.imageUrl,
                          );
                        });
                      },
                      title: new Text(
                        'Open in the Browser',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: Colors.grey,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a Thumbnail URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Thumbnail URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Plaese provide a Thumbnail URL.';
                              }

                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL.';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = WebPage(
                                id: _editedProduct!.id,
                                isFavorite: _editedProduct!.isFavorite,
                                title: _editedProduct!.title,
                                description: _editedProduct!.description,
                                price: _editedProduct!.price,
                                imageUrl: value,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: Text('Link or HTML'),
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: new InputDecoration.collapsed(
                          hintText: 'Plaese enter a page link or HTML code'),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Plaese enter a page link or HTML code.';
                        }

                        if (value.length < 4) {
                          return 'Should be at least 4 characters long.';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = WebPage(
                          id: _editedProduct!.id,
                          isFavorite: _editedProduct!.isFavorite,
                          title: _editedProduct!.title,
                          description: value,
                          price: _editedProduct!.price,
                          imageUrl: _editedProduct!.imageUrl,
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}