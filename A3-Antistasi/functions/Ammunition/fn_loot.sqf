//////////////////
// Basic Items ///
//////////////////
lootBasicItem append allMaps + allToolkits + allWatches + allCompasses + allMedikits + allFirstAidKits;

/////////////////
//    NVG'S   ///
/////////////////
lootNVG append allNVGs;

/////////////////////
// Assigned Items ///
/////////////////////
lootItem append allUAVTerminals + allMineDetectors + allGPS + allRadios + allLaserDesignators + allBinoculars + allLaserBatteries + lootNVG + allGadgets;

////////////////////
//    Weapons    ///
////////////////////
lootWeapon append allRifles + allSniperRifles + allHandguns + allMachineGuns + allMissileLaunchers + allRocketLaunchers + allSMGs + allShotguns;
lootWeapon deleteAt (LootWeapon find "hlc_pistol_DL44");


/////////////////////////////
//   Weapon Attachments   ///
/////////////////////////////
lootAttachment append allBipods + allOptics + allMuzzleAttachments + allPointerAttachments;

////////////////////
//    Grenades   ///
////////////////////
lootGrenade append allGrenades + allMagShell + allIRGrenades + allMagSmokeShell + allMagFlare;

////////////////////
//   Magazines   ///
////////////////////
lootMagazine append allMagBullet + allMagShotgun + allMagMissile + allMagRocket + lootGrenade;
lootMagazine deleteAt (lootMagazine find "hlc_500rnd_762x51_Cinematic");
lootMagazine deleteAt (lootMagazine find "hlc_10Rnd_BLASTER_B_DL44");

///////////////////
//  Explosives  ///
///////////////////
lootExplosive append allMine + allMineDirectional + allMineBounding;

lootExplosive deleteAt (lootExplosive find "APERSMineDispenser_Mag");
lootExplosive deleteAt (lootExplosive find "TrainingMine_Mag");
lootExplosive deleteAt (lootExplosive find "IEDLandSmall_Remote_Mag");
lootExplosive deleteAt (lootExplosive find "IEDUrbanSmall_Remote_Mag");
lootExplosive deleteAt (lootExplosive find "IEDLandBig_Remote_Mag");
lootExplosive deleteAt (lootExplosive find "IEDUrbanBig_Remote_Mag");

///////////////////
//   Backpacks  ///
///////////////////
lootBackpack append allBackpacksEmpty;

/////////////////
//   Helmets  ///
/////////////////
lootHelmet append allArmoredHeadgear;

///////////////
//   Vests  ///
///////////////
lootVest append allArmoredVests + allCivilianVests;

/////////////////////
//   Device Bags  ///
/////////////////////
private _lootDeviceBag = [];

switch (teamPlayer) do {
     case independent: {_lootDeviceBag append rebelBackpackDevice};
     default {_lootDeviceBag append occupantBackpackDevice};
};
lootDevice append _lootDeviceBag + allBackpacksRadio;

////////////////////////////////////
//      REBEL STARTING ITEMS     ///
////////////////////////////////////
//KEEP AT BOTTOM!!!
initialRebelEquipment append lootBasicItem;
initialRebelEquipment append allRebelUniforms;
initialRebelEquipment append allCivilianUniforms;
initialRebelEquipment append allCivilianHeadgear;
initialRebelEquipment append allCivilianGlasses;
