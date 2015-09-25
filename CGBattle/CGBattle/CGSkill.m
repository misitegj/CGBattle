//
//  CGSkill.m
//  CGBattle
//
//  Created by Samuel on 9/20/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import "CGSkill.h"
#import "CGBattleUnit.h"
#import "CGBattleLog.h"

@implementation CGSkillBuff

- (id)init
{
    self = [super init];
    
    if (self) {
        _a = 0;
        _k = 1;
        _t = CGSkillBuffUnknown;
    }
    
    return self;
}

@end


@interface CGSkill()
- (CGSkill *)initWithSID:(CGSkillID)SID;
@end

@implementation CGSkill

+ (CGSkill *)skillWithSID:(CGSkillID)SID
{
#warning TODO new skills
    if (SID == CGSkillIdMeleeHitBackNormal) {
        return [CGSkill skillMeleeHitBackNormal];
    }
    else if (SID == CGSkillIdMeleeQiankun) {
        
    }
    else if (SID == CGSkillIdMeleeZhuren) {
        
    }
    else if (SID == CGSkillIdMeleeLianji) {
        
    }
    
    return [CGSkill skillMeleeNormal];
}

// 普通物理攻击
+ (CGSkill *)skillMeleeNormal
{
    CGSkill *sk = [[CGSkill alloc] initWithSID:CGSkillIdMeleeNormal];
#warning AI 不会攻击友方, 如果手动的话 可以
    sk.targetAvailable = CGSkillTargetAvailableEnemy;
    sk.effArea = CGSkillEffect1;
    sk.name = @"普通攻击";
    return sk;
}

+ (CGSkill *)skillMeleeHitBackNormal
{
    CGSkill *sk = [[CGSkill alloc] initWithSID:CGSkillIdMeleeHitBackNormal];
    sk.targetAvailable = CGSkillTargetAvailableFriend | CGSkillTargetAvailableEnemy; // 反击可能反击友方
    sk.effArea = CGSkillEffect1;
    sk.name = @"反击";
    
    return sk;
}

- (CGSkill *)initWithSID:(CGSkillID)SID
{
    self = [super init];
    if (self) {
        _SID = SID;
        _duration = 1;
        _hitRate = 1;
    }
    
    return self;
}

@end


@implementation CGSkill(BattleLog)

- (NSMutableArray *)battleLogsWithUnits:(NSMutableSet *)aliveSet
                                   src:(CGBattleUnit *)src
                                   des:(CGBattleUnit *)des
{
    return [self battleLogsWithUnits:aliveSet srcLoc:src.location desLoc:des.location];
}

- (NSMutableArray *)battleLogsWithUnits:(NSMutableSet *)aliveSet
                                srcLoc:(int)srcLoc
                                desLoc:(int)desLoc
{
    
    // 普通攻击, 其他子类自己实现
    assert(_SID == CGSkillIdMeleeNormal || _SID == CGSkillIdMeleeHitBackNormal);
    
    CGBattleUnit *originSrc = [self searchObject:aliveSet byLocation:srcLoc];
    CGBattleUnit *originDes = [self searchObject:aliveSet byLocation:desLoc];
    
    
    CGBattleUnit *src = originSrc;
    CGBattleUnit *des = originDes;
    
    NSMutableArray *logs = [NSMutableArray array];
    
    if (src==nil) {
        assert(0);
        return logs;
    }
    
    if (!des.isAlive || des==nil) {
        des = randomTarget(src, aliveSet, self.targetAvailable);
    }
    
    assert(des);
    
    // 攻击
    BOOL isHitBack = NO;
    CGBattleMeleeLog *log = nil;
    
    do {
        BOOL isHit = [self isHitSrc:src des:des];
        
        if (isHit) {
            CGSkillID SID = isHitBack ? CGSkillIdMeleeHitBackNormal : CGSkillIdMeleeNormal;
            float k = isHitBack ? [self damageHitBackK] : [self damageK];
            int value = (src.atk - des.def) * k;
            value = MAX(1, value);
            NSMutableArray *deses = [NSMutableArray arrayWithObject:des];
            log = [[CGBattleMeleeLog alloc] initWithSID:SID
                                                    src:src
                                                  deses:deses
                                                  value:value];
            [logs addObject:log];
            
            des.hp -= value;
            if (des.hp <= 0) {// 是否死亡
                des.hp = 0;
                des.isAlive = NO;
                
                CGBattleDeadLog *log = [[CGBattleDeadLog alloc] initWithSrc:des];
                [logs addObject:log];
                
                if (isHitBack) {
                    
                }
                break;
            }
            
            CGBattleUnit *tmp = des;
            des = src;
            src = tmp;
            isHitBack = YES;
        }
        else {
            // miss 没有伤害值
            CGSkillID SID = isHitBack ? CGSkillIdMeleeHitBackNormal : CGSkillIdMeleeNormal;

            CGBattleMeleeMissLog *log = [[CGBattleMeleeMissLog alloc] initWithSID:SID src:src deses:[NSMutableArray arrayWithObject:des]];
            [logs addObject:log];
            break;
        }
    }while ([self hasHitBackSrc:src des:des]); // 是否有反击
    
    originSrc.isActioned = YES;
    
    return logs;
}

- (BOOL)isHitSrc:(CGBattleUnit *)src
             des:(CGBattleUnit *)des
{
#warning TODO
    return CGJudgeRandom1to100(90);
}

- (BOOL)hasHitBackSrc:(CGBattleUnit *)src
                  des:(CGBattleUnit *)des
{
#warning TODO
    return CGJudgeRandom1to100(50);
}

// 伤害系数
- (float)damageK
{// 90%~110%
    return (CGRandom(20) + 90) / 100.f;
}

- (float)damageHitBackK
{// 40%~60%
    return (CGRandom(20) + 40) / 100.f;
}


- (CGBattleUnit *)searchObject:(NSMutableSet *)units
                      byLocation:(int)loc

{
    for (CGBattleUnit *unit in units) {
        if (unit.location == loc) {
            return unit;
        }
    }
    
    return nil;
}

@end


