//
//  CGBattle.m
//  CGBattle
//
//  Created by Samuel on 9/24/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import "CGBattle.h"
#import "CGRound.h"
#import "CGBattleObject.h"

@implementation CGBattle


- (instancetype)initWithAtks:(NSArray *)atks
                        defs:(NSArray *)defs
{
    CGBattleWorld *world = [[CGBattleWorld alloc] initWithAtks:atks defs:defs];
    self = [self initWithBattleWorld:world];
    return self;
}


- (instancetype)initWithBattleWorld:(CGBattleWorld *)world
{
    self = [super init];
    if (self) {
        _battleState = CGBattleStatePrepare;
        _world = world;
    }
    return self;
}

- (BOOL)fire
{
    BOOL success = NO;
    
    if ([self canFire]) {
        success = [self battleLoop];
    }
    
    return success;
}

- (BOOL)canFire
{
    if (_battleState!=CGBattleStatePrepare) {
        assert(0);
        return NO;
    }
    
    if (![_world hasAtkersAlive]) {
        assert(0);
        return NO;
    }
    
    if (![_world hasDefersAlive]) {
        assert(0);
        return NO;
    }
    
    return YES;
}


- (BOOL)battleLoop
{
    BOOL loop = YES;
    BOOL finish = NO;
    
    while (loop) {
        
        CGBattleState nextState = _battleState;
        
        switch (nextState) {
            case CGBattleStatePrepare:
            {
                if (![self canFire]) {
                    loop = NO;
                    finish = NO;
                    assert(0);
                }
                else {
                    [self battlePrepare];
                    nextState = CGBattleStateBegin;
                }
            }
                break;
            case CGBattleStateBegin:
            {
                [self battleBegin];
                nextState = CGBattleStateRound;
            }
                break;
            case CGBattleStateRound:
            {
                _round = 0;
                do{
                    CGRound *r = [[CGRound alloc] initWithWorld:_world round:_round];
                    r.bRoundStateDidBeginBlock = self.bRoundStateDidBeginBlock;
                    r.bRoundStateDidEndBlock = self.bRoundStateDidEndBlock;

                    if (![r canRun]) {
                        continue;
                    }
                    else {
                        if ([r runLoop]) {
                            [_rounds addObject:r];
                            _round++;
                        }
                    }
                    
                }while (![self isBattleEnd]);
                nextState = CGBattleStateEnd;
            }
                break;
            case CGBattleStateEnd:
            {
                [self battleEnd];
                loop = NO;
                finish = YES;
            }
                break;
        }
        
        if (_battleState != nextState) {
            if (self.bBattleStateDidEndBlock) {
                self.bBattleStateDidEndBlock(self);
            }
            
            _battleState = nextState;
            
            if (self.bBattleStateDidBeginBlock) {
                self.bBattleStateDidBeginBlock(self);
            }
        }
    }
    
    return finish;
}

- (void)battlePrepare
{
    [self reset];
}

- (void)reset
{
    _rounds = [NSMutableArray array];
    [_world reset];
}

/*
 先做一步转换 CGObject -> CGBattleObject
 */

- (void)battleBegin
{
    
}

- (void)battleEnd
{
    
}

// 是否战斗结束
- (BOOL)isBattleEnd
{
    return [self isOneTeamAllDead];
}

- (BOOL)isOneTeamAllDead
{
    return ![_world hasAtkersAlive] || ![_world hasDefersAlive];
}


- (NSMutableSet *)aliveSet
{
    return _world.aliveSet;
}

- (NSMutableSet *)deadSet
{
    return _world.deadSet;
}

- (NSArray *)logs
{
    NSMutableArray *logs = [NSMutableArray array];
    
    for (CGRound *r in _rounds) {
        [logs addObjectsFromArray:r.logs];
    }
    
    return [NSArray arrayWithArray:logs];
}




@end
