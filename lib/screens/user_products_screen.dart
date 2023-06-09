import 'package:flutter/material.dart';
import '../providers/pages.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import 'package:provider/provider.dart';

import 'edit_page_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  final bool onlyEditor;
  UserProductsScreen(this.onlyEditor);

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<WebPages>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Pages'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: onlyEditor ? null : AppDrawer(true),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<WebPages>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserProductItem(
                                productsData.items[i]!.id,
                                productsData.items[i]!.title,
                                productsData.items[i]!.imageUrl,
                              ),
                              Divider(),
                            ],
                          ),
                          itemCount: productsData.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
