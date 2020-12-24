abstract class BaseBlocState {
  bool _isLoading = false;

  startLoading() {
    _isLoading = true;
  }

  stopLoading() {
    _isLoading = false;
  }
}
