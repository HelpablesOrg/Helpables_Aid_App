import 'package:aid_app/Modal/subCategory.dart';
import 'package:aid_app/Providers/add_aid_requestprov.dart';
import 'package:aid_app/Providers/categories_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CtgSubctg extends StatefulWidget {
  CtgSubctg({super.key, required this.categories});
  List<String> categories;
  @override
  State<CtgSubctg> createState() => _CtgSubctgState();
}

class _CtgSubctgState extends State<CtgSubctg> {
  Map<String, TextEditingController> _numberController = {};
  String? _selectedCategory;
  List<String> _SubCategories = [];
  bool _isCategoryExpanded = false;
  bool _isSubCategoryExpanded = false;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoriesProvider>(context, listen: false);
    final addaidreqprovider =
        Provider.of<AddAidRequestProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isCategoryExpanded = !_isCategoryExpanded;
              _isSubCategoryExpanded = false;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedCategory ?? "Select a Category",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Icon(
                  _isCategoryExpanded
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
        if (_isCategoryExpanded)
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            child: ListView.builder(
              itemCount: widget.categories.length,
              itemBuilder: (context, index) {
                String category = widget.categories[index];
                return ListTile(
                  title: Text(provider.getCatTitle(category)),
                  onTap: () {
                    setState(() {
                      _selectedCategory = provider.getCatTitle(category);
                      addaidreqprovider.getCategoryId(_selectedCategory!);
                      provider.fetchSubCategories(_selectedCategory!);
                      _SubCategories =
                          provider.getSubCategory(_selectedCategory!);
                      _isCategoryExpanded = false;
                      _numberController = {};
                    });
                  },
                );
              },
            ),
          ),
        SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            setState(() {
              if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
                _isSubCategoryExpanded = !_isSubCategoryExpanded;
              }
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedCategory != null
                      ? 'Enter amount for sub-category'
                      : 'Select a Category first',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Icon(
                  _isSubCategoryExpanded
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
        if (_isSubCategoryExpanded)
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            child: ListView.builder(
              itemCount: _SubCategories.length,
              itemBuilder: (context, index) {
                String subCategory = _SubCategories[index];
                _numberController.putIfAbsent(
                    subCategory, () => TextEditingController());
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        subCategory,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.14,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: TextFormField(
                          controller: _numberController[subCategory],
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            hintText: "Amt",
                          ),
                          onChanged: (value) {
                            addaidreqprovider.getSubCat(
                              SubCategory(
                                title: subCategory,
                                qty: int.tryParse(value) ?? 0,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
