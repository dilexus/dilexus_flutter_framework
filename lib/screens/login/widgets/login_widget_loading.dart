import 'package:dilexus/imports.dart';

import 'login_back_button.dart';

class DxLoginWidgetLoading extends StatelessWidget {
  final CarouselController carouselController;
  final DxLoginWidgetLoadingMessage loadingMessage;

  DxLoginWidgetLoading(this.carouselController, this.loadingMessage);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 32,
                child: DxLoginBackButton(carouselController,
                    () => carouselController.jumpToPage(loadingMessage._initialPage)),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      HeartbeatProgressIndicator(
                        child: Icon(loadingMessage._icon, color: Theme.of(context).primaryColor),
                      ),
                      SizedBox(
                        height: 28,
                      ),
                      JumpingText(
                        loadingMessage._message,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GlowingProgressIndicator(child: Text(loadingMessage._progressMessage)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DxLoginWidgetLoadingMessage {
  int _initialPage;
  IconData _icon;
  String _message;
  String _progressMessage;
  CarouselController _carouselController;

  set carouselController(CarouselController value) {
    _carouselController = value;
  }

  set initialPage(int value) {
    _initialPage = value;
  }

  set icon(IconData value) {
    _icon = value;
  }

  set message(String value) {
    _message = value;
  }

  set progressMessage(String value) {
    _progressMessage = value;
  }

  void dismiss() {
    if (_carouselController != null) {
      _carouselController.jumpToPage(_initialPage);
    }
  }
}
