import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/app_assets.dart';

class CustomSnackBarContent extends StatelessWidget {
  const CustomSnackBarContent({
    super.key,
    required this.text,
    this.errorSnackBar = true,
  });

  final String text;
  final bool errorSnackBar;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          height: 90,
          decoration: BoxDecoration(
            color: errorSnackBar ? const Color(0xffC72C41) : const Color(0xff4e8c7c),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 48,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      errorSnackBar ? 'Oh snap!' : 'Hi there!',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
            ),
            child: SvgPicture.asset(
              AppAssets.bubbles,
              height: 48,
              width: 40,
              colorFilter: ColorFilter.mode(
                errorSnackBar ? const Color(0xff801336) : const Color(0xff065661),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        Positioned(
          top: -18,
          left: 0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                AppAssets.fail,
                height: 40,
                colorFilter: ColorFilter.mode(
                  errorSnackBar ? const Color(0xff801336) : const Color(0xff065661),
                  BlendMode.srcIn,
                ),
              ),
              Positioned(
                top: 10,
                child: SvgPicture.asset(
                  errorSnackBar ? AppAssets.close : AppAssets.check,
                  height: 16,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
