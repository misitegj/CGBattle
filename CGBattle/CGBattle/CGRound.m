//
//  CGRound.m
//  CGBattle
//
//  Created by Samuel on 9/24/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import "CGRound.h"
#import "CGBattleWorld.h"
#import "CGBattleObject.h"
#import "CGBattle.h"

@interface CGRound(){
    
    NSMutableArray *_sortedUnits;   // 出手顺序排序后的单位数组
}

@end

@implementation CGRound

- (instancetype)initWithWorld:(CGBattleWorld *)world
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
 0, 新回合, 每个obj都选择了技能和对象
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
    for (CGBattleObject *obj in _world.aliveSet) {
        obj.isActioned = NO;
    }
}

- (void)roundUserInput:(int)round
{
    
}

- (void)roundAISelectAction:(int)round
{
    // 所有对象 选择完技能和对象
    for (CGBattleObject *obj in _world.aliveSet) {
        [obj AI_calcTargetsWithObjs:_world.aliveSet];
    }
}

- (void)roundSort:(int)round
{
    // 行动顺序排序
    _sortedUnits = [[self sortUnits] mutableCopy];
}

- (NSArray *)roundUnitsAction:(int)round
{
    NSMutableArray *logs = [NSMutableArray array];
    
    // 计算人物行动
    for (CGBattleObject *obj in _sortedUnits) {
        if ([_world isOneTeamAllDead]) {// 每一个人行动结束, 都要判断是否结束
            break;
        }
        
        if ([self objCanAction:obj]) {
            NSArray *l = [obj AI_actionLogsWithObjs:_world.aliveSet];
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


- (NSArray *)sortUnits
{
    // 设置行动序列
    NSArray *sortedArray = nil;
    
    BOOL isRandom = [self isRandomAgi]; // 是否乱敏
    if (isRandom)
        sortedArray =[self sortUnitsByRandom:_world.aliveSet];
    else
        sortedArray =[self sortUnitsByAgi:_world.aliveSet];
    
    return sortedArray;
}

// 是否乱敏
- (BOOL)isRandomAgi
{
    return CGJudgeRandomFloat(0.3f);
}

- (NSMutableArray *)sortUnitsByRandom:(NSMutableSet *)aliveSet
{
    assert([aliveSet count]>0);
    
    NSMutableSet *set = [aliveSet mutableCopy];
    NSMutableArray *arr = [NSMutableArray array];
    
    int i = 0;
    do{
        CGBattleObject *obj = [set anyObject];
        obj.actionOrder = i++;
        [set removeObject:obj];
        [arr addObject:obj];
        
    }while ([set count]>0);
    
    return arr;
}

typedef NSComparisonResult (^NSComparator)(id obj1, id obj2);

- (NSMutableArray *)sortUnitsByAgi:(NSMutableSet *)aliveSet
{
    assert([aliveSet count]>0);
    
    NSArray *result = [aliveSet.allObjects sortedArrayUsingComparator:^NSComparisonResult(CGBattleObject *o1, CGBattleObject *o2){
        
        if (o1.agi==o2.agi) {
            return CGRandom(2);
        }
        return o1.agi < o2.agi;
    }];
    
    for (int i=0; i<[result count]; i++) {
        CGBattleObject *obj = [result objectAtIndex:i];
        obj.actionOrder = i;
    }
    
    return [result mutableCopy];
}

- (NSMutableArray *)ojbsByActionOrder:(NSMutableArray *)objs
{
    assert([objs count]>0);
    
    NSArray *result = [objs sortedArrayUsingComparator:^NSComparisonResult(CGBattleObject *o1, CGBattleObject *o2){
        return o1.actionOrder < o2.actionOrder;
    }];
    
    for (int i=0; i<[result count]; i++) {
        CGBattleObject *obj = [result objectAtIndex:i];
        obj.actionOrder = i;
    }
    
    return [result mutableCopy];
}

- (void)removeDeadUnitsFromAliveSet
{
    // 计算或者和死亡的列表
    NSMutableSet *tmpSet = [NSMutableSet set];
    
    for (CGBattleObject *obj in _world.aliveSet) {
        if (!obj.isAlive || obj.hp<=0) {
            obj.isAlive = NO;
            obj.hp = 0;
            [tmpSet addObject:obj];
        }
    }
    
    [_world.aliveSet minusSet:tmpSet];
    [_world.deadSet unionSet:tmpSet];
}

- (BOOL)objCanAction:(CGBattleObject *)obj
{
    return obj.isAlive && !obj.isActioned;
}



@end
