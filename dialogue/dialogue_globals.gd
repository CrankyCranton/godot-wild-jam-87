extends Node


enum TreeStates {
	NO_TREE,
	SAW_TREE,
	HAS_AXE,
	CUT_LUMBERJACKS_TREE,
}

var tree_state: TreeStates = TreeStates.NO_TREE
var spoke_to_organist := false
var spoke_to_hag := false
