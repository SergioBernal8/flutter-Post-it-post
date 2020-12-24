abstract class BaseBlocState {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  startLoading() {
    _isLoading = true;
  }

  stopLoading() {
    _isLoading = false;
  }
}
