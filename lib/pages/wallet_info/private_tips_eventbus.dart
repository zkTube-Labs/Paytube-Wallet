import 'package:event_bus/event_bus.dart';

EventBus privateTipsEventBus = EventBus();

class PrivateTipsEventBus {
  String tipString;
  PrivateTipsEventBus(this.tipString);
}
