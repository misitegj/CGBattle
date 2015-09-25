//
//  CGBattleObject.m
//  CGBattle
//
//  Created by Samuel on 9/20/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import "CGBattleObject.h"
#import "CGSkill.h"

@implementation CGBattleObject

- (instancetype)initWithCGObject:(CGObject *)obj
{
    self = [super init];
    if (self) {
        _origin = obj;
        self.isActioned = NO;
        self.belong = obj.belong;
        self.buffs = [NSMutableArray array];
        self.debuffs = [NSMutableArray array];
        self.Lv = obj.Lv;
        self.hp = obj.hp;
        self.mp = obj.mp;
        
        self.atk = obj.atk;
        self.def = obj.def;
        self.agi = obj.agi;
        self.rep = obj.rep;
        self.spr = obj.spr;
        
        self.crystal = obj.crystal;
        self.kind = obj.kind;
        self.skills = obj.skills;
        
        self.rstPosion = obj.rstPosion;
        self.rstRock = obj.rstRock;
        self.rstDrunk = obj.rstDrunk;
        self.rstSleepy = obj.rstSleepy;
        self.rstConfuse = obj.rstConfuse;
        self.rstForget = obj.rstForget;
        
        self.crtCritical = obj.crtCritical;
        self.crtAccurate = obj.crtAccurate;
        self.crtHitBack = obj.crtHitBack;
        self.crtDodge = obj.crtDodge;
        
        self.location = -1;
        self.actionOrder = -1;
        self.isAlive = YES;
        
        self.actionTargetLocation = -1;
        self.actionSkillID = -1;
        
    }
    
    return self;
}


#warning TODO ai 优化

- (void)AI_calcTargetsWithObjs:(NSMutableSet *)set
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
    
    CGBattleObject *r = randomTarget(self, set, sk.targetAvailable);
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
- (NSMutableArray *)AI_actionLogsWithObjs:(NSMutableSet *)aliveSet
{
    NSMutableArray *logs = [NSMutableArray array];
    [logs addObjectsFromArray:[self _actionLogsBeginWithObjs:aliveSet]];
    [logs addObjectsFromArray:[self _actionLogsActionWithObjs:aliveSet]];
    [logs addObjectsFromArray:[self _actionLogsEndWithObjs:aliveSet]];
    
    return logs;
}

- (NSMutableArray *)_actionLogsBeginWithObjs:(NSMutableSet *)aliveSet
{
    return [NSMutableArray array];
}

- (NSMutableArray *)_actionLogsActionWithObjs:(NSMutableSet *)aliveSet
{
    CGSkill *sk = [CGSkill skillWithSID:self.actionSkillID];
    
    return [sk battleLogsWithObjs:aliveSet srcLoc:self.location desLoc:self.actionTargetLocation];
}

- (NSMutableArray *)_actionLogsEndWithObjs:(NSMutableSet *)aliveSet
{
    return [NSMutableArray array];
}



@end


BOOL canTarget(CGBattleObject *src, CGBattleObject *des, CGSkillTargetAvailable tarAva)
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



CGBattleObject* randomTarget(CGBattleObject *src, id objs, CGSkillTargetAvailable skTarAva)
{
    assert([objs count]>0);
    
    NSMutableSet *set = nil;
    
    if ([objs isKindOfClass:[NSSet class]]) {
        set = [objs mutableCopy];
    }
    if ([objs isKindOfClass:[NSArray class]]) {
        set = [NSMutableSet setWithArray:objs];
    }
    
    do {
        CGBattleObject *obj = [set anyObject];

        if (obj.isAlive && canTarget(src, obj, skTarAva)) {
            return obj;
        }
        [set removeObject:obj];
        
    }while ([set count]>0) ;
    
    assert(0);
    return nil;
}