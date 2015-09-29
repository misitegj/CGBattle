//
//  CGSkill.m
//  CGBattle
//
//  Created by Samuel on 9/20/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import "CGSkill.h"
#import "CGUnit.h"
#import "CGBattleLog.h"
#import "CGWorld.h"
#import "CGSkillMeleeNormal.h"
#import "CGSkillMeleeHitBackNormal.h"
#import "CGSkillMeleeQianKun.h"

@implementation CGSkillBuffParam

- (id)init
{
    self = [super init];
    
    if (self) {
        _a = 0;
        _k = 1;
        _t = CGSkillBuffUnknown;
        _duration = 1;
    }
    
    return self;
}

@end


@interface CGSkill() {

}

- (CGSkill *)initWithSID:(CGSkillID)SID;

// 是否命中
- (BOOL)isHitSrc:(CGUnit *)src
             des:(CGUnit *)des;

// 伤害系数 90%~110%
- (float)damageK;

// 是否可以反击
- (BOOL)hasHitBack:(CGUnit *)util;

// 反击是否触发概率
- (BOOL)isHitBackTrigger:(CGUnit *)src;

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

- (NSArray *)castBySrc:(CGUnit *)src
                 toDes:(CGUnit *)des
{
    assert(0); // 子类实现
    
    return @[];
}

# pragma mark -

- (BOOL)canDoMeleeDamageBySrc:(CGUnit *)src
                        toDes:(CGUnit *)des
{
    for (id b in des.buffs) {
#warning TODO  无效或反弹
    }
    
    return YES;
}

- (NSArray *)doMeleeFailedDamageBySrc:(CGUnit *)src
                                toDes:(CGUnit *)des
                               damage:(int)damage
{
    CGSkillID SID = CGSkillIdMeleeNormal;
    for (id b in des.buffs) {
#warning TODO  无效或反弹
    }
    
    return @[];
}


- (BOOL)canDoMagicDamageBySrc:(CGUnit *)src
                        toDes:(CGUnit *)des
{
    for (id b in des.buffs) {
#warning TODO  无效或反弹
    }
    
    return YES;
}

- (NSArray *)doMagicFailedDamageBySrc:(CGUnit *)src
                                toDes:(CGUnit *)des
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
- (BOOL)isHitSrc:(CGUnit *)src
             des:(CGUnit *)des
{
#warning TODO 缺命中率公式
    
    int hitRate = 90;
    hitRate = [src attributesWithBuffType:CGSkillBuffMeleeHitRat value:hitRate];
    
    return CGJudgeRandom1to100(hitRate);
    
}

// 伤害系数 90%~110%
- (float)damageK
{
    return (CGRandom(20) + 90) / 100.f;
}

// 是否可以反击
- (BOOL)hasHitBack:(CGUnit *)util
{
    return [util canMeleeHitBack] && [self isHitBackTrigger:util];
}

// 反击是否触发概率
- (BOOL)isHitBackTrigger:(CGUnit *)src
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





