#include "..\..\script_component.hpp"
FIX_LINE_NUMBERS()

private _rebelFactories = [];

// for loop to check all the factories
for "_i" from 0 to (count (factories)) do {
	_factory = factories select _i;
	if (sidesX getVariable [_factory, sideUnknown] == teamPlayer) then {
		_rebelFactories pushBack _factory;
	};
};

// return the number of factories the rebels own
_rebelFactories




