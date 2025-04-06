import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:helpables/Providers/aidrequests_provider.dart';
import 'package:provider/provider.dart';
import 'package:helpables/Modal/AidRequestList.dart';

class AidRequestList extends StatefulWidget {
  final String? category;
  final String? location;
  final String searchQuery;

  const AidRequestList({
    super.key,
    required this.category,
    required this.location,
    required this.searchQuery,
  });

  @override
  _AidRequestListState createState() => _AidRequestListState();
}

class _AidRequestListState extends State<AidRequestList> {
  List<AidRequest> _filterResults(List<AidRequest> requests) {
    return requests.where((request) {
      final hasCategory =
          widget.category != null && widget.category!.isNotEmpty;
      final hasLocation =
          widget.location != null && widget.location!.isNotEmpty;

      final matchesCategory =
          !hasCategory || request.CategoryTitle == widget.category;
      final matchesLocation = !hasLocation ||
          (request.location['address']?.toString().contains(widget.location!) ??
              false);

      final matchesSearch = widget.searchQuery.isEmpty ||
          request.title
              .toLowerCase()
              .contains(widget.searchQuery.toLowerCase()) ||
          request.CategoryTitle.toLowerCase()
              .contains(widget.searchQuery.toLowerCase()) ||
          (request.location['address']
                  ?.toString()
                  .toLowerCase()
                  .contains(widget.searchQuery.toLowerCase()) ??
              false);

      if (hasCategory && hasLocation) {
        return (matchesCategory || matchesLocation) && matchesSearch;
      }

      return matchesCategory && matchesLocation && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final aidRequests =
        Provider.of<AidRequestsProvider>(context).getRequestsList();
    final filteredRequests = _filterResults(aidRequests);

    return Scaffold(
      body: aidRequests.isEmpty
          ? const Center(child: Text('No aid requests match your filters.'))
          : ListView.builder(
              itemCount: filteredRequests.isEmpty
                  ? aidRequests.length
                  : filteredRequests.length,
              itemBuilder: (context, index) {
                final request = filteredRequests.isEmpty
                    ? aidRequests[index]
                    : filteredRequests[index];
                return Card(
                  color: Colors.white,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.blueGrey),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                maxLines: 1,
                                request.title,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo[900]),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                request.CategoryTitle,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.indigo[900]),
                              ),
                              Text(
                                maxLines: 2,
                                request.location['address'] ??
                                    'Unknown Location',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.indigo[900]),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          child: request.imgUrls.isNotEmpty
                              ? CarouselSlider(
                                  options: CarouselOptions(
                                    height: MediaQuery.of(context).size.height*0.14, 
                                    autoPlay: true,
                                    autoPlayInterval: Duration(seconds: 2),
                                    viewportFraction:
                                        1.0, 
                                  ),
                                  items: request.imgUrls
                                      .take(5) 
                                      .map((imageUrl) => Image.network(
                                            imageUrl,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Container(
                                              color: Colors.grey.shade300,
                                              child: const Icon(
                                                  Icons.image_not_supported,
                                                  color: Colors.grey),
                                            ),
                                          ))
                                      .toList(),
                                )
                              : Container(
                                  width: double.infinity,
                                  height: 80,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.image_not_supported,
                                      color: Colors.grey),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
