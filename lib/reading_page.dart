import 'dart:math';

import 'package:comic_app/models/chapter.dart';
import 'package:comic_app/provider/chapterProvider.dart';
import 'package:comic_app/provider/commentProvider.dart';
import 'package:flutter/material.dart';
import 'package:comic_app/constants/constant.dart' as constant;
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

class ReadingPageScreen extends StatefulWidget {
  ChapterModel item;
  var maxChapter;
  ReadingPageScreen({super.key, required this.item, this.maxChapter});

  @override
  State<ReadingPageScreen> createState() => _ReadingPageScreenState();
}

const double width = 200;
const double height = 40;
const double loginAlign = -1;
const double signInAlign = 1;
const Color selectedColor = Colors.white;
const Color normalColor = Colors.black54;

class _ReadingPageScreenState extends State<ReadingPageScreen> {
  ScrollController scrollController = ScrollController();
  final commentController = TextEditingController();
  late double xAlign;
  late Color loginColor;
  late Color signInColor;
  int selectedUI = 1;
  // Initial Selected Value
  String dropdownvalue = 'Item 1';
  bool showbtn = false;

  // List of items in our dropdown menu
  // var items = [
  //   'Item 1',
  //   'Item 2',
  //   'Item 3',
  //   'Item 4',
  //   'Item 5',
  // ];
  @override
  bool iLoading = true;
  bool chatSelected = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.offset > 100) {
        showbtn = true;
        setState(() {
          //update state
        });
      } else {
        showbtn = false;
        setState(() {
          //update state
        });
      }
    });
    xAlign = loginAlign;
    loginColor = selectedColor;
    signInColor = normalColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var commentProvider = Provider.of<CommentProvider>(context);
    var chapterProvider = Provider.of<ChapterProvider>(context);
    var cmt;
    if (iLoading) {
      (() async {
        await commentProvider.getCommentComic(widget.item.id);
        setState(() {
          iLoading = false;
        });
      })();
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          FocusScope.of(context).requestFocus(FocusNode());
        });
      },
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  _buildAppBar(context),
                  const SizedBox(
                    height: 5,
                  ),
                  _buildSelectedUIButton(context),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: selectedUI == 1
                          ? _buildClassicUI(context)
                          : _buildSlideUI(context)),
                ],
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 14,
                  bottom: 16,
                ),
                child: AnimatedAlign(
                  curve: Curves.fastOutSlowIn,
                  alignment:
                      chatSelected ? Alignment.topLeft : Alignment.bottomLeft,
                  duration: const Duration(seconds: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(width: 1, color: Colors.black54)),
                    width: chatSelected
                        ? MediaQuery.of(context).size.width * (9 / 10)
                        : 0,
                    height: chatSelected
                        ? MediaQuery.of(context).size.height * (8 / 10)
                        : 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 178, 218, 248),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            border: Border.all(width: 1, color: Colors.black26),
                          ),
                          width: double.infinity,
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 17, top: 5, bottom: 5),
                            child: Text(
                              widget.item.tenTruyen +
                                  " chap " +
                                  widget.item.tapSo.toString(),
                              style: GoogleFonts.readexPro(
                                  color: Colors.black87, fontSize: 15.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: SizedBox(
                              child: iLoading
                                  ? Center(
                                      child:
                                          LoadingAnimationWidget.dotsTriangle(
                                      color: Colors.blueGrey,
                                      size: 50,
                                    ))
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ...commentProvider.listComicComment.map(
                                          (e) => _testComment(
                                              context,
                                              e.tenDocGia,
                                              e.noiDung,
                                              e.ngayBinhLuan),
                                        )
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 178, 218, 248),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        constant.user.tenUser,
                                        style: GoogleFonts.readexPro(
                                            color: Colors.black87,
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                    .validate() &&
                                                commentController.text != "") {
                                              (() async {
                                                await commentProvider
                                                    .commentChapter(
                                                        constant.user!.id,
                                                        constant.user!.tenUser,
                                                        widget.item.id,
                                                        commentController.text);
                                                commentProvider.getCommentComic(
                                                    widget.item.id);
                                              })();
                                              commentController.clear();
                                            }
                                          },
                                          child: const Text(
                                            "Post",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 113, 186, 241)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              TextField(
                                style: GoogleFonts.readexPro(
                                    color: Colors.black, fontSize: 15.0),
                                controller: commentController,
                                decoration: const InputDecoration(
                                    hintStyle: TextStyle(fontSize: 15),
                                    hintText: 'Add a comment...',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        left: 25,
                                        top: 5,
                                        right: 10,
                                        bottom: 30)),
                                maxLines: null,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: _buildChangeChapterBar(context, chapterProvider),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BackButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Text(
            widget.item.tenTruyen,
            style: GoogleFonts.readexPro(color: Colors.black, fontSize: 20.0),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz))
        ],
      ),
    );
  }

  Widget _buildSelectedUIButton(BuildContext context) {
    return Container(
      width: width * 0.8,
      height: height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(50.0),
        ),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment(xAlign, 0),
            duration: const Duration(milliseconds: 300),
            child: Container(
              width: width * 0.4,
              height: height * 0.8,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 119, 160, 184),
                borderRadius: BorderRadius.all(
                  Radius.circular(50.0),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                xAlign = loginAlign;
                loginColor = selectedColor;

                signInColor = normalColor;
                selectedUI = 1;
              });
            },
            child: Align(
              alignment: const Alignment(-1, 0),
              child: Container(
                width: width * 0.4,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  'Classic UI',
                  style: GoogleFonts.readexPro(
                      fontWeight: FontWeight.bold,
                      color: loginColor,
                      fontSize: 13.0),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                xAlign = signInAlign;
                signInColor = selectedColor;

                loginColor = normalColor;
                selectedUI = 0;
              });
            },
            child: Align(
              alignment: const Alignment(1, 0),
              child: Container(
                width: width * 0.4,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  'Zen UI',
                  style: GoogleFonts.readexPro(
                      fontWeight: FontWeight.bold,
                      color: signInColor,
                      fontSize: 13.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassicUI(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(children: [
              Text(
                "Chapter " +
                    widget.item.tapSo.toString() +
                    ": " +
                    widget.item.ten,
                style: GoogleFonts.readexPro(
                    color: Colors.blueGrey.shade800, fontSize: 18.0),
              ),
              const SizedBox(
                height: 15,
              ),
              ...widget.item.noiDung.map((e) => Padding(
                    padding:
                        const EdgeInsets.only(left: 14, right: 14, bottom: 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      // height: MediaQuery.of(context).size.height,
                      child: Image.network(
                        e.anh,
                        // fit: BoxFit.fill,
                      ),
                    ),
                  )),
              const SizedBox(
                height: 15,
              ),
            ]),
          ),
        )

        // DropdownMenuItem(child: child)
      ],
    );
  }

  Widget _buildSlideUI(BuildContext context) {
    return Column(
      children: [
        Text(
          "Chapter " + widget.item.tapSo.toString() + ": " + widget.item.ten,
          style: GoogleFonts.readexPro(
              color: Colors.blueGrey.shade800, fontSize: 18.0),
        ),
        // const SizedBox(
        //   height: 5,
        // ),
        // Expanded(
        //   child: ListView(
        //     scrollDirection: Axis.horizontal,
        //     reverse: true,
        //     children: [
        // ...widget.item.noiDung.map((e) => Padding(
        //       padding:
        //           const EdgeInsets.only(left: 14, right: 14, bottom: 10),
        //       child: SizedBox(
        //         width: MediaQuery.of(context).size.width,
        //         // height: MediaQuery.of(context).size.height,
        //         child: Image.network(
        //           e.anh,
        //           // fit: BoxFit.fill,
        //         ),
        //       ),
        //     )),
        //     ],
        //   ),
        // )
        Expanded(
          child: CarouselSlider(
            items: widget.item.noiDung
                .map((e) => Padding(
                      padding:
                          const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height,
                        child: Image.network(
                          e.anh,
                          // fit: BoxFit.fill,
                        ),
                      ),
                    ))
                .toList(),
            // carouselController: buttonCarouselController,
            options: CarouselOptions(
              reverse: true,
              height: MediaQuery.of(context).size.height,
              // scrollPhysics: const BouncingScrollPhysics(),
              enableInfiniteScroll: false,
              viewportFraction: 1,
            ),
          ),
        ),
        // DropdownMenuItem(child: child)
      ],
    );
  }

  Widget _buildChangeChapterBar(
      BuildContext context, ChapterProvider chapterProvider) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.055,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: width * 0.28,
            color: Color.fromARGB(255, 79, 153, 209),
            child: IconButton(
              onPressed: () {
                setState(() {
                  chatSelected = !chatSelected;
                });
              },
              icon: const Icon(
                Icons.chat_bubble,
                color: Colors.white54,
              ),
            ),
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color.fromARGB(255, 158, 158, 158),
                  ),
                  child: IconButton(
                    iconSize: 30,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      if (widget.item.tapSo > 1) {
                        (() async {
                          await chapterProvider.getChap(widget.item.maTruyen,
                              (widget.item.tapSo - 1).toString());
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReadingPageScreen(
                                      item: chapterProvider.chap,
                                      maxChapter: widget.maxChapter)));
                        })();
                      }
                    },
                    icon: const Icon(
                      Icons.navigate_before,
                      size: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.04,
                          width: MediaQuery.of(context).size.width / 2.2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(255, 158, 158, 158)),
                          child: Center(
                              child: Text(
                            "Chapter " + widget.item.tapSo.toString(),
                            style: GoogleFonts.readexPro(
                                color: Colors.blueGrey.shade800,
                                fontSize: 16.0),
                          )),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromARGB(255, 158, 158, 158),
                  ),
                  child: IconButton(
                      iconSize: 30,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        if (widget.item.tapSo < widget.maxChapter) {
                          (() async {
                            await chapterProvider.getChap(widget.item.maTruyen,
                                (widget.item.tapSo + 1).toString());
                            // setState(() {
                            //   widget.item = chapterProvider.chap;
                            // });
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReadingPageScreen(
                                        item: chapterProvider.chap,
                                        maxChapter: widget.maxChapter)));
                          })();
                        }
                      },
                      icon: const Icon(
                        Icons.navigate_next,
                        size: 18,
                      )),
                ),
              ],
            ),
          ),
          !showbtn
              ? Container(
                  width: width * 0.28,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(14)),
                      color: Colors.grey),
                  child: IconButton(
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      style: IconButton.styleFrom(backgroundColor: Colors.blue),
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_upward)),
                )
              : Container(
                  width: width * 0.28,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(14)),
                      color: Color.fromARGB(255, 79, 153, 209)),
                  child: IconButton(
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      style: IconButton.styleFrom(backgroundColor: Colors.blue),
                      onPressed: () {
                        scrollController.animateTo(
                            //go to top of scroll
                            0, //scroll offset to go
                            duration: Duration(
                                milliseconds: 500), //duration of scroll
                            curve: Curves.fastOutSlowIn //scroll type
                            );
                      },
                      icon: const Icon(
                        Icons.arrow_upward,
                        color: Colors.black54,
                      )),
                ),
        ],
      ),
    );
  }

  Widget _testComment(
      BuildContext context, String tenUser, String noiDung, DateTime date) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 20),
      child: Row(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30, right: 5),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(constant.user.avatar),
                  radius: 20,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(builder: (p0, p1) {
                return Container(
                  // width: p1.maxWidth,
                  constraints: const BoxConstraints(
                    minWidth: 80,
                    maxWidth: width * 1.15,
                  ),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(153, 98, 141, 173),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tenUser,
                        style: GoogleFonts.readexPro(
                            color: Colors.black87,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        noiDung,
                        style: GoogleFonts.readexPro(
                            color: Colors.black87, fontSize: 13.0),
                        maxLines: null,
                      ),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                );
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildDateFormat(date),
                  const SizedBox(width: 10),
                  const Text("Like"),
                  const SizedBox(width: 10),
                  const Text("Reply"),
                ],
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ],
      ),
    );
  }

  // Widget _testDayComment(BuildContext context) {
  //   return const Padding(
  //     padding: EdgeInsets.only(left: 24),
  //     child: Text(
  //       "4 ngay truoc",
  //       style: TextStyle(color: Colors.white),
  //     ),
  //   );
  // }
  Widget buildDateFormat(DateTime createDate) {
    return Text(
      // 86400
      daysBetween(createDate, DateTime.now()) < 60
          ?
          //Nếu dưới 60 giây
          "${daysBetween(createDate, DateTime.now())}s"
          :
          // Trên 60 giây, đổi sang phút
          (daysBetween(createDate, DateTime.now()) / 60).round() < 60
              ?
              //Dưới 60 phút
              "${(daysBetween(createDate, DateTime.now()) / 60).round()}m"
              :
              //Trên 60 phút, đổi sang giờ
              (daysBetween(createDate, DateTime.now()) / (60 * 60)).round() < 24
                  ?
                  //Dưới 24 giờ
                  "${(daysBetween(createDate, DateTime.now()) / (60 * 60)).round()}h"
                  :
                  //Trên 24 giờ, đổi sang ngày
                  (daysBetween(createDate, DateTime.now()) / (24 * 60 * 60))
                              .round() <
                          7
                      ?
                      //Dưới 7 ngày
                      "${(daysBetween(createDate, DateTime.now()) / (24 * 60 * 60)).round()}d"
                      :
                      //Trên 7 ngày
                      DateFormat('dd-MM-yy').format(createDate),
      style: TextStyle(color: Colors.black54),
    );
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(
        from.year, from.month, from.day, from.hour, from.minute, from.second);
    to = DateTime(to.year, to.month, to.day, to.hour, to.minute, to.second);
    return (to.difference(from).inSeconds - 7 * 60 * 60);
  }
}
