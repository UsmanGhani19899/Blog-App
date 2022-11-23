import 'package:blogspot/Core/database.dart';
import 'package:blogspot/widgets/customeFields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

bool isSearchMode = false;
// TextEditingController searchController = TextEditingController();
QuerySnapshot? snapshotData;

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController? searchController;

  @override
  void initState() {
    searchController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            // Container(
            //   width: Get.width,
            //   child: CustomeField(
            //     controller: searchController,
            //     fieldName: 'Search',
            //     maxLine: 1,
            //   ),
            // ),

            Container(
              // width: MediaQuery.of(context).size.width * 0.85,
              child: TextFormField(
                controller: searchController,
                validator: ((val) => searchController!.text.isEmpty
                    ? "Please Enter Something}"
                    : null),
                onChanged: (value) {
                  setState(() {
                    value = searchController!.text;
                  });
                },
                style: GoogleFonts.roboto(color: Colors.white),
                decoration: InputDecoration(
                    suffixIcon: isSearchMode == false
                        ? IconButton(
                            onPressed: () {
                              Database()
                                  .searchResult(searchController!.text, context)
                                  .then((value) => snapshotData = value);
                              setState(() {
                                // isLoading = true;
                                isSearchMode = true;
                              });
                            },
                            icon: Icon(
                              isSearchMode == false
                                  ? FeatherIcons.search
                                  : FeatherIcons.x,
                              color: Colors.white,
                            ))
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                // isLoading = true;
                                searchController!.clear();
                                isSearchMode = false;
                              });
                            },
                            icon: Icon(
                              FeatherIcons.x,
                              color: Colors.white,
                            )),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: 'Search',
                    hintStyle: GoogleFonts.roboto(color: Colors.grey.shade400),
                    filled: true,
                    fillColor: Colors.grey.shade800.withOpacity(0.25)),
              ),
            ),
            isSearchMode == true
                ? Expanded(child: StatefulBuilder(
                    builder: ((BuildContext context, StateSetter setState) {
                      return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("Posts")
                              .where("postTitle",
                                  isLessThanOrEqualTo: searchController!.text)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Container();
                            } else if (snapshot.hasData) {
                              return ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> searchResult =
                                        snapshot.data!.docs[index].data()
                                            as Map<String, dynamic>;
                                    return Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        children: [
                                          Image(
                                            image: NetworkImage(
                                                '${searchResult['photo']}'),
                                            height: Get.height * 0.1,
                                            width: Get.width * 0.2,
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: Get.width * 0.6,
                                                child: Text(
                                                  '${searchResult['postTitle']}'
                                                      .toUpperCase(),
                                                  style: GoogleFonts.roboto(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 18),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Container(
                                                height: Get.height * 0.04,
                                                width: Get.width * 0.6,
                                                child: Text(
                                                  '${searchResult['post']}',
                                                  style: GoogleFonts.roboto(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12),
                                                  overflow: TextOverflow.fade,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            } else {
                              return Container();
                            }
                          });
                    }),
                  ))
                : Container(
                    height: Get.height * 0.7,
                    alignment: Alignment.center,
                    child: Icon(
                      FeatherIcons.search,
                      size: 90,
                      color: Colors.white,
                    ),
                  )
          ],
        ),
      ),
    ));
  }
}
