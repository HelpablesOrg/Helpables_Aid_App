import '../Providers/add_aid_requestprov.dart';
import '../Providers/categories_providers.dart';
import '../Screens/home_screen.dart';
import '../Widgets/add_aidrequest_form.dart';
import '../Widgets/carousel_slider.dart';
import '../Widgets/ctg_subctg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddAidRequestScreen extends StatefulWidget {
  const AddAidRequestScreen({super.key});
  @override
  State<AddAidRequestScreen> createState() => _AddAidRequestScreenState();
}

class _AddAidRequestScreenState extends State<AddAidRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final List<String> categories =
        Provider.of<CategoriesProvider>(context, listen: true).getCategory();
    final provider = Provider.of<AddAidRequestProvider>(context, listen: false);
    void callSnackbar(String title) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(title)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Aid Request'),
        leading: IconButton(
            onPressed: () {
              provider.cleardata();
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HomeScreen();
              }));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                ShowCarouselSlider(),
                FormWidget(formKey: _formKey),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 16, right: 16),
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: CtgSubctg(categories: categories)),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.045,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        backgroundColor:
                            (const Color.fromARGB(255, 7, 77, 134)),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String check = provider.validateRequestData();
                          if (check == "true") {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              await provider.addAidRequest();
                              callSnackbar("Form submitted successfully.");
                              provider.cleardata();
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return HomeScreen();
                              }));
                            } catch (error) {
                              setState(() {
                                _isLoading = false;
                              });
                              callSnackbar(
                                  "An error occurred: No internet connection. Please check your network.");
                            } finally {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          } else {
                            callSnackbar(check);
                          }
                        }
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.019,
                            color: Colors.white),
                      )),
                ),
                SizedBox(height: 50)
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
