//
//  CGBattle.h
//  CGBattle
//
//  Created by Samuel on 9/24/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGWorld.h"
#import "CGRound.h"

typedef enum : NSUInteger {
    CGBattleStatePrepare,         // 战斗准备阶段, 判断是否可以进入战斗
    CGBattleStateBegin,           // 战斗开始阶段, 计算单位的排位, 战斗资源锁定
    CGBattleStateRound,           // 回合阶段, 进入Round State
    CGBattleStateEnd,             // 战斗结束阶段, 经验和掉落结算
    
} CGBattleState;

typedef enum : NSUInteger {
    CGBattleTeamAtker,
    CGBattleTeamDefer,
    
} CGBattleTeamType;


@class CGBattle;

typedef void (^bBattleStateBlock)(CGBattle *b);

@interface CGBattle : NSObject {
    CGBattleState _battleState;
    CGWorld *_world;
    NSMutableArray *_rounds;
    int _round;
}

@property (nonatomic, assign) CGBattleState battleState;
@property (nonatomic, strong, readonly) CGWorld *world;
@property (nonatomic, strong) NSArray *logs; // battle log

@property (nonatomic, strong) bBattleStateBlock bBattleStateDidBeginBlock;
@property (nonatomic, strong) bBattleStateBlock bBattleStateDidEndBlock;

@property (nonatomic, strong) bRoundStateBlock bRoundStateDidBeginBlock;
@property (nonatomic, strong) bRoundStateBlock bRoundStateDidEndBlock;


- (instancetype)initWithAtks:(NSArray *)atks defs:(NSArray *)defs;

- (instancetype)initWithBattleWorld:(CGWorld *)world;

- (BOOL)canFire; // 是否可以开战
- (BOOL)fire; // 开战

@end
