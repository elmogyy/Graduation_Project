import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ennovation/controllers/chat_controller.dart';
import 'package:ennovation/models/message_model.dart';
import 'package:ennovation/services/firestore_services.dart';

import '../../../../consts/app_consts.dart';
import 'widgets/custom_message_item.dart';

class MessagesView extends StatefulWidget {
  const MessagesView({
    Key? key,
    required this.sellerName,
    required this.sellerId,
  }) : super(key: key);

  final String sellerName;
  final String sellerId;

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  var controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: widget.sellerName.text
            .color(AppColors.darkFontGrey)
            .fontFamily(AppStyles.semiBold)
            .make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirestoreServices.getMessages(id: widget.sellerId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<MessageModel> messages = List.from(
                        snapshot.data!.docs.map(
                          (e) => MessageModel.fromMap(
                              e.data() as Map<String, dynamic>),
                        ),
                      );
                      return ListView.builder(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        // reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return CustomMessageItem(message: messages[index]);
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
            10.heightBox,
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onFieldSubmitted: (value) {
                      if (messageController.text.isNotEmpty) {
                        MessageModel message = MessageModel(
                          message: messageController.text,
                          senderId: AppFirebase.currentUser!.uid,
                          receiverId: widget.sellerId,
                          time: DateTime.now().millisecondsSinceEpoch,
                        );
                        controller.sendMessage(
                            message: message, context: context);
                        messageController.clear();
                        scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            curve: Curves.bounceInOut,
                            duration: const Duration(milliseconds: 200));
                      }
                    },
                    controller: messageController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(12),
                      hintText: "Type a message...".tr,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      MessageModel message = MessageModel(
                        message: messageController.text,
                        senderId: AppFirebase.currentUser!.uid,
                        receiverId: widget.sellerId,
                        time: DateTime.now().millisecondsSinceEpoch,
                      );
                      controller.sendMessage(
                          message: message, context: context);
                      messageController.clear();
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        curve: Curves.bounceInOut,
                        duration: const Duration(milliseconds: 200),
                      );
                    }
                  },
                  icon: const Icon(Icons.send_outlined),
                  color: AppColors.redColor,
                ),
              ],
            ).box.white.roundedSM.shadowSm.make(),
          ],
        ),
      ),
    );
  }
}
