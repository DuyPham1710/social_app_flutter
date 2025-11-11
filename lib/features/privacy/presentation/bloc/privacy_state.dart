import 'package:equatable/equatable.dart';
import 'package:social_app_fe/features/privacy/domain/entities/privacy_entity.dart';

abstract class PrivacyState extends Equatable {
  const PrivacyState();

  @override
  List<Object?> get props => [];
}

class PrivacyInitial extends PrivacyState {}

class PrivacyLoading extends PrivacyState {}

class PrivacyLoaded extends PrivacyState {
  final PrivacyEntity privacyEntity;
  final String selectedPrivacy;

  const PrivacyLoaded({
    required this.privacyEntity,
    required this.selectedPrivacy,
  });

  @override
  List<Object?> get props => [privacyEntity, selectedPrivacy];

  PrivacyLoaded copyWith({
    PrivacyEntity? privacyEntity,
    String? selectedPrivacy,
    bool? isSetAsDefault,
  }) {
    return PrivacyLoaded(
      privacyEntity: privacyEntity ?? this.privacyEntity,
      selectedPrivacy: selectedPrivacy ?? this.selectedPrivacy,
    );
  }
}

class PrivacyError extends PrivacyState {
  final String message;

  const PrivacyError({required this.message});

  @override
  List<Object?> get props => [message];
}

class PrivacyUpdating extends PrivacyState {}

class PrivacyUpdated extends PrivacyState {
  final PrivacyEntity privacyEntity;
  final String message;

  const PrivacyUpdated({required this.privacyEntity, required this.message});

  @override
  List<Object?> get props => [privacyEntity, message];
}
