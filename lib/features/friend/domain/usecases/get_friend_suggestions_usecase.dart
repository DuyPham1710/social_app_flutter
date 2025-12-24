import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/friend/data/models/friend_suggestion_model.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_suggestion_entity.dart';
import 'package:social_app_fe/features/friend/domain/repository/friend_repository.dart';

class GetFriendSuggestionsUseCase {
  final FriendRepository friendRepository;

  GetFriendSuggestionsUseCase(this.friendRepository);

  Future<DataState<List<FriendSuggestionEntity>>> call({int page = 1, int limit = 10}) async {
    final result = await friendRepository.getFriendSuggestions(page: page, limit: limit);
    
    if (result is DataStateSuccess) {
      // Load mutual friend avatars cho từng suggestion
      final suggestionsWithAvatars = await _loadMutualFriendAvatars(result.data!);
      return DataStateSuccess(suggestionsWithAvatars);
    }
    return result;
  }
  
  Future<List<FriendSuggestionEntity>> _loadMutualFriendAvatars(List<FriendSuggestionEntity> suggestions) async {
    final updatedSuggestions = <FriendSuggestionEntity>[];
    
    for (final suggestion in suggestions) {
      if (suggestion.mutualFriends == 0) {
        updatedSuggestions.add(suggestion);
        continue;
      }
      
      // Load mutual friends (tối đa 3)
      final mutualResult = await friendRepository.getMutualFriends(suggestion.userId, limit: 3);
      
      if (mutualResult is DataStateSuccess && mutualResult.data!.isNotEmpty) {
        // Lấy avatarUrl từ mutual friends
        final avatars = mutualResult.data!
            .map((friend) => friend.avatarUrl ?? 'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg')
            .take(3)
            .toList();
        
        final mutualFriendsCount = mutualResult.data!.length;
        // Tạo suggestion mới với avatars
        if (suggestion is FriendSuggestionModel) {
          final updated = suggestion.copyWith(
            mutualFriendAvatars: avatars,
            mutualFriends: suggestion.mutualFriends ?? mutualFriendsCount, // Giữ giá trị backend hoặc dùng count
          );
          updatedSuggestions.add(updated);
        } else {
          updatedSuggestions.add(suggestion);
        }
      } else {
        if (suggestion is FriendSuggestionModel) {
          updatedSuggestions.add(suggestion.copyWith(mutualFriends: 0));
        } else {
          updatedSuggestions.add(suggestion);
        }
      }
    }
    return updatedSuggestions;
  }
}


