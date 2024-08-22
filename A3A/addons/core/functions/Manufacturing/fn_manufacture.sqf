private ["_rebelFactories"];
_rebelFactories = call A3A_fnc_countTiles;

// Define gear to be manufactured
private _gear = [
	"srifle_DMR_03_khaki_F",
	"srifle_DMR_03_tan_F"
];

for "_i" from 0 to (count _gear) do {
	_item = _gear select _i;
	_arsenalTab = _item call jn_fnc_arsenal_itemType;
	[_arsenalTab,_item,_rebelFactories] call jn_fnc_arsenal_addItem;
};

private _arsenalTab = "classname_here" call jn_fnc_arsenal_itemType; 
[_arsenalTab,"classname_here",count _rebelFactories] call jn_fnc_arsenal_addItem;