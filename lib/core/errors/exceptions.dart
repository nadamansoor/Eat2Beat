class CustomExceptions implements Exception {
  final String message;
  CustomExceptions({required this.message});

  @override
  String toString(){
    return message;
  }
}

class RoleMismatchException extends CustomExceptions {
  RoleMismatchException({super.message = 'This account is not this role.'});
}

class ProfileNotFoundException extends CustomExceptions {
  ProfileNotFoundException({super.message = 'No profile in Supabase yet. Please create an account first.'});
}