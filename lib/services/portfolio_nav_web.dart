// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void platformOpenPortfolio() {
  try {
    final origin = html.window.location.origin;
    final pathname = html.window.location.pathname ?? '';
    if (pathname.contains('/a-task')) {
      // Running inside portfolio Next.js deployment: go to portfolio root
      html.window.location.href = '$origin/';
    } else if (html.window.history.length > 1) {
      // Running standalone with back history: navigate back
      html.window.history.back();
    } else {
      // Fallback portfolio homepage URL
      html.window.location.href = 'https://aymanedahhak.com';
    }
  } catch (_) {
    try {
      html.window.location.href = '/';
    } catch (_) {}
  }
}
