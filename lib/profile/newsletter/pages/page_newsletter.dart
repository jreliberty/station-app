import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/newsletter/newsletter_bloc.dart';
import '../../../core/utils/page_maintenance.dart';
import 'page_newsletter_subscribed.dart';
import 'page_newsletter_unsubscribed.dart';

class PageNewsletter extends StatefulWidget {
  PageNewsletter({Key? key}) : super(key: key);

  @override
  _PageNewsletterState createState() => _PageNewsletterState();
}

class _PageNewsletterState extends State<PageNewsletter> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsletterBloc, NewsletterState>(
      builder: (context, state) {
        if (state is NewsletterLoadSuccess) {
          print(state.isSubscribed);
          if (state.isSubscribed)
            return PageNewsletterSubscribed();
          else
            return PageNewsletterUnsubscribed();
        } else
          return PageMaintenance();
      },
    );
  }
}
