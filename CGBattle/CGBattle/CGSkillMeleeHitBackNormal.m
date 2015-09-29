//
//  CGSkillMeleeHitBackNormal.m
//  CGBattle
//
//  Created by Samuel on 9/27/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import "CGSkillMeleeHitBackNormal.h"
#import "CGUnit.h"
#import "CGBattleLog.h"
#import "CGWorld.h"

# pragma mark - 反击

@implementation CGSkillMeleeHitBackNormal

- (instancetype)init
{
    self = [super initWithSID:CGSkillIdMeleeHitBackNormal];
    if (self) {
        self.targetAvailable = CGSkillTargetAvailableEnemy;
        self.menualTargetAvailable = CGSkillTargetAvailableEnemy | CGSkillTargetAvailableFriend;
        self.effArea = CGSkillEffect1;
        self.name = @"反击";
    }
    return self;
}

- (NSArray *)doMeleeDamageBySrc:(CGUnit *)src
                          toDes:(CGUnit *)des
                         damage:(int)damage
{
    NSMutableArray *logs = [NSMutableArray array];
    
    // 攻击
    CGBattleMeleeHitBackLog *log = [[CGBattleMeleeHitBackLog alloc] initWithSID:self.SID
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


- (float)damageK
{// 40%~60%
    return (CGRandom(20) + 40) / 100.f;
}

- (BOOL)isHitSrc:(CGUnit *)src
             des:(CGUnit *)des
{
    return [super isHitSrc:src des:des];
}

@end

