class KError {
  bool error = false;
  String errorText = 'NULL';

  KError(bool error, String errorText) {
    this.error = error;
    this.errorText = errorText;
  }

  void setError(bool status) => this.error = status;
  void setErrorText(String errorText) => this.errorText = errorText;
}
