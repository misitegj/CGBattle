//
//  CGRound.h
//  CGBattle
//
//  Created by Samuel on 9/24/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    CGRoundStatePrepare,          // 回合准备阶段
    CGRoundStateBegin,            // 回合开始阶段
    CGRoundStateUserInput,        // 等待用户输入
    CGRoundStateAISelectAction,   // AI选择行动目标和技能
    CGRoundStateSort,             // 行动顺序排序
    CGRoundStateUnitsAction,      // 各个单位行动
    CGRoundStateEnd,              // 回合结束阶段
    
} CGRoundState;

@class CGBattleWorld, CGRound;

typedef void (^bRoundStateBlock)(CGRound *r);


@interface CGRound : NSObject {
    CGRoundState _roundState;
    CGBattleWorld *_world;
    int _round;
}

@property (nonatomic, assign, readonly) int round;
@property (nonatomic, assign, readonly) CGRoundState roundState;
@property (nonatomic, strong, readonly) NSArray *logs; // 战斗日志

@property (nonatomic, strong) bRoundStateBlock bRoundStateDidBeginBlock;
@property (nonatomic, strong) bRoundStateBlock bRoundStateDidEndBlock;

- (instancetype)initWithWorld:(CGBattleWorld *)world
                        round:(int)round;

- (BOOL)canRun;
- (BOOL)runLoop;

@end
