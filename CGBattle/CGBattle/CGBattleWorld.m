//
//  CGBattleWorld.m
//  CGBattle
//
//  Created by Samuel on 9/24/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import "CGBattleWorld.h"
#import "CGBattleObject.h"
#import "CGBattle.h"


@interface CGBattleWorld()

@property (nonatomic, strong) NSMutableArray *atksOrigin;    // 初始攻击方, CGObject
@property (nonatomic, strong) NSMutableArray *defsOrigin;    // 初始防御方

@end

@implementation CGBattleWorld


+ (instancetype)battleWorldWithAtks:(NSArray *)atks
                               defs:(NSArray *)defs
{
    CGBattleWorld *world = [[CGBattleWorld alloc] initWithAtks:atks
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
        CGBattleObject *b = [[CGBattleObject alloc] initWithCGObject:_atksOrigin[i]];
        b.location = i;
        [_aliveSet addObject:b];
    }
    
    for (int i=0; i<[_defsOrigin count]; i++) {
        CGBattleObject *b = [[CGBattleObject alloc] initWithCGObject:_defsOrigin[i]];
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
    for (CGBattleObject *o in _aliveSet) {
        if (o.belong == type) {
            count++;
        }
    }
    return count;
}

@end
