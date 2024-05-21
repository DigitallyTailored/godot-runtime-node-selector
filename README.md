Allows for clicking on nodes in a running game and they will be displayed in the Godot inspector ready for immediate editing.

Add the `RuntimeSelectorAutload.gd` script to your AutoLoads to let the editor listen for clicked_node messages, then just add the `RuntimeSelector` scene to your scene. You will need to open the remote tab at least once due to the way the remote tree selection works - kinda hacky as there is no direct API for interacting with these trees.

https://github.com/DigitallyTailored/godot-runtime-node-selector/assets/13086157/5c3e2127-2041-4391-b5cd-7269effa1f77

Importantly it also supports dynamically added nodes too as shown in the video. It only works for 3D at the moment though but would just need to change the picker to handle 2D I think. 
