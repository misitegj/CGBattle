//
//  CGSkillMeleeNormal.m
//  CGBattle
//
//  Created by Samuel on 9/27/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import "CGSkillMeleeNormal.h"
#import "CGUnit.h"
#import "CGBattleLog.h"
#import "CGWorld.h"

# pragma mark - 普通攻击

@implementation CGSkillMeleeNormal

- (instancetype)init
{
    self = [super initWithSID:CGSkillIdMeleeNormal];
    if (self) {
        self.targetAvailable = CGSkillTargetAvailableEnemy;
        self.menualTargetAvailable = CGSkillTargetAvailableEnemy | CGSkillTargetAvailableFriend;
        self.effArea = CGSkillEffect1;
        self.name = @"普通攻击";
    }
    return self;
}


- (NSArray *)castBySrc:(CGUnit *)src
                 toDes:(CGUnit *)des
{
    NSMutableArray *logs = [NSMutableArray array];
    
    NSArray *l = [self _castBySrc:src toDes:des];
    [logs addObjectsFromArray:l];
    
    // 是否有反击
    if (des.isAlive && [self hasHitBack:des]) {
        CGSkill *sk = [CGSkill skillWithSID:CGSkillIdMeleeHitBackNormal];
        NSArray *l = [sk castBySrc:des toDes:src];
        [logs addObjectsFromArray:l];
    }
    
    return logs;
}


- (NSArray *)_castBySrc:(CGUnit *)src
                  toDes:(CGUnit *)des
{
    // A 攻击 B
    NSMutableArray *logs = [NSMutableArray array];
    
    BOOL isHit = [self isHitSrc:src des:des];
    
    // 是否命中
    if (isHit) {
        // 释放技能前 添加自身buff判断
        [self addBuffsToUnit:src tarType:CGSkillBuffTargetScr];
        
        int damage = [self damageByAtk:src.battleAtk def:des.battleDef k:[self damageK]];
        
        if ([self canDoMeleeDamageBySrc:src toDes:des]) {
            NSArray *l = [self doMeleeDamageBySrc:src toDes:des damage:damage];
            [logs addObjectsFromArray:l];
            
            // 释放技能后 添加敌人buff判断
            [self addBuffsToUnit:des tarType:CGSkillBuffTargetDes];
        }
        else {
            // 反弹或无效
            NSArray *l = [self doMeleeFailedDamageBySrc:src toDes:des damage:damage];
            [logs addObjectsFromArray:l];
        }
    }
    else {
        // miss
        CGBattleMeleeMissLog *log = [[CGBattleMeleeMissLog alloc] initWithSID:self.SID
                                                                          src:src
                                                                        deses:@[des]];
        [logs addObject:log];
    }
    return logs;
}



- (void)addBuffsToUnit:(CGUnit *)unit
               tarType:(CGBuffTargetType)type
{
    if ([self.buffParams count] == 0) {
        return;
    }
    
    for (CGSkillBuffParam *p in self.buffParams) {
        if (p.tarType == type) {
            [unit addBuffParam:p];
        }
    }
}

- (NSArray *)doMeleeDamageBySrc:(CGUnit *)src
                          toDes:(CGUnit *)des
                         damage:(int)damage
{
    NSMutableArray *logs = [NSMutableArray array];
    
    // 攻击
    CGBattleMeleeLog *log = [[CGBattleMeleeLog alloc] initWithSID:self.SID
                                                              src:src
                                                            deses:@[des]
                                                            value:damage];
    [logs addObject:log];
    
    des.hp -= damage;
    des.hp = MAX(des.hp, 0);
    des.isAlive = des.hp > 0;
    
    if (!des.isAlive) {
        // 死亡
        CGBattleDeadLog *log = [[CGBattleDeadLog alloc] initWithSrc:des];
        [logs addObject:log];
    }
    
    return logs;
}

@end
