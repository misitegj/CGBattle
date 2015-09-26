//
//  CGBattleWorld.m
//  CGBattle
//
//  Created by Samuel on 9/24/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import "CGWorld.h"
#import "CGBattleUnit.h"
#import "CGBattle.h"
#import "CGAction.h"

@interface CGWorld()

@property (nonatomic, strong) NSMutableArray *atksOrigin;    // 初始攻击方, CGObject
@property (nonatomic, strong) NSMutableArray *defsOrigin;    // 初始防御方

@end

@implementation CGWorld


+ (instancetype)battleWorldWithAtks:(NSArray *)atks
                               defs:(NSArray *)defs
{
    CGWorld *world = [[CGWorld alloc] initWithAtks:atks
                                              defs:defs];
    return world;
}

- (instancetype)initWithAtks:(NSArray *)atks
                        defs:(NSArray *)defs
{
    self = [super init];
    if (self) {
        _atksOrigin = [atks mutableCopy];
        _defsOrigin = [defs mutableCopy];
        
        [self reset];
    }
    return self;
}

- (void)reset
{
    _aliveSet = [[NSMutableSet alloc] init];
    _deadSet = [[NSMutableSet alloc] init];
    
    for (int i=0; i<[_atksOrigin count]; i++) {
        CGBattleUnit *b = [_atksOrigin[i] copy];
        b.team = CGBattleTeamAtker;
        b.location = i;
        [_aliveSet addObject:b];
    }
    
    for (int i=0; i<[_defsOrigin count]; i++) {
        CGBattleUnit *b = [_defsOrigin[i] copy];
        b.team = CGBattleTeamDefer;
        b.location = kTeamBLocationOffset + i;
        [_aliveSet addObject:b];
    }
}

- (BOOL)hasAtkersAlive
{
    return [self atkersAliveCount]>0;
}

- (BOOL)hasDefersAlive
{
    return [self defersAliveCount]>0;
}

- (BOOL)isOneTeamAllDead
{
    return [self atkersAliveCount]==0 || [self defersAliveCount]==0;
}

- (int)atkersAliveCount
{
    return [self aliveCountWithTeamType:CGBattleTeamAtker];
}

- (int)defersAliveCount
{
    return [self aliveCountWithTeamType:CGBattleTeamDefer];
}

- (int)aliveCountWithTeamType:(CGBattleTeamType)type
{
    int count = 0;
    for (CGBattleUnit *o in _aliveSet) {
        if (o.team == type) {
            count++;
        }
    }
    return count;
}


- (CGBattleUnit *)searchUnitByLocation:(int)loc
{
    for (CGBattleUnit *unit in self.aliveSet) {
        if (unit.location == loc) {
            return unit;
        }
    }
    
    return nil;
}

@end



