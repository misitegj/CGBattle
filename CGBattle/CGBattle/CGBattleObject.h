//
//  CGBattleObject.h
//  CGBattle
//
//  Created by Samuel on 9/20/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import "CGObject.h"
#import "CGSkill.h"

@interface CGBattleObject : NSObject

@property (nonatomic, weak, readonly) CGObject *origin;

@property (nonatomic, assign) BOOL isActioned;
@property (nonatomic, assign) int belong; // 我方, 敌方, 友方

@property (nonatomic, assign) NSMutableArray *buffs; // 增益
@property (nonatomic, assign) NSMutableArray *debuffs; // 负

@property (nonatomic, assign) int Lv; // 等级
@property (nonatomic, assign) int hp; // 生命
@property (nonatomic, assign) int mp; // 魔法
@property (nonatomic, assign) int atk; // 攻击
@property (nonatomic, assign) int def; // 防御
@property (nonatomic, assign) int agi; // 敏捷
@property (nonatomic, assign) int rep; // 回复
@property (nonatomic, assign) int spr; // 精神

@property (nonatomic, assign) int crystal; // 水晶
@property (nonatomic, assign) int kind; // 种类 人形系
@property (nonatomic, strong) NSArray *skills; // 技能

@property (nonatomic, assign) int rstPosion;
@property (nonatomic, assign) int rstRock;
@property (nonatomic, assign) int rstDrunk;
@property (nonatomic, assign) int rstSleepy;
@property (nonatomic, assign) int rstConfuse;
@property (nonatomic, assign) int rstForget;

@property (nonatomic, assign) int crtCritical;
@property (nonatomic, assign) int crtAccurate;
@property (nonatomic, assign) int crtHitBack;
@property (nonatomic, assign) int crtDodge;

@property (nonatomic, assign) int location; // 位置0-9
@property (nonatomic, assign) int actionOrder; // 行动顺序
@property (nonatomic, assign) int isAlive; // 是否存活

@property (nonatomic, assign) int actionTargetLocation; // 下一步行动的对象位置
@property (nonatomic, assign) int actionSkillID; // 下一步行动的技能ID


- (instancetype)initWithCGObject:(CGObject *)obj;

// 选择目标和使用技能
- (void)AI_calcTargetsWithObjs:(NSMutableSet *)set;

// 输出行动日志
- (NSMutableArray *)AI_actionLogsWithObjs:(NSMutableSet *)objs;
@end

extern BOOL canTarget(CGBattleObject *src, CGBattleObject *des, CGSkillTargetAvailable tarAva);
extern CGBattleObject* randomTarget(CGBattleObject *src, id objs, CGSkillTargetAvailable skTarAva);


