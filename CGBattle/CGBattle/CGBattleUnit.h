//
//  CGBattleUnit.h
//  CGBattle
//
//  Created by Samuel on 9/20/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import "CGUnit.h"
#import "CGSkill.h"

typedef enum {
    
    CGActionUnitPrepare,
    
    CGActionUnitWillAction,
    CGActionUnitDidAction,
    CGActionUnitEndAction,
    
    CGActionUnitWillHurt,
    CGActionUnitDidHurt,
    
} CGActionState;

@class CGWorld;

@interface CGBattleUnit : NSObject

@property (nonatomic, weak, readonly) CGUnit *origin;

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
@property (nonatomic, assign) int isAlive; // 是否存活

- (instancetype)initWithUnit:(CGUnit *)unit;

@end


