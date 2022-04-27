import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/data/product.dart';
import 'package:shop_app/models/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);
  static const String routeName = "/editProductScreen";

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool validImage = true;
  Product savedProduct = Product(
    title: "",
    id: 0,
    description: "",
    imageUrl: "",
    price: 0,
  );
  var isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      if (!(ModalRoute.of(context)!.settings.arguments == null)) {
        final int productId = ModalRoute.of(context)!.settings.arguments as int;

        savedProduct =
            Provider.of<Products>(context).findProductById(productId);
        currentProduct = {
          "id": savedProduct.id,
          "title": savedProduct.title,
          "description": savedProduct.description,
          "price": savedProduct.price,
          //"imageUrl": savedProduct.imageUrl,
        };
        _imageUrlController.text = savedProduct.imageUrl;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  Map<String, dynamic> currentProduct = {
    "id": 0,
    "title": '',
    "description": '',
    "price": 0.0,
    "imageUrl": ''
  };
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (savedProduct.id != 0) {
        Provider.of<Products>(context, listen: false)
            .updateProduct(savedProduct.id, savedProduct);
      } else {
        Provider.of<Products>(context, listen: false).addProduct(savedProduct);
      }

      _formKey.currentState!.reset();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Your Product"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Title",
                    ),
                    textInputAction: TextInputAction.next,
                    onSaved: (value) {
                      savedProduct.title = value.toString();
                    },
                    initialValue: currentProduct["title"],
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return "Please Enter a vaild title";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: currentProduct["price"].toString(),
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return "Please Enter a vaild price";
                      }
                      if (double.tryParse(value.toString()) == null) {
                        return "Please Enter a vaild price";
                      }

                      if (double.parse(value.toString()) <= 0) {
                        return "Please Enter a vaild price";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Price",
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onSaved: (value) {
                      savedProduct.price = double.parse(value.toString());
                    },
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return "Please Enter a vaild description";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "description",
                    ),
                    initialValue: currentProduct["description"],
                    onSaved: (value) {
                      savedProduct.description = value.toString();
                    },
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(
                          top: kDefaultPadding * 2,
                          right: kDefaultPadding,
                        ),
                        child: FittedBox(
                          child: Image.network(
                            _imageUrlController.text,
                            fit: BoxFit.cover,
                            errorBuilder: (context, exception, stackTrace) {
                              validImage = false;
                              return const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: kDefaultPadding / 2),
                                child: FittedBox(
                                  child: Text("enter image url"),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          onFieldSubmitted: ((value) {
                            FocusScope.of(context).requestFocus(FocusNode());

                            _saveForm();
                          }),
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return "Please Enter a vaild image url";
                            }
                            // if (!value.toString().startsWith("http") ||
                            //     !value.toString().startsWith("https")) {
                            //   return "Please Enter a vaild image url";
                            // }
                            // if (!value.toString().endsWith(".png") ||
                            //     !value.toString().endsWith(".jpg") ||
                            //     !value.toString().endsWith(".jpeg")) {
                            //   return "Please Enter a vaild image url";
                            // }
                            return null;
                          },
                          onSaved: (value) {
                            savedProduct.imageUrl = value.toString();
                          },
                          controller: _imageUrlController,
                          decoration: const InputDecoration(
                            labelText: "Image Url",
                          ),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () => setState(() {}),
                          focusNode: _imageUrlFocusNode,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _saveForm();
          },
          child: const Icon(
            Icons.done,
          ),
        ),
      ),
    );
  }
}
