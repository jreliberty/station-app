import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../constants/colors.dart';

class SlidableWidgetCard<T> extends StatelessWidget {
  final Widget child;
  const SlidableWidgetCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      child: child,
      secondaryActions: [
        IconSlideAction(
          color: ColorsApp.BackgroundBrandSecondary,
          iconWidget: Icon(
            CupertinoIcons.pencil,
            color: Color.fromRGBO(0, 125, 188, 1),
          ),
          onTap: () {},
        ),
        IconSlideAction(
          color: Color.fromRGBO(254, 236, 237, 1),
          iconWidget: Icon(
            CupertinoIcons.trash,
            color: Color.fromRGBO(227, 38, 47, 1),
          ),
          onTap: () {},
        )
      ],
    );
  }
}
