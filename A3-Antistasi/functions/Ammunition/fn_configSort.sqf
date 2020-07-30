params [["_filter", {true}]];

////////////////////////////////////
//  ITEM/WEAPON CLASSIFICATION   ///
////////////////////////////////////
//Ignore type 65536, we don't want Vehicle Weapons.
private _allWeaponConfigs = "
	getNumber (_x >> 'scope') == 2
	&&
	getNumber (_x >> 'type') != 65536
" configClasses (configFile >> "CfgWeapons");

//Ignore anything with type 0. They're generally vehicle magazines.
//Type 16 is generally throwables, type 256 or above normal magazines.
private _allMagazineConfigs = "
	getNumber (_x >> 'scope') == 2
	&&
	getNumber (_x >> 'type') > 0
" configClasses (configFile >> "CfgMagazines");

private _allBackpackConfigs = "
	getNumber ( _x >> 'scope' ) isEqualTo 2
	&&
	{ getText ( _x >> 'vehicleClass' ) isEqualTo 'Backpacks' }
" configClasses ( configFile >> "CfgVehicles" );

private _allStaticWeaponConfigs = "
	getNumber ( _x >> 'scope' ) isEqualTo 2
	&&
	{ getText ( _x >> 'vehicleClass' ) isEqualTo 'StaticWeapon' }
" configClasses ( configFile >> "CfgVehicles" );

private _allGlassesConfigs = "
	( getNumber ( _x >> 'scope' ) isEqualTo 2 )
" configClasses ( configFile >> "CfgGlasses" );

private _allConfigs = _allWeaponConfigs + _allMagazineConfigs + _allBackpackConfigs + _allStaticWeaponConfigs + _allGlassesConfigs;

////////////////////////////////////////////////////
//    Filter out content from disabled mods.     ///
////////////////////////////////////////////////////
_allConfigs = _allConfigs select {!(_x call A3A_fnc_getModOfConfigClass in disabledMods)};

//////////////////////////////
//   Faction sorting        //
//////////////////////////////

//Check if the data is defined in the templates, currently only vanilla
private _fileName = "configSort";
private _sideSortingActive = true;
if(isNil "rebelWeaponWells" || {isNil 'occupantWeaponWells' || {isNil 'invaderWeaponWells'}}) then
{
    [1, "At least one of the active templates dont have weapon wells defined, cannot sort weapons by side", _fileName] call A3A_fnc_log;
    _sideSortingActive = false;
};

if(rebelWeaponWells isEqualTo [] || occupantWeaponWells isEqualTo [] || invaderWeaponWells isEqualTo []) then
{
    [1, "At least on of the active templates has an empty array for weapon wells, cannot sort weapons by side", _fileName] call A3A_fnc_log;
    _sideSortingActive = false;
};

private _mags = [];
if(_sideSortingActive) then
{
    [3, "Preparing data for weapon side detection", _fileName] call A3A_fnc_log;
    //Prepare data used for mag well detection
    private _magWells = ("true" configClasses (configFile >> "CfgMagazineWells")) apply {configName _x};

    {
        _mags pushBack [_x, (getArray(configfile >> "CfgMagazineWells" >> _x >> "BI_Magazines") + getArray(configfile >> "CfgMagazineWells" >> _x >> "BI_Enoch_Magazines"))];
    } forEach _magWells;
    missionNamespace setVariable ["weaponMags", _mags];
    [3, format ["Found %1 mag wells in the config", count _magWells], _fileName] call A3A_fnc_log;
};

//////////////////////////////
//    Sorting Function     ///
//////////////////////////////
private _checkedItems = [];
private _nameX = "";
{
	_nameX = configName _x;
	if (isClass (configFile >> "CfgWeapons" >> _nameX)) then
	{
		_nameX = [_nameX] call BIS_fnc_baseWeapon;
	};
    if !(_nameX in _checkedItems) then
    {
        _checkedItems pushBack _nameX;
        private _item = [_nameX] call A3A_fnc_itemType;
    	private _itemType = _item select 1;

    	if !([_x, _item] call _filter) then
    	{
    		private _categories = _nameX call A3A_fnc_equipmentClassToCategories;
    		{
    			//We're not returning a default value with getVariable, becuase it *must* be instantiated before now. If it isn't, we *need* it to error.
    			private _categoryName = _x;
    			(missionNamespace getVariable ("all" + _categoryName)) pushBackUnique _nameX;
                //Sort by weapon side
                if(_sideSortingActive && {_categoryName in weaponCategories}) then
                {
                    private _sides = [_nameX] call A3A_fnc_weaponSide;
                    {
                        (missionNamespace getVariable (_x + _categoryName)) pushBackUnique _nameX;
                    } forEach _sides;
                };
    		} forEach _categories;
    	};
    };
} forEach _allConfigs;

if(_sideSortingActive) then
{
    {
        private _arrayNames = _x;
        {
            [_x, weaponCategories select _forEachIndex] call A3A_fnc_sortWeaponArrays;
            [3, format ["Sorted %1 to %2", _x, (missionNamespace getVariable _x) apply {getText (configFile >> "CfgWeapons" >> _x >> "displayName")}], _fileName] call A3A_fnc_log;
        } forEach _arrayNames;
    } forEach [rebelWeaponsArrayNames, occupantWeaponsArrayNames, invaderWeaponsArrayNames];
    weaponsSortedBySide = true;
    publicVariable "weaponsSortedBySide";
}
else
{
    weaponsSortedBySide = false;
    publicVariable "weaponsSortedBySide";
};
