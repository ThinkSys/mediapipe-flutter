#include "include/thinksys_mediapipe_plugin/thinksys_mediapipe_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "thinksys_mediapipe_plugin.h"

void ThinksysMediapipePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  thinksys_mediapipe_plugin::ThinksysMediapipePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
