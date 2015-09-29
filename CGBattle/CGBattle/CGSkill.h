//
//  CGSkill.h
//  CGBattle
//
//  Created by Samuel on 9/20/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CG.h"

typedef NS_OPTIONS(NSUInteger, CGSkillTargetAvailable) {
    CGSkillTargetAvailableSelf      = 1 << 0,
    CGSkillTargetAvailableFriend    = 1 << 1,
    CGSkillTargetAvailableEnemy     = 1 << 2,
};

typedef NS_OPTIONS(NSUInteger, CGSkillEffectArea) {
    CGSkillEffect1      = 1 << 0,
    CGSkillEffect4      = 1 << 1,
    CGSkillEffectAll    = 1 << 2,
};

typedef NS_ENUM(NSUInteger, CGSkillID) {
    CGSkillIdMeleeNormal = 0, // 普通攻击
    CGSkillIdMeleeHitBackNormal, // 反击
    CGSkillIdMeleeQiankun, // 乾坤
    CGSkillIdMeleeZhuren, // 诸刃
    CGSkillIdMeleeLianji, // 连击
    
#warning add more
};

typedef NS_ENUM(NSUInteger, CGSkillBuffType) {
    CGSkillBuffUnknown,
    CGSkillBuffAtk, //
    CGSkillBuffDef,
    CGSkillBuffAgi,
    CGSkillBuffRep,
    CGSkillBuffSpr,
    
    CGSkillBuffHp, // 相当于回复血量
    CGSkillBuffMp,
    
    CGSkillBuffMeleeHitRat, // 攻击命中率
    
};

typedef NS_ENUM(NSUInteger, CGBuffTargetType) {
    CGSkillBuffTargetScr, // buff 是释放在自己身上的
    CGSkillBuffTargetDes, // 目标身上
};

// 增益或损害参数, var = var * k + a
@interface CGSkillBuffParam : NSObject
@property (nonatomic, assign) CGSkillBuffType t;
@property (nonatomic, assign) CGBuffTargetType tarType;
@property (nonatomic, assign) float a;
@property (nonatomic, assign) float k;
@property (nonatomic, assign) int duration;// 持续回合
@end

@class CGUnit;

// 技能
@interface CGSkill : NSObject

@property (nonatomic, assign, readonly) CGSkillID SID;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) CGSkillTargetAvailable menualTargetAvailable; // 可以选择的目标
@property (nonatomic, assign) CGSkillTargetAvailable targetAvailable; // 可以选择的目标
@property (nonatomic, assign) CGSkillEffectArea effArea;
@property (nonatomic, assign) float duration; // 持续回合

@property (nonatomic, strong) NSMutableArray *buffParams; // 战斗和魔法技能影响
@property (nonatomic, assign) float hitRate; // 技能命中率, 默认1成功, 例如驱散技能, 不是每次都成功
@property (nonatomic, assign) int level; // 等级

+ (CGSkill *)skillWithSID:(CGSkillID)SID;
- (CGSkill *)initWithSID:(CGSkillID)SID;

- (NSArray *)castBySrc:(CGUnit *)src
                 toDes:(CGUnit *)des;




- (BOOL)canDoMeleeDamageBySrc:(CGUnit *)src
                        toDes:(CGUnit *)des;

- (NSArray *)doMeleeFailedDamageBySrc:(CGUnit *)src
                                toDes:(CGUnit *)des
                               damage:(int)damage;


- (BOOL)canDoMagicDamageBySrc:(CGUnit *)src
                        toDes:(CGUnit *)des;

- (NSArray *)doMagicFailedDamageBySrc:(CGUnit *)src
                                toDes:(CGUnit *)des
                               damage:(int)damage;

# pragma mark -

// 是否命中
- (BOOL)isHitSrc:(CGUnit *)src
             des:(CGUnit *)des;

// 伤害系数 90%~110%
- (float)damageK;

// 是否可以反击
- (BOOL)hasHitBack:(CGUnit *)util;

// 反击是否触发概率
- (BOOL)isHitBackTrigger:(CGUnit *)src;

- (int)damageByAtk:(int)atk
               def:(int)def
                 k:(float)k;

@end



