import 'dart:developer';

import 'package:dash_bubble/dash_bubble.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

launchCustomUrl(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    return false;
  }
}

showScaffoldMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

Future<void> runMethod(
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
    showScaffoldMessage(context, 'Error: $error');
  }
}

Future<void> hasOverlayPermission(BuildContext context) async {
  await runMethod(
    context,
    () async {
      final hasPermission = await DashBubble.instance.hasOverlayPermission();

      hasPermission
          ? showScaffoldMessage(context, 'Permiso de "Overlay" otorgado')
          : showScaffoldMessage(
              context, 'Permiso de "Overlay" aún no otorgado');
    },
  );
}

Future<void> requestOverlayPermission(BuildContext context) async {
  await runMethod(
    context,
    () async {
      final isGranted = await DashBubble.instance.requestOverlayPermission();

      isGranted
          ? showScaffoldMessage(context, 'Permiso de "Overlay" otorgado')
          : showScaffoldMessage(context, 'Permiso de "Overlay" no otorgado');
    },
  );
}

Future<void> hasPostNotificationsPermission(BuildContext context) async {
  await runMethod(
    context,
    () async {
      final hasPermission =
          await DashBubble.instance.hasPostNotificationsPermission();

      hasPermission
          ? showScaffoldMessage(context, 'Permiso de notificaciones orotgado')
          : showScaffoldMessage(
              context, 'Permiso de notificaciones aún orotgado');
    },
  );
}

Future<void> requestPostNotificationsPermission(
  BuildContext context,
) async {
  await runMethod(
    context,
    () async {
      final isGranted =
          await DashBubble.instance.requestPostNotificationsPermission();

      isGranted
          ? showScaffoldMessage(context, 'Permiso de notificaciones orotgado')
          : showScaffoldMessage(
              context, 'Permiso de notificaciones no otorgado');
    },
  );
}

Future<void> isRunning(BuildContext context) async {
  await runMethod(
    context,
    () async {
      final isRunning = await DashBubble.instance.isRunning();

      isRunning
          ? showScaffoldMessage(context, 'Bubble is Running')
          : showScaffoldMessage(context, 'Bubble is not Running');
    },
  );
}

Future<void> startBubble(
  BuildContext context, {
  BubbleOptions? bubbleOptions,
  NotificationOptions? notificationOptions,
  VoidCallback? onTap,
  Function(double x, double y)? onTapDown,
  Function(double x, double y)? onTapUp,
  Function(double x, double y)? onMove,
}) async {
  await runMethod(
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
      hasStarted
          ? showScaffoldMessage(context, 'Bubble Started')
          : showScaffoldMessage(context, 'Bubble has not Started');
    },
  );
}

Future<void> stopBubble(BuildContext context) async {
  await runMethod(
    context,
    () async {
      final hasStopped = await DashBubble.instance.stopBubble();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(hasStopped ? 'Bubble Stopped' : 'Bubble has not Stopped')));
    },
  );
}

Future<void> showBubble(BuildContext context, String lat, String lon) async {
  await runMethod(
    context,
    () async {
      final hasOverlayPermission =
          await DashBubble.instance.hasOverlayPermission();
      final hasPostNotificationsPermission =
          await DashBubble.instance.hasPostNotificationsPermission();
      if (!hasOverlayPermission) {
        requestOverlayPermission(context);
      } else if (!hasPostNotificationsPermission) {
        requestPostNotificationsPermission(context);
      } else {
        startBubble(context,
            bubbleOptions: BubbleOptions(
              bubbleIcon: 'app_logo',
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
              title: 'Silver Express',
              body: 'Silver Express se está ejecutando en segundo plano',
              channelId: 'dash_bubble_notification',
              channelName: 'Dash Bubble Notification',
              icon: 'app_logo',
            ),
            onTap: () => {
                  launchCustomUrl("backapp://backapp.com"),
                  stopBubble(context)
                });
        launchCustomUrl("https://waze.com/ul?ll=$lat,$lon&navigate=yes");
      }
    },
  );
}
