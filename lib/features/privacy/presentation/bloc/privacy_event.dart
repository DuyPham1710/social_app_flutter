import 'package:equatable/equatable.dart';
import 'package:social_app_fe/features/privacy/domain/entities/privacy_entity.dart';

abstract class PrivacyEvent extends Equatable {
  const PrivacyEvent();

  @override
  List<Object?> get props => [];
}

class GetDefaultPrivacyRequested extends PrivacyEvent {}

class PrivacySelectionChanged extends PrivacyEvent {
  final String selectedPrivacy;

  const PrivacySelectionChanged({required this.selectedPrivacy});

  @override
  List<Object?> get props => [selectedPrivacy];
}

class SetDefaultPrivacyRequested extends PrivacyEvent {
  final PrivacyEntity privacyEntity;

  const SetDefaultPrivacyRequested({required this.privacyEntity});

  @override
  List<Object?> get props => [privacyEntity];
}
