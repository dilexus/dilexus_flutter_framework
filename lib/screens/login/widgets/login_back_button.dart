import 'package:dilexus/imports.dart';

typedef void OnBackButtonPressed();

class DxLoginBackButton extends StatelessWidget {
  final CarouselController carouselController;
  final OnBackButtonPressed onBackButtonPressed;

  const DxLoginBackButton(this.carouselController, this.onBackButtonPressed);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Align(
        child: IconButton(icon: FaIcon(FontAwesomeIcons.arrowLeft), onPressed: onBackButtonPressed),
        alignment: Alignment.topLeft,
      ),
    );
  }
}
