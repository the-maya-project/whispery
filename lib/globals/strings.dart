class Strings {
  static String emptyField = "Input cannot be empty.";
  static String invalidEmail = "Email must be of valid format.";
  static String invalidPassword = "Password must contain an uppercase letter, a symbol, a number and 8 characters long.";
  static String passwordMismatch = "Passwords do not match.";

  static String usernameMinLength = "username must be longer than 6 characters";
  static String bioMessage = "what's your story?";

  static String wrongLogin = "wrong email/password, try again 😔";
  static String emailExists = "email already exists, try again 😔";
  static String emptyEmail = "email cannot be empty";
  static String emptyPassword = "password cannot be empty";
  static String resetEmail = "an owl has been sent to the email provided 😔";
  static String notfoundEmail = "email not found, please try again 😔";
  static String invalidLocation =
      "Cannot access location. Check your permissions in settings.";
  static String postSuccess = "Successfully posted!";
  static String minLength = "Post should be at least 10 characters long.";
  static String endOfList = "Nothing left to display!";
  static String locationDisabled = "Location is disabled. Enable?";

  static String userPath = "users";
  static String postPath = "posts";
  static String commentPath = "comments";
  static List<String> options = [
    "A-Z",
    "Z-A",
    "Lowest Price First",
    "Highest Price First",
  ];

  static String postsFunction =
      "https://us-central1-whispery-1a75a.cloudfunctions.net/postFeed";
  static String commentsFunction =
      "https://us-central1-whispery-1a75a.cloudfunctions.net/commentFeed";

  static String feedFunction = "";
}

