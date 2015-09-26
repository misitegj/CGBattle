//
//  CGRound.m
//  CGBattle
//
//  Created by Samuel on 9/24/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import "CGRound.h"
#import "CGWorld.h"
#import "CGBattleUnit.h"
#import "CGBattle.h"
#import "CGAction.h"

@interface CGRound(){
    
}

@end

@implementation CGRound

- (instancetype)initWithWorld:(CGWorld *)world
                        round:(int)round
{
    self = [super init];
    if (self) {
        _world = world;
        _round = round;
        _roundState = CGRoundStatePrepare;
    }
    return self;
}

/*
 位置分布   +10
 0,1      1,0
 2,3      3,2
 4,5      5,4
 6,7      7,6
 8,9      9,8
 
 步骤
 0, 新回合, 每个unit都选择了技能和对象
 1, 判断是否乱敏
 2, 按照敏捷排序, 或者随机排序
 3, 循环当前行动者, 行动者的攻击对象是否存活?攻击:随机选一个攻击
 4, 全部行动完毕
 5, 判断是否战斗结束(一方全部阵亡) ? 6结束 : 0开始新的一回合
 6, 结束
 */
- (BOOL)runLoop
{
    _roundState = CGRoundStatePrepare;
    
    BOOL loop = YES;
    BOOL finish = NO;
    
    NSMutableArray *logs = [NSMutableArray array];
    
    while (loop) {
        CGRoundState nextState = _roundState;
        
        switch (nextState) {
            case CGRoundStatePrepare:
                if (![self canRun]) {
                    loop = NO;
                    finish = NO;
                    assert(0);
                }
                else {
                    [self roundPrepare:_round];
                    nextState = CGRoundStateBegin;
                }
                break;
            case CGRoundStateBegin:
                [self roundBegin:_round];
                nextState = CGRoundStateUserInput;
                break;
            case CGRoundStateUserInput:
                // 暂时没有这个功能, 全部电脑控制
                [self roundUserInput:_round];
                nextState = CGRoundStateAISelectAction;
                break;
            case CGRoundStateAISelectAction:
                [self roundAISelectAction:_round];
                nextState = CGRoundStateSort;
                break;
            case CGRoundStateSort:
                [self roundSort:_round];
                nextState = CGRoundStateUnitsAction;
                break;
            case CGRoundStateUnitsAction:
                [logs addObjectsFromArray:[self roundUnitsAction:_round]];
                nextState = CGRoundStateEnd;
                break;
            case CGRoundStateEnd:
                [self roundEnd:_round];
                loop = NO;
                finish = YES;
                break;
        }
        
        if (_roundState != nextState) {
            if (self.bRoundStateDidEndBlock) {
                self.bRoundStateDidEndBlock(self);
            }
            
            _roundState = nextState;
            
            if (self.bRoundStateDidBeginBlock) {
                self.bRoundStateDidBeginBlock(self);
            }
        }
    }
    
    _logs = [logs copy];
    
    return finish;
}

- (BOOL)canRun
{
    return ![_world isOneTeamAllDead];
}

- (void)roundPrepare:(int)round
{
}

- (void)roundBegin:(int)round
{
    for (CGBattleUnit *unit in _world.aliveSet) {
        unit.isActioned = NO;
    }
}

- (void)roundUserInput:(int)round
{
    
}

- (void)roundAISelectAction:(int)round
{
    // 所有对象 选择完技能和对象
    NSMutableArray *actions = [NSMutableArray array];
    
    for (CGBattleUnit *unit in _world.aliveSet) {
        CGAction *a = [unit selectSkillAndTarget:_world];
        [actions addObject:a];
    }
    
    _actions = actions;
}

- (void)roundSort:(int)round
{
    // 设置行动序列
    NSArray *sortedActions = nil;
    
    BOOL isRandom = [self isRandomAgi]; // 是否乱敏
    if (isRandom)
        sortedActions =[self sortActionsByRandom:_actions];
    else
        sortedActions =[self sortActionsByAgi:_actions];
    
    // 行动顺序排序
    _actions = [sortedActions mutableCopy];
}

- (NSArray *)roundUnitsAction:(int)round
{
    NSMutableArray *logs = [NSMutableArray array];
    
    // 计算人物行动
    for (CGAction *action in _actions) {
        CGBattleUnit *unit = action.src;
        
        if ([_world isOneTeamAllDead]) {// 每一个人行动结束, 都要判断是否结束
            break;
        }
        
        if ([self unitCanAction:unit]) {
            NSArray *l = [unit doAction:action world:_world];
            [logs addObjectsFromArray:l];
        }
        else {
            // 死了或失去行动能力
            // 跳过
            continue;
        }
        // 每个人物行动结束都要重新 筛一遍
        [self removeDeadUnitsFromAliveSet];
    }
    
    return [NSArray arrayWithArray:logs];
}

- (void)roundEnd:(int)round
{
    [self removeDeadUnitsFromAliveSet];
}

# pragma mark - Utils

// 是否乱敏
- (BOOL)isRandomAgi
{
    return CGJudgeRandomFloat(0.3f);
}

- (NSArray *)sortActionsByRandom:(NSArray *)array
{
    assert([array count]>0);
    
    NSArray *originArray = [array copy];
    
    NSMutableSet *set = [NSMutableSet setWithArray:originArray];
    NSMutableArray *arr = [NSMutableArray array];
    
    int i = 0;
    do{
        CGAction *a = [set anyObject];
        a.order = i++;
        [set removeObject:a];
        [arr addObject:a];
        
    }while ([set count]>0);
    
    return [NSArray arrayWithArray:arr];
}

typedef NSComparisonResult (^NSComparator)(id unit1, id unit2);

- (NSArray *)sortActionsByAgi:(NSArray *)array
{
    assert([array count]>0);
    NSArray *originArray = [array copy];
    
    NSArray *arr = [originArray sortedArrayUsingComparator:^NSComparisonResult(CGAction *a1, CGAction *a2){
        if (a1.src.agi == a2.src.agi) {
            return CGRandom(2);
        }
        return a1.src.agi < a2.src.agi;
    }];
    
    for (int i=0; i<[arr count]; i++) {
        CGAction *a = [arr objectAtIndex:i];
        a.order = i;
    }
    
    return [NSArray arrayWithArray:arr];
}

- (void)removeDeadUnitsFromAliveSet
{
    // 计算或者和死亡的列表
    NSMutableSet *tmpSet = [NSMutableSet set];
    
    for (CGBattleUnit *unit in _world.aliveSet) {
        if (!unit.isAlive || unit.hp<=0) {
            unit.isAlive = NO;
            unit.hp = 0;
            [tmpSet addObject:unit];
        }
    }
    
    [_world.aliveSet minusSet:tmpSet];
    [_world.deadSet unionSet:tmpSet];
}

- (BOOL)unitCanAction:(CGBattleUnit *)unit
{
    return unit.isAlive && !unit.isActioned;
}



@end
