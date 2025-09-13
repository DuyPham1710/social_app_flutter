import 'package:dio/dio.dart';

class ErrorUtils {
  /// Extract error message from DioException
  /// Handles different types of error responses
  static String getErrorMessage(DioException dioException) {
    // Check if there's a response with error data
    if (dioException.response?.data != null) {
      final responseData = dioException.response!.data;
      
      // If response data is a Map, try to extract message
      if (responseData is Map<String, dynamic>) {
        // Try different possible message fields
        final message = responseData['message'] ?? 
                       responseData['error'] ?? 
                       responseData['errorMessage'] ??
                       responseData['msg'];
        
        if (message != null) {
          // Handle different message types
          if (message is String) {
            return message;
          } else if (message is List) {
            // Handle validation error array format
            return _extractValidationErrors(message);
          }
        }
      }
      
      // If response data is a String, return it
      if (responseData is String) {
        return responseData;
      }
    }
    
    // Fallback to DioException message
    return dioException.message ?? 'An unknown error occurred';
  }
  
  /// Extract validation errors from array format
  /// Handles format like: [{"confirmPassword": "Password and confirm password must match"}]
  static String _extractValidationErrors(List messageList) {
    if (messageList.isEmpty) {
      return 'Validation error occurred';
    }
    
    final List<String> errorMessages = [];
    
    for (final item in messageList) {
      if (item is Map<String, dynamic>) {
        // Get all error messages from the map
        final messages = item.values.whereType<String>().toList();
        errorMessages.addAll(messages);
      }
    }
    
    if (errorMessages.isEmpty) {
      return 'Validation error occurred';
    }
    
    // Join all error messages with newlines or commas
    return errorMessages.join('\n');
  }
  
  /// Get error message with fallback options
  static String getErrorMessageWithFallback(
    DioException dioException, {
    String? fallbackMessage,
  }) {
    final message = getErrorMessage(dioException);
    
    // If message is empty or generic, use fallback
    if (message.isEmpty || 
        message == 'An unknown error occurred' ||
        message == dioException.message) {
      return fallbackMessage ?? 'Something went wrong. Please try again.';
    }
    
    return message;
  }
}
