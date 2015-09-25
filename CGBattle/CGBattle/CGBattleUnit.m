//
//  CGBattleUnit.m
//  CGBattle
//
//  Created by Samuel on 9/20/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import "CGBattleUnit.h"
#import "CGSkill.h"
#import "CGWorld.h"


@implementation CGBattleUnit

- (instancetype)initWithUnit:(CGUnit *)unit
{
    self = [super init];
    if (self) {
        _origin = unit;
        self.isActioned = NO;
        self.belong = unit.belong;
        self.buffs = [NSMutableArray array];
        self.debuffs = [NSMutableArray array];
        self.Lv = unit.Lv;
        self.hp = unit.hp;
        self.mp = unit.mp;
        
        self.atk = unit.atk;
        self.def = unit.def;
        self.agi = unit.agi;
        self.rep = unit.rep;
        self.spr = unit.spr;
        
        self.crystal = unit.crystal;
        self.kind = unit.kind;
        self.skills = unit.skills;
        
        self.rstPosion = unit.rstPosion;
        self.rstRock = unit.rstRock;
        self.rstDrunk = unit.rstDrunk;
        self.rstSleepy = unit.rstSleepy;
        self.rstConfuse = unit.rstConfuse;
        self.rstForget = unit.rstForget;
        
        self.crtCritical = unit.crtCritical;
        self.crtAccurate = unit.crtAccurate;
        self.crtHitBack = unit.crtHitBack;
        self.crtDodge = unit.crtDodge;
        
        self.location = -1;
        self.isAlive = YES;
        
    }
    
    return self;
}




@end



