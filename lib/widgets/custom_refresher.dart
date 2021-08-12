import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../public.dart';

class CustomRefresher extends StatelessWidget {
  CustomRefresher({
    Key? key,
    required this.child,
    required this.refreshController,
    this.idle,
    this.loading,
    this.failed,
    this.canLoading,
    this.noData,
    this.onLoading,
    this.onRefresh,
    this.enableHeader = true,
    this.enableFooter = true,
  }) : super(key: key);

  final Widget child;
  Widget? idle;
  Widget? loading;
  Widget? failed;
  Widget? canLoading;
  Widget? noData;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoading;
  final RefreshController refreshController;
  bool enableHeader;
  bool enableFooter;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: enableHeader,
      enablePullUp: enableFooter,
      header: CustomHeader(
        builder: (BuildContext context, RefreshStatus? mode) {
          Widget? body;
          if (mode == RefreshStatus.idle) {
            body = Text('refresh_pull_down_to_refresh_data'.local(),
                style: TextStyle(color: Colors.white));
          } else if (mode == RefreshStatus.canRefresh) {
            body = Text('refresh_release_to_refresh_data'.local(),
                style: TextStyle(color: Colors.white));
          } else if (mode == RefreshStatus.refreshing) {
            body = Text('refresh_data'.local(),
                style: TextStyle(color: Colors.white));
          } else if (mode == RefreshStatus.completed) {
            body = Text('refresh_finish'.local(),
                style: TextStyle(color: Colors.white));
          } else {}
          return Container(
              height: 55.0, child: Center(child: body), color: Colors.transparent);
        },
      ),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = this.idle ??= Text('refresh_pull_up_loading'.local(),
                style: TextStyle(color: Colors.white));
          } else if (mode == LoadStatus.loading) {
            body = this.loading ??= Text('refresh_data'.local(),
                style: TextStyle(color: Colors.white));
          } else if (mode == LoadStatus.failed) {
            body = this.failed ??= Text('refresh_failed_to_load'.local(),
                style: TextStyle(color: Colors.white));
          } else if (mode == LoadStatus.canLoading) {
            body = this.canLoading ??= Text('refresh_let_go'.local(),
                style: TextStyle(color: Colors.white));
          } else {
            body = this.noData ??= Text('refresh_empty'.local(),
                style: TextStyle(color: Colors.white));
          }
          return Container(
            height: 55.0,
            color: Colors.transparent,
            child: Center(child: body),
          );
        },
      ),
      controller: this.refreshController,
      onRefresh: this.onRefresh,
      onLoading: this.onLoading,
      child: child,
    );
  }
}
