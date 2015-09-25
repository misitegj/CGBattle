//
//  CGBattleUnit.m
//  CGBattle
//
//  Created by Samuel on 9/20/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import "CGBattleUnit.h"
#import "CGSkill.h"

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
        self.actionOrder = -1;
        self.isAlive = YES;
        
        self.actionTargetLocation = -1;
        self.actionSkillID = -1;
        
    }
    
    return self;
}


#warning TODO ai 优化

- (void)AI_calcTargetsWithUnits:(NSMutableSet *)set
{
    assert([set count]>0 && [set containsObject:self]);
    
    // 选择技能
    CGSkillID SID = CGSkillIdMeleeNormal;
    if ([self.skills count] > 0) {
        SID = [[self.skills objectAtIndex:0] integerValue];
    }
    self.actionSkillID = SID;
    
    // 选择目标
    int targetLocaiton = -1;
    CGSkill *sk = [CGSkill skillWithSID:self.actionSkillID];
    
    CGBattleUnit *r = randomTarget(self, set, sk.targetAvailable);
    targetLocaiton = r.location;
    self.actionTargetLocation = targetLocaiton;
    
    assert(targetLocaiton!=-1);
//    NSLog(@"self loc[%d] sk[%ld] tar loc[%d]", self.location, SID, self.actionTargetLocation);
    return;
}


/*
    行动日志
 1, 开始阶段, 判断有buff或debuff
 2, 行动阶段
 3, 结束阶段
 */
- (NSMutableArray *)AI_actionLogsWithUnits:(NSMutableSet *)aliveSet
{
    NSMutableArray *logs = [NSMutableArray array];
    [logs addObjectsFromArray:[self _actionLogsBeginWithUnits:aliveSet]];
    [logs addObjectsFromArray:[self _actionLogsActionWithUnits:aliveSet]];
    [logs addObjectsFromArray:[self _actionLogsEndWithUnits:aliveSet]];
    
    return logs;
}

- (NSMutableArray *)_actionLogsBeginWithUnits:(NSMutableSet *)aliveSet
{
    return [NSMutableArray array];
}

- (NSMutableArray *)_actionLogsActionWithUnits:(NSMutableSet *)aliveSet
{
    CGSkill *sk = [CGSkill skillWithSID:self.actionSkillID];
    
    return [sk battleLogsWithUnits:aliveSet srcLoc:self.location desLoc:self.actionTargetLocation];
}

- (NSMutableArray *)_actionLogsEndWithUnits:(NSMutableSet *)aliveSet
{
    return [NSMutableArray array];
}



@end


BOOL canTarget(CGBattleUnit *src, CGBattleUnit *des, CGSkillTargetAvailable tarAva)
{
    if (src == des) {
        if (tarAva & CGSkillTargetAvailableSelf) {
            return YES;
        }
    }
    else{
        if (tarAva & CGSkillTargetAvailableFriend) {
            if (src.belong == des.belong) {
                return YES;
            }
        }
        if (tarAva & CGSkillTargetAvailableEnemy) {
            if (src.belong != des.belong) {
                return YES;
            }
        }
    }
    
    return NO;
}



CGBattleUnit* randomTarget(CGBattleUnit *src, id units, CGSkillTargetAvailable skTarAva)
{
    assert([units count]>0);
    
    NSMutableSet *set = nil;
    
    if ([units isKindOfClass:[NSSet class]]) {
        set = [units mutableCopy];
    }
    if ([units isKindOfClass:[NSArray class]]) {
        set = [NSMutableSet setWithArray:units];
    }
    
    do {
        CGBattleUnit *unit = [set anyObject];

        if (unit.isAlive && canTarget(src, unit, skTarAva)) {
            return unit;
        }
        [set removeObject:unit];
        
    }while ([set count]>0) ;
    
    assert(0);
    return nil;
}