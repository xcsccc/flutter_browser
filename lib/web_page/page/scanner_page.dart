// ignore_for_file: use_build_context_synchronously
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:browser01/web_page/color/colors.dart';
import 'package:browser01/web_page/custom/image_path.dart';
import 'package:browser01/web_page/dialog/long_click_dialog.dart';
import 'package:browser01/web_page/now_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:image_picker/image_picker.dart';
import '../../generated/l10n.dart';

class ScannerPage extends StatefulWidget{
  const ScannerPage({super.key});

  @override
  State<StatefulWidget> createState() => ScannerPageState();
}

class ScannerPageState extends State<ScannerPage>{
  MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child:Stack(
        children: [
          MobileScanner(
            // fit: BoxFit.contain,
            controller: controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                Navigator.of(context).pop(barcodes.first.rawValue);
              }
            },
          ),
          Container(
            decoration: ShapeDecoration(
              shape: OverlayShape(
                borderRadius: 10,
                borderColor: Colors.white,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
                cutOutBottomOffset: 0,
                overlayColor:Colors.black45,
              ),
            ),
          ),
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconImageButton(res: AppImages.back,onClick: (){
                    Navigator.of(context).pop(null);
                  },isTheme: false),
                  Text(S.of(context).scan,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 15))
                ],
              ),
              const Divider(height: 2,color: Colors.white),
            ],
          ),
          Column(
           mainAxisSize: MainAxisSize.max,
           mainAxisAlignment: MainAxisAlignment.end,
           children: [
             Row(
               mainAxisSize: MainAxisSize.min,
               children: [
                 IconButton(
                   color: Colors.white,
                   icon: ValueListenableBuilder(
                     valueListenable: controller.torchState,
                     builder: (context, state, child) {
                       switch (state) {
                         case TorchState.off:
                           return Image.asset(AppImages.flush,color: Colors.grey);
                         case TorchState.on:
                           return Image.asset(AppImages.flush,color: ThemeColors.progressStartColor,);
                       }
                     },
                   ),
                   iconSize: 32.0,
                   onPressed: () => controller.toggleTorch(),
                 ),
                 Expanded(child: Container(),),
                 IconButton(
                   color: Colors.white,
                   icon: ValueListenableBuilder(
                     valueListenable: controller.cameraFacingState,
                     builder: (context, state, child) {
                       return Image.asset(AppImages.imageMode,color: Colors.grey);
                     },
                   ),
                   iconSize: 32.0,
                   onPressed: () async {
                       try{
                         final picker = ImagePicker();
                         var pickedFile = await picker.pickImage(
                             source: ImageSource.gallery);
                         if(pickedFile != null){
                           var qrCodeResult = await FlutterQrReader.imgScan(pickedFile.path);
                           if(qrCodeResult.isEmpty){
                             toastMsg(S.of(context).qRNotRecognized);
                           }else{
                             Navigator.of(context).pop(qrCodeResult);
                           }
                         }
                       }catch(e){
                         toastMsg(S.of(context).error);
                       }
                   },
                 ),
               ],
             )
           ],
         ),
        ],
      ),
    ));
  }

  Future<bool?> flashSwitch() async {
    return null;
  }
}