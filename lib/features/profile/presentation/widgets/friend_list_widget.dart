import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_entity.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_bloc.dart';

class FriendListWidget extends StatefulWidget {
  final VoidCallback? onViewAll;

  const FriendListWidget({super.key, this.onViewAll});

  @override
  State<FriendListWidget> createState() => _FriendListWidgetState();
}

class _FriendListWidgetState extends State<FriendListWidget> {
  @override
  void initState() {
    super.initState();
    // Khi widget được tạo, gửi event để load danh sách bạn bè
    context.read<FriendBloc>().add(const LoadFriends());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendBloc, FriendState>(
      builder: (context, state) {
        if (state is FriendLoading) {
          return _buildContainer(
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
          );
        }

        if (state is FriendError) {
          return _buildContainer(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        if (state is FriendLoaded) {
          final friends = state.friends;

          if (friends.isEmpty) {
            return _buildContainer(
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    "Chưa có bạn bè nào",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            );
          }

          return _buildFriendList(friends);
        }

        // Trạng thái ban đầu (FriendInitial)
        return _buildContainer(
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
        );
      },
    );
  }

  /// Widget khung chứa danh sách bạn
  Widget _buildContainer({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  /// Widget danh sách bạn bè dạng Grid
  Widget _buildFriendList(List<FriendEntity> friends) {
    // Lấy tối đa 6 người
    final displayFriends = friends.take(6).toList();

    return _buildContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Bạn bè",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: widget.onViewAll,
                child: const Text(
                  "Xem tất cả",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: displayFriends.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final friend = displayFriends[index];
              return _FriendCard(friend: friend);
            },
          ),
        ],
      ),
    );
  }
}

/// Widget con hiển thị từng người bạn
class _FriendCard extends StatelessWidget {
  final FriendEntity friend;

  const _FriendCard({required this.friend});

  @override
  Widget build(BuildContext context) {
    final name = friend.fullName ?? friend.username ?? "Không tên";
    final avatarUrl = friend.avatarUrl ?? "";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Xử lý khi nhấn vào thẻ bạn bè
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                avatarUrl,
                width: double.infinity,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade100,
                  height: 100,
                  child: const Icon(Icons.person, size: 40, color: Colors.grey),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
