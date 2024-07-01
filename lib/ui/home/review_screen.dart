import 'package:chat/constants/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';

class ReviewScreen extends StatefulWidget {
  final docId;

  const ReviewScreen({
    super.key,
    required this.docId,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  TextEditingController reviewController = TextEditingController();
  double rating = 0;
  void onSubmitReview() async {
    int rating = this.rating.toInt();
    if (rating > 0) {
      

      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection("users").doc(widget.docId.toString()).get();

      // print(doc["rate"] + rating);
      // print(doc["count_rate"] + 1);
      _firestore.collection("users").doc(widget.docId.toString()).update({
        "rate": (double.parse(doc["rate"]) + rating).toString(),
        "count_rate": (int.parse(doc["count_rate"]) + 1).toString(),
      });

      Navigator.pop(context);
    } else {
      buildSnackBar('add your rate first', context, 3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/lotties/review.json'),
              Align(
                alignment: Alignment.center,
                child: RatingBar.builder(
                  initialRating: 0,
                  minRating: 0,
                  maxRating: 5,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  unratedColor: const Color.fromRGBO(216, 216, 216, 1),
                  itemCount: 5,
                  itemSize: 40,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (newRating) {
                    setState(() {
                      rating = newRating;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Background color
                    ),
                    onPressed: onSubmitReview,
                    child: Text(
                      'add your review',
                      style: mainTextStyle(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
