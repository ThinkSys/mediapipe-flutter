#ifndef FLUTTER_PLUGIN_THINKSYS_MEDIAPIPE_PLUGIN_H_
#define FLUTTER_PLUGIN_THINKSYS_MEDIAPIPE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace thinksys_mediapipe_plugin {

class ThinksysMediapipePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  ThinksysMediapipePlugin();

  virtual ~ThinksysMediapipePlugin();

  // Disallow copy and assign.
  ThinksysMediapipePlugin(const ThinksysMediapipePlugin&) = delete;
  ThinksysMediapipePlugin& operator=(const ThinksysMediapipePlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace thinksys_mediapipe_plugin

#endif  // FLUTTER_PLUGIN_THINKSYS_MEDIAPIPE_PLUGIN_H_
