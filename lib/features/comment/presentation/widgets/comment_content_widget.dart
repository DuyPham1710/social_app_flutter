import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class CommentContentWidget extends StatelessWidget {
  final ScrollController scrollController;
  const CommentContentWidget({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.fromLTRB(12.rs(context), 12.rsh(context), 4.rs(context), 16.rsh(context)),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18.rsr(context),
                  backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrHT9KQ3vag-Gdd9sjA7pi6zl2f_ho4Gh7Vg&s',
                  ),
                ),

                SizedBox(width: 10.rs(context)),

                // Comment content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Comment container
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.rs(context),
                          vertical: 8.rsh(context),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundCommentItem,
                          borderRadius: BorderRadius.circular(14.rsr(context)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'User ${index + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.rsp(context),
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 3.rsh(context)),
                            Text(
                              'This is a comment from user ${index + 1}.',
                              style: TextStyle(
                                fontSize: 14.rsp(context),
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Bottom actions: date, like, reply
                          Padding(
                            padding: EdgeInsets.only(top: 4.rsh(context), left: 6.rs(context)),
                            child: Row(
                              children: [
                                Text(
                                  '6 ngày',
                                  style: TextStyle(
                                    fontSize: 12.rsp(context),
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                SizedBox(width: 10.rs(context)),
                                Text(
                                  'Thích',
                                  style: TextStyle(
                                    fontSize: 12.rsp(context),
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                SizedBox(width: 10.rs(context)),
                                Text(
                                  context.l10n.commentReply,
                                  style: TextStyle(
                                    fontSize: 12.rsp(context),
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Reaction badge (bottom right corner)
                          Padding(
                            padding: EdgeInsets.only(top: 4.rsh(context), left: 8.rs(context)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.rs(context),
                                    vertical: 2.rsh(context),
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(10.rsr(context)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.network(
                                        'https://i.pinimg.com/1200x/39/44/6c/39446caa52f53369b92bc97253d2b2f1.jpg',
                                        width: 12.rs(context),
                                        height: 12.rsh(context),
                                      ),
                                      SizedBox(width: 2.rs(context)),
                                      Image.network(
                                        'https://www.citypng.com/public/uploads/preview/haha-facebook-messenger-react-face-like-emoji-701751695136164me5ogbbpnk.png',
                                        width: 12.rs(context),
                                        height: 12.rsh(context),
                                      ),
                                      SizedBox(width: 4.rs(context)),
                                      Text(
                                        '5',
                                        style: TextStyle(
                                          fontSize: 11.rsp(context),
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
