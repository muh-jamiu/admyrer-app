// import 'dart:convert';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter/services.dart';
// import 'dart:typed_data';
// import 'dart:ui' as ui;

// class ResourceImage extends ImageProvider<ResourceImage> {
//   final String imageName;

//   ResourceImage(this.imageName);

//   @override
//   Future<ResourceImage> obtainKey(ImageConfiguration configuration) {
//     return SynchronousFuture<ResourceImage>(this);
//   }

//   @override
//   ImageStreamCompleter load(ResourceImage key, ImageDecoderCallback decode) {
//     return OneFrameImageStreamCompleter(_loadImage(key));
//   }

//   Future<ImageInfo> _loadImage(ResourceImage key) async {
//     final ByteData data = await rootBundle.load('assets/$imageName');
//     final Uint8List bytes = data.buffer.asUint8List();
//     final Codec codec = await decode(bytes);
//     final ui.FrameInfo frame = await codec.();
//     return ImageInfo(image: frame.image);
//   }
// }
