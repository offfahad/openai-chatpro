import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:open_ai_chatgpt/constants/constants.dart';
import 'package:open_ai_chatgpt/providers/authentication_provider.dart';
import 'package:open_ai_chatgpt/providers/chat_provider.dart';
import 'package:open_ai_chatgpt/service/assets_manager.dart';
import 'package:open_ai_chatgpt/service/image_cache_manager.dart';
import 'package:open_ai_chatgpt/utility/utility.dart';
import 'package:provider/provider.dart';

import '../providers/my_theme_provider.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget(
      {Key? key,
      required this.messageData})
      : super(key: key);

  final dynamic messageData;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<MyThemeProvider>(context).themeType;
    Color color = isDarkTheme ? Colors.white : Colors.black;
    var user = context.read<AuthenticationProvider>().userModel;
    final userModel = context.read<AuthenticationProvider>().userModel;

    showShareDialog(){
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Share', textAlign: TextAlign.center,),
              content: const Text('Are you sure to share?', textAlign: TextAlign.center,),
              actions: [
                TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, child: const Text('Cancel',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red),),
                ),

                TextButton(
                  onPressed: () async{
                    // logout
                    await context.read<ChatProvider>().shareImage(
                        userModel: userModel,
                        imageData: messageData,
                        onSuccess: (){
                          Navigator.pop(context);
                          showSnackBar(context: context, content: 'Image successfully shared');
                        },
                    );

                  }, child: const Text('Yes',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green),),
                ),
              ],
            );
          });
    }
    return Column(
      children: [
        !isDarkTheme
            ? Material(
                color:
                    messageData[Constants.senderId] == user.uid ? Colors.grey.shade300 : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      messageData[Constants.senderId] == user.uid
                          ? CircleAvatar(
                              key: UniqueKey(),
                              radius: 15,
                              backgroundImage: CachedNetworkImageProvider(
                                user.profilePic,
                                cacheManager:
                                    MyImageCacheManager.profileCacheManager,
                              ),
                            )
                          : Image.asset(
                              AssetsManager.openAILogo,
                              height: 30,
                              width: 30,
                            ),
                      const SizedBox(
                        width: 8,
                      ),
                      messageData[Constants.senderId] == user.uid
                          ? Expanded(
                              child: SelectableText(
                      messageData[Constants.message].trim(),
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : Expanded(
                              child: messageData[Constants.isText]
                                  ? SelectableText(
                                      messageData[Constants.message].trim(),
                                      style: TextStyle(
                                        color: color,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    )
                                  : Stack(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: messageData[Constants.message],
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) =>
                                    const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.orangeAccent,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                    const Center(
                                        child: Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        )),
                                    cacheManager: MyImageCacheManager.generatedImageCacheManager,
                                  ),

                                  Positioned(
                                    right: 10,
                                      top: 10,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.orangeAccent,
                                        child: IconButton(
                                          onPressed: (){
                                            showShareDialog();
                                          }, icon: Icon(Icons.share,color: color,),
                                        ),
                                      ))
                                ],

                                  ),
                      )
                    ],
                  ),
                ),
              )
            : Material(
                color: messageData[Constants.senderId] == user.uid
                    ? Constants.chatGPTDarkScaffoldColor
                    : Constants.chatGPTDarkCardColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      messageData[Constants.senderId] == user.uid
                          ? CircleAvatar(
                              key: UniqueKey(),
                              radius: 15,
                              backgroundImage: CachedNetworkImageProvider(
                                user.profilePic,
                                cacheManager:
                                    MyImageCacheManager.profileCacheManager,
                              ),
                            )
                          : Image.asset(
                              AssetsManager.openAILogo,
                              height: 30,
                              width: 30,
                            ),
                      const SizedBox(
                        width: 8,
                      ),
                      messageData[Constants.senderId] == user.uid
                          ? Expanded(
                              child: SelectableText(
                                messageData[Constants.message].trim(),
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : Expanded(
                              child: messageData[Constants.isText]
                                  ? SelectableText(
                                messageData[Constants.message].trim(),
                                      style: TextStyle(
                                        color: color,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    )
                                  : Stack(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: messageData[Constants.message],
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) =>
                                    const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.orangeAccent,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                    const Center(
                                        child: Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        )),
                                    cacheManager: MyImageCacheManager.generatedImageCacheManager,
                                  ),

                                  Positioned(
                                      right: 10,
                                      top: 10,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.orangeAccent,
                                        child: IconButton(
                                          onPressed: (){
                                            showShareDialog();
                                          }, icon: Icon(Icons.share, color: color,),
                                        ),
                                      ))
                                ],

                              ),
                            )
                    ],
                  ),
                ),
              )
      ],
    );
  }
}
