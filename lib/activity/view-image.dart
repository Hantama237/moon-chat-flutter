
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewImage extends StatefulWidget{
  final url;
  const ViewImage({@required this.url});
  @override
  State<StatefulWidget> createState() {
    return ViewState();
  }
}
class ViewState extends State<ViewImage>{
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text('Image View'),
       ),
       body: Container(
         child: PhotoView(
           imageProvider: CachedNetworkImageProvider(widget.url),
         ),
       ),
     );
  }
}