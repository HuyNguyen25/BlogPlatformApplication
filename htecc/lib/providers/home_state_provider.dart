import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:htecc/models/home_state.dart';

class HomeStateNotifier extends Notifier<HomeState> {
  @override
  HomeState build() {
    // TODO: implement build
    return HomeState.NEWS_FEED;
  }

  void switchToSettings() => state = HomeState.SETTINGS;
  void switchToNewsFeed() => state = HomeState.NEWS_FEED;
  void switchToBlogView() {
    if(state == HomeState.NEWS_FEED)
      state = HomeState.OTHER_BLOG_VIEW;
    else state = HomeState.MY_BLOG_VIEW;
  }
  void switchToMyBlogs() => state = HomeState.MY_BLOGS;
}

final homeStateProvider = NotifierProvider<HomeStateNotifier, HomeState>(
    () => HomeStateNotifier()
);