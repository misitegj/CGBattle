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
    
};

// 增益或损害, var = var * k + a
@interface CGSkillBuff : NSObject
@property (nonatomic, assign) CGSkillBuffType t;
@property (nonatomic, assign) float a;
@property (nonatomic, assign) float k;
@end

// 技能
@interface CGSkill : NSObject

@property (nonatomic, assign, readonly) CGSkillID SID;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) CGSkillTargetAvailable targetAvailable; // 可以选择的目标
@property (nonatomic, assign) CGSkillEffectArea effArea;
@property (nonatomic, assign) float duration; // 持续回合

@property (nonatomic, strong) NSMutableArray *buffs; // 战斗和魔法技能影响
@property (nonatomic, assign) float hitRate; // 技能命中率, 默认1成功, 例如驱散技能, 不是每次都成功

+ (CGSkill *)skillWithSID:(CGSkillID)SID;

@end


@class CGObject, CGBattleObject;

@interface CGSkill(BattleLog)
// 计算战斗日志
- (NSMutableArray *)battleLogsWithObjs:(NSMutableSet *)objs
                                   src:(CGBattleObject *)src
                                   des:(CGBattleObject *)des;

- (NSMutableArray *)battleLogsWithObjs:(NSMutableSet *)objs
                                srcLoc:(int)srcLoc
                                desLoc:(int)desLoc;

@end