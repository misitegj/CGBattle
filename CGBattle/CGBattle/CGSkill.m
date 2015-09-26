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
#import "CGWorld.h"

@implementation CGSkillBuffParam

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


@interface CGSkill() {

}

- (CGSkill *)initWithSID:(CGSkillID)SID;

// 是否命中
- (BOOL)isHitSrc:(CGBattleUnit *)src
             des:(CGBattleUnit *)des;

// 伤害系数 90%~110%
- (float)damageK;

// 是否可以反击
- (BOOL)hasHitBack:(CGBattleUnit *)util;

// 反击是否触发概率
- (BOOL)isHitBackTrigger:(CGBattleUnit *)src;

@end

@implementation CGSkill

+ (CGSkill *)skillWithSID:(CGSkillID)SID
{
    if (SID == CGSkillIdMeleeHitBackNormal) {
        return [CGSkillMeleeHitBackNormal new];
    }
    else if (SID == CGSkillIdMeleeQiankun) {
        return [CGSkillMeleeQianKun new];
    }
    else if (SID == CGSkillIdMeleeZhuren) {
        
    }
    else if (SID == CGSkillIdMeleeLianji) {
        
    }
    
    return [CGSkillMeleeNormal new];
}


- (CGSkill *)initWithSID:(CGSkillID)SID
{
    self = [super init];
    if (self) {
        _SID = SID;
        _duration = 1;
        _hitRate = 1;
        _level = 1;
    }
    
    return self;
}

- (NSArray *)castBySrc:(CGBattleUnit *)src
                 toDes:(CGBattleUnit *)des
{
    assert(0); // 子类实现
    
    return @[];
}

# pragma mark -

- (BOOL)canDoMeleeDamageBySrc:(CGBattleUnit *)src
                        toDes:(CGBattleUnit *)des
{
    for (id b in des.buffs) {
#warning TODO  无效或反弹
    }
    
    return YES;
}

- (NSArray *)doMeleeFailedDamageBySrc:(CGBattleUnit *)src
                                toDes:(CGBattleUnit *)des
                               damage:(int)damage
{
    CGSkillID SID = CGSkillIdMeleeNormal;
    for (id b in des.buffs) {
#warning TODO  无效或反弹
    }
    
    return @[];
}


- (BOOL)canDoMagicDamageBySrc:(CGBattleUnit *)src
                        toDes:(CGBattleUnit *)des
{
    for (id b in des.buffs) {
#warning TODO  无效或反弹
    }
    
    return YES;
}

- (NSArray *)doMagicFailedDamageBySrc:(CGBattleUnit *)src
                                toDes:(CGBattleUnit *)des
                               damage:(int)damage
{
    CGSkillID SID = CGSkillIdMeleeNormal;
    for (id b in des.buffs) {
#warning TODO  无效或反弹
    }
    
    return @[];
}


# pragma mark -

// 是否命中
- (BOOL)isHitSrc:(CGBattleUnit *)src
             des:(CGBattleUnit *)des
{
#warning TODO 缺命中率公式
    return CGJudgeRandom1to100(90);
}

// 伤害系数 90%~110%
- (float)damageK
{
    return (CGRandom(20) + 90) / 100.f;
}

// 是否可以反击
- (BOOL)hasHitBack:(CGBattleUnit *)util
{
    return [util canMeleeHitBack] && [self isHitBackTrigger:util];
}

// 反击是否触发概率
- (BOOL)isHitBackTrigger:(CGBattleUnit *)src
{
#warning TODO 缺反击触发概率
    return CGJudgeRandom1to100(30);
}



- (int)damageByAtk:(int)atk
               def:(int)def
                 k:(float)k
{
    int damage = (atk - def) * k;
    damage = MAX(1, damage);

    return damage;
}

@end


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


- (NSArray *)castBySrc:(CGBattleUnit *)src
                 toDes:(CGBattleUnit *)des
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


