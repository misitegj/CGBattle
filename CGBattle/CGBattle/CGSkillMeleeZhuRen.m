//
//  CGSkillMeleeZhuRen.m
//  CGBattle
//
//  Created by Samuel on 9/29/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import "CGSkillMeleeZhuRen.h"
#import "CGUnit.h"
#import "CGBattleLog.h"
#import "CGWorld.h"

@implementation CGSkillMeleeZhuRen

- (instancetype)init
{
    self = [super initWithSID:CGSkillIdMeleeQiankun];
    if (self) {
        self.targetAvailable = CGSkillTargetAvailableEnemy;
        self.menualTargetAvailable = CGSkillTargetAvailableEnemy | CGSkillTargetAvailableFriend;
        self.effArea = CGSkillEffect1;
        self.name = @"诸刃";
        
        CGSkillBuffParam *p1 = [[CGSkillBuffParam alloc] init];
        p1.t = CGSkillBuffAtk;
        p1.a = 0;
        p1.k = 1.5;
        p1.duration = 1;
        p1.tarType = CGSkillBuffTargetScr;
        
        CGSkillBuffParam *p2 = [[CGSkillBuffParam alloc] init];
        p2.t = CGSkillBuffMeleeHitRat;
        p2.a = 0;
        p2.k = 0.5;
        p2.duration = 1;
        p1.tarType = CGSkillBuffSpr;
        
        self.buffParams = [NSMutableArray arrayWithObjects:p1, p2, nil];
        
    }
    return self;
}

- (float)damageK
{
    return (CGRandom(20) + 90) / 100.f;
}

- (BOOL)isHitSrc:(CGUnit *)src
             des:(CGUnit *)des
{
    return [self isHitSrc:src des:des];
}

@end
