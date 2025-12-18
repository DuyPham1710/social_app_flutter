import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/video_call/domain/entities/video_call_entities.dart';
import 'package:social_app_fe/features/video_call/domain/usecases/video_call_usecases.dart';
import 'package:social_app_fe/features/video_call/presentation/bloc/video_call_event.dart';
import 'package:social_app_fe/features/video_call/presentation/bloc/video_call_state.dart';

class VideoCallBloc extends Bloc<VideoCallEvent, VideoCallState> {
  final ConnectVideoCallUseCase connectVideoCallUseCase;
  final CreateCallUseCase createCallUseCase;
  final AcceptCallUseCase acceptCallUseCase;
  final RejectCallUseCase rejectCallUseCase;
  final EndCallUseCase endCallUseCase;
  final ListenIncomingCallUseCase listenIncomingCallUseCase;
  final ListenCallAcceptedUseCase listenCallAcceptedUseCase;
  final ListenCallRejectedUseCase listenCallRejectedUseCase;
  final ListenCallEndedUseCase listenCallEndedUseCase;
  final DisconnectVideoCallUseCase disconnectVideoCallUseCase;

  StreamSubscription? _incomingCallSubscription;
  StreamSubscription? _callAcceptedSubscription;
  StreamSubscription? _callRejectedSubscription;
  StreamSubscription? _callEndedSubscription;

  VideoCallBloc({
    required this.connectVideoCallUseCase,
    required this.createCallUseCase,
    required this.acceptCallUseCase,
    required this.rejectCallUseCase,
    required this.endCallUseCase,
    required this.listenIncomingCallUseCase,
    required this.listenCallAcceptedUseCase,
    required this.listenCallRejectedUseCase,
    required this.listenCallEndedUseCase,
    required this.disconnectVideoCallUseCase,
  }) : super(const VideoCallState()) {
    on<ConnectVideoCall>(_onConnectVideoCall);
    on<CreateCall>(_onCreateCall);
    on<AcceptCall>(_onAcceptCall);
    on<RejectCall>(_onRejectCall);
    on<EndCall>(_onEndCall);
    on<IncomingCallReceived>(_onIncomingCallReceived);
    on<CallAccepted>(_onCallAccepted);
    on<CallRejected>(_onCallRejected);
    on<CallEnded>(_onCallEnded);
    on<DisconnectVideoCall>(_onDisconnectVideoCall);
    on<ClearCallState>(_onClearCallState);

    // Setup socket listeners khi khởi tạo BLoC (như MessageBloc)
    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    // Listen for incoming calls
    _incomingCallSubscription = listenIncomingCallUseCase.call().listen((data) {
      add(IncomingCallReceived(data));
    });

    // Listen for call accepted
    _callAcceptedSubscription = listenCallAcceptedUseCase.call().listen((data) {
      add(CallAccepted(data));
    });

    // Listen for call rejected
    _callRejectedSubscription = listenCallRejectedUseCase.call().listen((data) {
      add(CallRejected(data));
    });

    // Listen for call ended
    _callEndedSubscription = listenCallEndedUseCase.call().listen((data) {
      add(CallEnded(data));
    });
  }

  Future<void> _onConnectVideoCall(
    ConnectVideoCall event,
    Emitter<VideoCallState> emit,
  ) async {
    try {
      emit(state.copyWith(status: VideoCallStatus.connecting));

      // Connect to video call socket
      connectVideoCallUseCase.call(event.userId, event.username);

      // Wait for connection to be established
      await connectVideoCallUseCase.waitForConnection();

      emit(state.copyWith(status: VideoCallStatus.connected));
    } catch (e) {
      emit(
        state.copyWith(
          status: VideoCallStatus.error,
          errorMessage: 'Failed to connect: $e',
        ),
      );
    }
  }