- (NSArray *)_castBySrc:(CGBattleUnit *)src
                  toDes:(CGBattleUnit *)des
{
    // A 攻击 B
    NSMutableArray *logs = [NSMutableArray array];
    
    BOOL isHit = [self isHitSrc:src des:des];
    
    if (isHit) {
        // hit
        int damage = [self damageByAtk:src.atk def:des.def k:[self damageK]];
        
        if ([self canDoMeleeDamageBySrc:src toDes:des]) {
            NSArray *l = [self doMeleeDamageBySrc:src toDes:des damage:damage];
            [logs addObjectsFromArray:l];
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

- (NSArray *)doMeleeDamageBySrc:(CGBattleUnit *)src
                          toDes:(CGBattleUnit *)des
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

- (NSArray *)castBySrc:(CGBattleUnit *)src
                 toDes:(CGBattleUnit *)des
{
    NSMutableArray *logs = [NSMutableArray array];
    
    NSArray *l = [self _castBySrc:src toDes:des];
    [logs addObjectsFromArray:l];
    
    if (des.isAlive && [self hasHitBack:des]) {
        CGSkill *sk = [CGSkill skillWithSID:CGSkillIdMeleeHitBackNormal];
        NSArray *l = [sk castBySrc:des toDes:src];
        [logs addObjectsFromArray:l];
    }
    
    return logs;
}


- (NSArray *)_castBySrc:(CGBattleUnit *)src
                  toDes:(CGBattleUnit *)des
{
    // A 攻击 B
    NSMutableArray *logs = [NSMutableArray array];
    
    BOOL isHit = [self isHitSrc:src des:des];
    
    if (isHit) {
        // hit
        int damage = [self damageByAtk:src.atk def:des.def k:[self damageK]];
        
        if ([self canDoMeleeDamageBySrc:src toDes:des]) {
            NSArray *l = [self doMeleeDamageBySrc:src toDes:des damage:damage];
            [logs addObjectsFromArray:l];
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

- (NSArray *)doMeleeDamageBySrc:(CGBattleUnit *)src
                          toDes:(CGBattleUnit *)des
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

- (BOOL)isHitSrc:(CGBattleUnit *)src
             des:(CGBattleUnit *)des
{
#warning TODO 缺命中率公式
    return CGJudgeRandom1to100(90);
}

@end


@implementation CGSkillMeleeQianKun

- (instancetype)init
{
    self = [super initWithSID:CGSkillIdMeleeQiankun];
    if (self) {
        self.targetAvailable = CGSkillTargetAvailableEnemy;
        self.menualTargetAvailable = CGSkillTargetAvailableEnemy | CGSkillTargetAvailableFriend;
        self.effArea = CGSkillEffect1;
        self.name = @"乾坤一击";
        
        CGSkillBuffParam *p1 = [[CGSkillBuffParam alloc] init];
        p1.t = CGSkillBuffAtk;
        p1.a = 0;
        p1.k = 1.5;
        
        CGSkillBuffParam *p2 = [[CGSkillBuffParam alloc] init];
        p2.t = CGSkillBuffMeleeHitRat;
        p2.a = 0;
        p2.k = 0.8;
        
        self.buffParams = [NSMutableArray arrayWithObjects:p1, p2, nil];
        
    }
    return self;
}

- (float)damageK
{
    CGSkillBuffParam *atkParam = nil;
    for (CGSkillBuffParam *p in self.buffParams) {
        if (p.t == CGSkillBuffAtk) {
            atkParam = p;
            break;
        }
    }
    return (CGRandom(20) + 90) / 100.f * atkParam.k + atkParam.t;
}

- (BOOL)isHitSrc:(CGBattleUnit *)src
             des:(CGBattleUnit *)des
{
#warning TODO 缺命中率公式
    CGSkillBuffParam *atkParam = nil;
    for (CGSkillBuffParam *p in self.buffParams) {
        if (p.t == CGSkillBuffMeleeHitRat) {
            atkParam = p;
            break;
        }
    }
    
    return CGJudgeRandom1to100((int)(90*atkParam.k));
}

@end


