import 'package:flutter/material.dart';
import 'package:geul_gil/pages/main_screen/image_detail_screen.dart';

class ImageListScreen extends StatefulWidget {
  static const routeName = "/image-list";

  const ImageListScreen({super.key});

  @override
  State<ImageListScreen> createState() => _ImageListScreenState();
}

class _ImageListScreenState extends State<ImageListScreen> {
  final List<String> _imageUrls = [
    'https://www.travelandleisure.com/thmb/umcoSMJygYyG5OIYDdBPgnrJGLc=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/01-neuschwanstein-castle-bavaria-NEUSCHWANSTEIN0417-273a040698f24fc1ac22e717bb3f1f0c.jpg',
    'https://cdn.pixabay.com/photo/2015/03/17/02/01/cubes-677092_1280.png',
    'https://plus.unsplash.com/premium_photo-1689551670902-19b441a6afde?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cmFuZG9tJTIwcGVvcGxlfGVufDB8fDB8fHww',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRMY6vszJe0KnZq9RMy35_Kwy5oDLufr1IyeQ&s',
    'https://media.cnn.com/api/v1/images/stellar/prod/190806154827-bodiam-castle.jpg?q=w_1110,c_fill',
    'https://dcimg7.dcinside.co.kr/viewimage.php?id=24bfef28e0c56a&no=24b0d769e1d32ca73ce98ffa11d02831bd5a1dd344853cdafcb6788d9a18deadec9b6dd770e8eab9aa3b102d5d03e08ceb03983b5a9bd886fabcf96346ff409d2e26',
  ];

  // Future<void> _fetchImageList() async {
  //   final response = await http.get(Uri.parse(
  //       'https://ih1.redbubble.net/image.541606070.7414/flat,750x,075,f-pad,750x1000,f8f8f8.jpg'));

  //   if (response.statusCode == 200) {
  //     // Assuming the server returns a JSON array of image URLs
  //     final List<dynamic> data = json.decode(response.body);
  //     setState(() {
  //       _imageUrls = List<String>.from(data);
  //     });
  //   } else {
  //     throw Exception('Failed to load images');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // _fetchImageList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _imageUrls.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Loading spinner
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    MediaQuery.of(context).size.width > 1200 ? 4 : 3,
                crossAxisSpacing: 32,
                mainAxisSpacing: 32,
                childAspectRatio: 16 / 9,
              ),
              itemCount: _imageUrls.length,
              padding: const EdgeInsets.all(32),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageDetailScreen(
                          imageUrl: _imageUrls[index],
                          tag:
                              'imageHero_$index', // Unique tag for Hero animation
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'imageHero_$index',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(_imageUrls[index],
                          fit: BoxFit.fitWidth),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
