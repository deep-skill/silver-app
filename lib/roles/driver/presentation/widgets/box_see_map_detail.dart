import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:developer';

import 'package:dash_bubble/dash_bubble.dart';

class SeeMap extends StatelessWidget {
  const SeeMap({
    super.key,
    required this.arrivedDriver,
    required this.startTime,
    required this.endTime,
    required this.startAddress,
    required this.startAddressLat,
    required this.startAddressLon,
    this.endAddress,
    this.endAddressLat,
    this.endAddressLon,
  });
  final DateTime? arrivedDriver;
  final DateTime? startTime;
  final DateTime? endTime;
  final String startAddress;
  final double startAddressLat;
  final double startAddressLon;
  final String? endAddress;
  final double? endAddressLat;
  final double? endAddressLon;

  @override
  Widget build(BuildContext context) {
    launchCustomUrl(String url) async {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        return false;
      }
    }

    return SizedBox(
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        ElevatedButton(
            child: const Row(children: [
              Icon(
                Icons.map,
                color: Color(0xFF23A5CD),
              ),
              Text("Ver mapa",
                  style: TextStyle(
                    color: Color(0xFF23A5CD),
                    decoration: TextDecoration.underline,
                    fontFamily: "Montserrat-Bold",
                    fontSize: 16,
                  ))
            ]),
            onPressed: () {
              if (arrivedDriver == null) {
                    _requestOverlayPermission(context);
                    _hasOverlayPermission(context);
                     _startBubble(
                    context,
                    bubbleOptions: BubbleOptions(
                      // notificationIcon: 'github_bubble',
                      bubbleIcon: 'github_bubble',
                      // closeIcon: 'github_bubble',
                      startLocationX: 0,
                      startLocationY: 100,
                      bubbleSize: 60,
                      opacity: 1,
                      enableClose: true,
                      closeBehavior: CloseBehavior.following,
                      distanceToClose: 100,
                      enableAnimateToEdge: true,
                      enableBottomShadow: true,
                      keepAliveWhenAppExit: false,
                    ),
                    notificationOptions: NotificationOptions(
                      id: 1,
                      title: 'Dash Bubble Playground',
                      body: 'Dash Bubble service is running',
                      channelId: 'dash_bubble_notification',
                      channelName: 'Dash Bubble Notification',
                    ),
                    onTap: () => launchCustomUrl("backApp://backApp.com"),
                    /* _logMessage(
                      context: context,
                      message: 'Bubble Tapped',
                    ), */
                    /* onTapDown: (x, y) => _logMessage(
                      context: context,
                      message:
                          'Bubble Tapped Down on: ${_getRoundedCoordinatesAsString(x, y)}',
                    ),
                    onTapUp: (x, y) => _logMessage(
                      context: context,
                      message:
                          'Bubble Tapped Up on: ${_getRoundedCoordinatesAsString(x, y)}',
                    ),
                    onMove: (x, y) => _logMessage(
                      context: context,
                      message:
                          'Bubble Moved to: ${_getRoundedCoordinatesAsString(x, y)}',
                    ), */
                  );
                  launchCustomUrl(
                    "https://waze.com/ul?ll=${startAddressLat.toString()},${startAddressLon.toString()}&navigate=yes");
              }
              if (arrivedDriver != null &&
                  startTime != null &&
                  endAddress != null) {
                _requestOverlayPermission(context);
                    _hasOverlayPermission(context);
                
                
                     _startBubble(
                    context,
                    bubbleOptions: BubbleOptions(
                      // notificationIcon: 'github_bubble',
                      bubbleIcon: 'github_bubble',
                      // closeIcon: 'github_bubble',
                      startLocationX: 0,
                      startLocationY: 100,
                      bubbleSize: 60,
                      opacity: 1,
                      enableClose: true,
                      closeBehavior: CloseBehavior.following,
                      distanceToClose: 100,
                      enableAnimateToEdge: true,
                      enableBottomShadow: true,
                      keepAliveWhenAppExit: false,
                    ),
                    notificationOptions: NotificationOptions(
                      id: 1,
                      title: 'Dash Bubble Playground',
                      body: 'Dash Bubble service is running',
                      channelId: 'dash_bubble_notification',
                      channelName: 'Dash Bubble Notification',
                    ),
                    onTap: () => 
                      print('holaaaaaa')
                      /* context.go('driver/home') */,
                    
                                /* _logMessage(
                      context: context,
                      message: 'Bubble Tapped',
                    ), */
                    /* onTapDown: (x, y) => _logMessage(
                      context: context,
                      message:
                          'Bubble Tapped Down on: ${_getRoundedCoordinatesAsString(x, y)}',
                    ),
                    onTapUp: (x, y) => _logMessage(
                      context: context,
                      message:
                          'Bubble Tapped Up on: ${_getRoundedCoordinatesAsString(x, y)}',
                    ),
                    onMove: (x, y) => _logMessage(
                      context: context,
                      message:
                          'Bubble Moved to: ${_getRoundedCoordinatesAsString(x, y)}',
                    ), */
                  );
                  launchCustomUrl(
                    "https://waze.com/ul?ll=${endAddressLat.toString()},${endAddressLon.toString()}&navigate=yes");
              }
            }),
      ]),
    );
  }

