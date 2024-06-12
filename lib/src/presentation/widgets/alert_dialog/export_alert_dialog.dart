import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_plan_app/src/common/enums.dart';

import '../../../common/app_styles/colors.dart';
import '../../../common/app_styles/text_styles.dart';

void exportAlertDialog(BuildContext context,
    {required String title, Function()? onPngTap, Function()? onJpgTap}) {
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppColors.background,
        contentPadding:
            EdgeInsets.only(top: 24.h, bottom: 12.h, left: 16, right: 16),
        actionsPadding: const EdgeInsets.all(16),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Text(
            title,
            style: AppTextStyle.titleSmall,
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onJpgTap,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset:
                              const Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Text(
                     'Export JPEG',
                      style: AppTextStyle.bodyLarge
                          .copyWith(color: AppColors.black),
                    ),
                  ),
                ),
              ),
              10.width,
              Expanded(
                child: InkWell(
                  onTap: onPngTap,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.main,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.main.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset:
                          const Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Text(
                      'Export PNG',
                      style: AppTextStyle.bodyLarge
                          .copyWith(color: AppColors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      );
    },
  );
}
