import 'package:flutter/widgets.dart';

import '../../app/app_breakpoints.dart';

TextOverflow responsiveTextOverflow(BuildContext context) {
  return context.isMobile ? TextOverflow.fade : TextOverflow.ellipsis;
}
