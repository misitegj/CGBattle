//
//  CGBattleLog.h
//  CGBattle
//
//  Created by Samuel on 9/20/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGSkill.h"
#import "CGBattleUnit.h"

@interface CGBattleLog : NSObject

@property (nonatomic, assign) CGSkillID SID;

@property (nonatomic, strong) CGBattleUnit *src; // 攻击单位
@property (nonatomic, strong) CGBattleUnit *des; // 
@property (nonatomic, strong) NSArray *deses; // 受作用的所有单位

@property (nonatomic, assign) int value; // 作用的数值
@property (nonatomic, assign) int isHit; // 是否命中

- (NSString *)description;

@end


@interface CGBattleMeleeLog : CGBattleLog

- (id)initWithSID:(CGSkillID)SID
              src:(CGBattleUnit *)src
            deses:(NSArray *)deses
            value:(int)value;

@end

@interface CGBattleMeleeHitBackLog : CGBattleMeleeLog

@end

@interface CGBattleMeleeMissLog : CGBattleLog
- (id)initWithSID:(CGSkillID)SID
              src:(CGBattleUnit *)src
            deses:(NSArray *)deses;
@end

@interface CGBattleDeadLog : CGBattleLog
- (id)initWithSrc:(CGBattleUnit *)src;
@end

@interface CGBattleRoundBeginLog : CGBattleLog
@property (nonatomic, assign) int round;
@end

@interface CGBattleRoundEndLog : CGBattleLog
@property (nonatomic, assign) int round;
@end

@interface CGBattleBeginLog : CGBattleLog
@end

@interface CGBattleEndLog : CGBattleLog
@end

@interface CGBattleOjbsStatusLog : CGBattleLog
- (id)initWithUnits:(NSArray *)units;
@end

@interface CGBattleSelectActionLog : CGBattleLog
- (id)initWithUnits:(NSArray *)units;
@end

@interface CGBattleSortLog : CGBattleLog
- (id)initWithUnits:(NSArray *)units;
@end

// src 对 des 使用 sid, 造成 value 物理/魔法伤害
// src 对 des 使用 sid, 恢复 value 血量/魔法
// src 对 des 使用 sid, 提升/降低 攻击力/防御力/5围

// src 对 des 使用 sid, des闪避
