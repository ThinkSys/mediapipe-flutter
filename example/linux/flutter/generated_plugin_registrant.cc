//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <thinksys_mediapipe_plugin/thinksys_mediapipe_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) thinksys_mediapipe_plugin_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "ThinksysMediapipePlugin");
  thinksys_mediapipe_plugin_register_with_registrar(thinksys_mediapipe_plugin_registrar);
}