Future<void> _runMethod(
    BuildContext context,
    Future<void> Function() method,
  ) async {
    try {
      await method();
    } catch (error) {
      log(
        name: 'Dash Bubble Playground',
        error.toString(),
      );

ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error: ${error.runtimeType}')));
    }
  }

  Future<void> _requestOverlayPermission(BuildContext context) async {
    await _runMethod(
      context,
      () async {
        final isGranted = await DashBubble.instance.requestOverlayPermission();

        ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(isGranted
              ? 'Overlay Permission Granted'
              : 'Overlay Permission is not Granted',)));
      },
    );
  }

  Future<void> _hasOverlayPermission(BuildContext context) async {
    await _runMethod(
      context,
      () async {
        final hasPermission = await DashBubble.instance.hasOverlayPermission();

        ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(hasPermission
              ? 'Overlay Permission Granted'
              : 'Overlay Permission is not Granted',)));
      },
    );
  }

  Future<void> _requestPostNotificationsPermission(
    BuildContext context,
  ) async {
    await _runMethod(
      context,
      () async {
        final isGranted =
            await DashBubble.instance.requestPostNotificationsPermission();

        ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(isGranted
              ? 'Post Notifications Permission Granted'
              : 'Post Notifications Permission is not Granted',)));
      },
    );
  }

  Future<void> _hasPostNotificationsPermission(BuildContext context) async {
    await _runMethod(
      context,
      () async {
        final hasPermission =
            await DashBubble.instance.hasPostNotificationsPermission();


        ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(hasPermission
              ? 'Post Notifications Permission Granted'
              : 'Post Notifications Permission is not Granted',)));
      },
    );
  }

  Future<void> _isRunning(BuildContext context) async {
    await _runMethod(
      context,
      () async {
        final isRunning = await DashBubble.instance.isRunning();

        ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(isRunning ? 'Bubble is Running' : 'Bubble is not Running')));
      },
    );
  }

  Future<void> _startBubble(
    BuildContext context, {
    BubbleOptions? bubbleOptions,
    NotificationOptions? notificationOptions,
    VoidCallback? onTap,
    Function(double x, double y)? onTapDown,
    Function(double x, double y)? onTapUp,
    Function(double x, double y)? onMove,
  }) async {
    await _runMethod(
      context,
      () async {
        final hasStarted = await DashBubble.instance.startBubble(
          bubbleOptions: bubbleOptions,
          notificationOptions: notificationOptions,
          onTap: onTap,
          onTapDown: onTapDown,
          onTapUp: onTapUp,
          onMove: onMove,
        );
        ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(hasStarted ? 'Bubble Started' : 'Bubble has not Started')));
      },
    );
  }

  Future<void> _stopBubble(BuildContext context) async {
    await _runMethod(
      context,
      () async {
        final hasStopped = await DashBubble.instance.stopBubble();

        ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(hasStopped ? 'Bubble Stopped' : 'Bubble has not Stopped')));
      },
    );
  }

  void _logMessage({required BuildContext context, required String message}) {
    log(name: 'DashBubblePlayground', message);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  String _getRoundedCoordinatesAsString(double x, double y) {
    return '${x.toStringAsFixed(2)}, ${y.toStringAsFixed(2)}';
  }
}