  Future<void> _onCreateCall(
    CreateCall event,
    Emitter<VideoCallState> emit,
  ) async {
    try {
      emit(state.copyWith(status: VideoCallStatus.creatingCall));

      final callResponse = await createCallUseCase.call(
        userId: event.userId,
        receiverId: event.receiverId,
        callType: event.callType,
        conversationId: event.conversationId,
      );

      emit(
        state.copyWith(
          status: VideoCallStatus.callCreated,
          activeCall: callResponse,
          tokenEntity: callResponse.toTokenEntity(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: VideoCallStatus.error,
          errorMessage: 'Failed to create call: $e',
        ),
      );
    }
  }

  Future<void> _onAcceptCall(
    AcceptCall event,
    Emitter<VideoCallState> emit,
  ) async {
    try {
      emit(state.copyWith(status: VideoCallStatus.acceptingCall));

      final tokenEntity = await acceptCallUseCase.call(
        userId: event.userId,
        callId: event.callId,
      );

      emit(
        state.copyWith(
          status: VideoCallStatus.acceptingCall,
          tokenEntity: tokenEntity,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: VideoCallStatus.error,
          errorMessage: 'Failed to accept call: $e',
        ),
      );
    }
  }

  void _onRejectCall(RejectCall event, Emitter<VideoCallState> emit) {
    try {
      rejectCallUseCase.call(userId: event.userId, callId: event.callId);

      emit(
        state.copyWith(
          status: VideoCallStatus.callRejected,
          incomingCall: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: VideoCallStatus.error,
          errorMessage: 'Failed to reject call: $e',
        ),
      );
    }
  }

  void _onEndCall(EndCall event, Emitter<VideoCallState> emit) {
    try {
      endCallUseCase.call(
        userId: event.userId,
        callId: event.callId,
        duration: event.duration,
        callStatus: event.callStatus, // Pass callStatus to backend
      );

      emit(
        state.copyWith(
          status: VideoCallStatus.callEnded,
          activeCall: null,
          tokenEntity: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: VideoCallStatus.error,
          errorMessage: 'Failed to end call: $e',
        ),
      );
    }
  }

  void _onIncomingCallReceived(
    IncomingCallReceived event,
    Emitter<VideoCallState> emit,
  ) {
    emit(
      state.copyWith(
        status: VideoCallStatus.incomingCall,
        incomingCall: event.callData,
      ),
    );
  }

  void _onCallAccepted(CallAccepted event, Emitter<VideoCallState> emit) {
    try {
      final data = event.data;

      // Check if this is for the receiver (acceptedBy field indicates who accepted)
      final acceptedBy = data['acceptedBy'] as String?;
      final isReceiver =
          acceptedBy !=
          null; // If acceptedBy exists, this event is for the caller

      if (isReceiver) {
        // This is the caller receiving notification that receiver accepted
        // Just update status, don't navigate (caller already has VideoCallScreen open)
        debugPrint(
          '[VideoCallBloc] Call accepted by receiver, staying in current screen',
        );
        emit(state.copyWith(status: VideoCallStatus.callAccepted));
        return;
      }

      // This is the receiver getting their token after accepting
      // Use token from state (from AcceptCall API response) if available,
      // otherwise parse from socket event
      final tokenEntity =
          state.tokenEntity ??
          CallTokenEntity(
            token: data['token'] as String? ?? '',
            appId: data['appId'] as String? ?? '',
            channelId: data['channelId'] as String? ?? '',
            callId: data['callId'] as String? ?? '',
          );

      // Parse caller info to create IncomingCallEntity (for receiver to display)
      IncomingCallEntity? incomingCall;
      if (data['callerInfo'] != null) {
        final callerInfoData = data['callerInfo'] as Map<String, dynamic>;
        incomingCall = IncomingCallEntity(
          callId: data['callId'] as String? ?? '',
          channelId: data['channelId'] as String? ?? '',
          callerId: data['callerId'] as String? ?? '',
          callerInfo: UserEntity(
            userId: callerInfoData['userId'] as String? ?? '',
            username: callerInfoData['username'] as String? ?? '',
            fullName: callerInfoData['fullName'] as String?,
            avatarUrl: callerInfoData['avatarUrl'] as String?,
            email: callerInfoData['email'] as String?,
          ),
          callType: data['callType'] as String? ?? 'video',
          conversationId: data['conversationId'] as String?,
        );
      }

      debugPrint(
        '[VideoCallBloc] Receiver accepted call, navigating to VideoCallScreen',
      );
      debugPrint(
        '[VideoCallBloc] - Caller: ${incomingCall?.callerInfo?.fullName ?? "Unknown"}',
      );
      emit(
        state.copyWith(
          status: VideoCallStatus.inCall,
          tokenEntity: tokenEntity,
          incomingCall:
              incomingCall ?? state.incomingCall, // Keep existing if available
        ),
      );
    } catch (e) {
      debugPrint('[VideoCallBloc] Error parsing call accepted data: $e');
      emit(state.copyWith(status: VideoCallStatus.inCall));
    }
  }

  void _onCallRejected(CallRejected event, Emitter<VideoCallState> emit) {
    emit(
      state.copyWith(
        status: VideoCallStatus.callRejected,
        activeCall: null,
        tokenEntity: null,
      ),
    );
  }

  void _onCallEnded(CallEnded event, Emitter<VideoCallState> emit) {
    emit(
      state.copyWith(
        status: VideoCallStatus.callEnded,
        activeCall: null,
        incomingCall: null,
        tokenEntity: null,
      ),
    );
  }

  void _onDisconnectVideoCall(
    DisconnectVideoCall event,
    Emitter<VideoCallState> emit,
  ) {
    try {
      disconnectVideoCallUseCase.call();
      emit(state.copyWith(status: VideoCallStatus.disconnected));
    } catch (e) {
      emit(
        state.copyWith(
          status: VideoCallStatus.error,
          errorMessage: 'Failed to disconnect: $e',
        ),
      );
    }
  }

  void _onClearCallState(ClearCallState event, Emitter<VideoCallState> emit) {
    emit(state.clearCall());
  }

  @override
  Future<void> close() {
    _incomingCallSubscription?.cancel();
    _callAcceptedSubscription?.cancel();
    _callRejectedSubscription?.cancel();
    _callEndedSubscription?.cancel();
    return super.close();
  }
}
