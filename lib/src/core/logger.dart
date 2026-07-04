class Logger {
  void info(String message) {
    print(message);
  }

  void success(String message) {
    print("✓ $message");
  }

  void warning(String message) {
    print("⚠ $message");
  }

  void error(String message) {
    print("✗ $message");
  }
}