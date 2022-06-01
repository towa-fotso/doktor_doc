
import 'package:flutter/services.dart';

playpressedVibration(){
return HapticFeedback.mediumImpact();
}

playpressedSound(){
  return SystemSound.play(SystemSoundType.click);
}