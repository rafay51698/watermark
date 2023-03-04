import 'dart:io';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class MyController extends GetxController {
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  Rx<XFile> videoFile = XFile('').obs;
  Rx<XFile> image = XFile("").obs;
  //for emulator path
  var output = "/storage/emulated/0/Download/output.mp4".obs;
  var gallery = "".obs;
  // Pick an  image
  pickPhoto() async {
    try {
      ImagePicker picker = ImagePicker();
      XFile? img = await picker.pickImage(source: ImageSource.gallery);
      image.value = img!;
      image.refresh();
      print(img.path);
    } catch (e) {
      print(e.toString());
    }
  }

  pickVideo() async {
    try {
      ImagePicker imagePicker = ImagePicker();
      XFile? video = await imagePicker.pickVideo(source: ImageSource.gallery);
      videoFile.value = video!;
      update();
      print(videoFile.value.path);
    } catch (e) {
      print(e.toString());
    }
  }

  // generateOutputVideoPath() async {
  //   var dir = await getExternolStoreDir();

  // Future<String> getExternolStoreDir() async {
  //   print("object");
  //   final directory = await getExternalStorageDirectory();
  //   // print(directory);
  //   final path = directory!.path;
  //   print(path);
  //   return path;
  // }
  //   print("dir = $dir");
  //   final DateTime now = DateTime.now();
  //   final String timestamp = now.millisecondsSinceEpoch.toString();
  //   final String fileName = 'output_$timestamp.mp4';
  //   print("filename = $fileName");
  //   //for generating final video
  //   output.value = "${dir}/${fileName}";
  //   //for writing final video in gallery
  //   gallery.value = "${dir}/output.mp4";
  //   update();
  // }

  addWatermarkToVideo() async {
    // generateOutputVideoPath();
    // print("njdanjd ${output.value}");
    // final directory = await getTemporaryDirectory();

    // gallery.value = directory.path +
    //     "output_video_file.mp4";
    // print(gallery.value);


    // Generate the FFmpeg command to add the watermark
    
    final String command =
        '-i ${videoFile.value.path} -i ${image.value.path} -filter_complex "overlay=10:10" ${output.value}';
    
    
    //  command to scale the watermark by 0.3 of its total size

    // final String command =
    //  '-i ${videoFile.value.path} -i ${image.value.path} -filter_complex "overlay=10:10:scale=0.3" ${output.value}';
    
    
    // Run the FFmpeg command it takes some time
    
    await _flutterFFmpeg.execute(command);
    
    // final File outputVideoFile = File(gallery.value);
    // print(File(gallery.value));
    // await outputVideoFile.writeAsBytes(await File(output.value).readAsBytes());
    print("rafay");
    update();
  }

}
