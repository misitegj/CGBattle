//
//  CGBattleUnit.m
//  CGBattle
//
//  Created by Samuel on 9/20/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import "CGUnit.h"
#import "CGSkill.h"
#import "CGWorld.h"
#import "CGAction.h"
#import "CGBattleLog.h"

@implementation CGUnit

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.buffs = [NSMutableArray array];

        self.isActioned = NO;
        self.location = -1;
        self.isAlive = YES;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    CGUnit *u = [[[self class] allocWithZone:zone] init];
    u.UID = self.UID;
    u.originName = self.originName;
    u.name = self.name;
    u.charm = self.charm;
    u.canControl = self.canControl;
    u.kind = self.kind;
    u.hurt = self.hurt;
    u.soul = self.soul;
    u.Lv = self.Lv;
    u.hp = self.hp;
    u.mp = self.mp;
    u.atk = self.atk;
    u.def = self.def;
    u.agi = self.agi;
    u.rep = self.rep;
    u.spr = self.spr;
    u.crystal = self.crystal;
    u.skills = [self.skills mutableCopy];
    u.skillColumnCount = self.skillColumnCount;
    u.bpRemain = self.bpRemain;
    u.bpHp = self.bpHp;
    u.bpMp = self.bpMp;
    u.bpStr = self.bpStr;
    u.bpDef = self.bpDef;
    u.bpAgi = self.bpAgi;
    u.rstPosion = self.rstPosion;
    u.rstRock = self.rstRock;
    u.rstDrunk = self.rstDrunk;
    u.rstSleepy = self.rstSleepy;
    u.rstConfuse = self.rstConfuse;
    u.rstForget = self.rstForget;
    u.crtCritical = self.crtCritical;
    u.crtAccurate = self.crtAccurate;
    u.crtHitBack = self.crtHitBack;
    u.crtDodge = self.crtDodge;
    u.pdDex = self.pdDex;
    u.pdSta = self.pdSta;
    u.pdWis = self.pdWis;

    u.equipAcc0 = self.equipAcc0;
    u.equipAcc1 = self.equipAcc1;
    u.equipWeapon = self.equipWeapon;
    u.equipWeaponAss = self.equipWeaponAss;
    u.equipClothes = self.equipClothes;
    u.equipShoes = self.equipShoes;
    u.equipClothes = self.equipClothes;
    u.equipCrystal = self.equipCrystal;

    u.isActioned = self.isActioned;
    u.team = self.team;
    u.buffs = [self.buffs mutableCopy];
    u.location = self.location;
    u.isAlive = self.isAlive;
    
    return u;
}


- (CGAction *)selectSkillAndTarget:(CGWorld *)world
{
    return [self randomSkillAndTarget:world];
}



- (NSArray *)doAction:(CGAction *)action
                world:(CGWorld *)world
{
    CGUnit *src = action.src;
    CGUnit *des = action.des;
    CGSkill *sk = [CGSkill skillWithSID:action.skillID];
    
    if (!des.isAlive || des==nil) {
        CGSkillTargetAvailable ava = [CGSkill skillWithSID:sk.SID].targetAvailable;
        des = [src randomTarget:world targetAvailable:ava];
    }
    
    if (!src || !des) {
        self.isActioned = YES;
        return @[];
    }
    
    NSArray *logs = [sk castBySrc:src toDes:des];
    self.isActioned = YES;
    action.logs = logs;
    
    return logs;
}


- (CGAction *)randomSkillAndTarget:(CGWorld *)world
{
    CGSkill *sk = [self randomSkill:world];
    CGUnit *tar = [self randomTarget:world targetAvailable:sk.targetAvailable];
    
    if (!tar) {
        return 0;
    }
    
    CGAction *a = [[CGAction alloc] init];
    a.src = self;
    a.srcLoc = self.location;
    a.skillID = sk.SID;
    a.des = tar;
    a.desLoc = tar.location;
    
    return a;
}

- (CGSkill *)randomSkill:(CGWorld *)world
{
#warning TODO select skill
    if ([self.skills count] > 0) {
        return [self.skills objectAtIndex:0];
    }
    
    return [CGSkill skillWithSID:CGSkillIdMeleeNormal];
}

- (CGUnit *)randomTarget:(CGWorld *)world
               targetAvailable:(CGSkillTargetAvailable)ava
{
    assert([world.aliveSet count]>0);
    
    NSMutableSet *set = [world.aliveSet mutableCopy];
    
    do {
        CGUnit *unit = [set anyObject];
        
        if (unit.isAlive && [self canTarget:unit targetAvailable:ava]) {
            return unit;
        }
        [set removeObject:unit];
        
    }while ([set count]>0) ;
    
    assert(0);
    return nil;
}

- (BOOL)canTarget:(CGUnit *)des
  targetAvailable:(CGSkillTargetAvailable)ava
{
    if (self == des) {
        if (ava & CGSkillTargetAvailableSelf) {
            return YES;
        }
    }
    else{
        if (ava & CGSkillTargetAvailableFriend) {
            if (self.team == des.team) {
                return YES;
            }
        }
        if (ava & CGSkillTargetAvailableEnemy) {
            if (self.team != des.team) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)canMeleeHitBack
{
    return YES;
}

@end



@implementation CGPet

@end


