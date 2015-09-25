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
        CGBattleUnit *b = [[CGBattleUnit alloc] initWithUnit:_atksOrigin[i]];
        b.location = i;
        [_aliveSet addObject:b];
    }
    
    for (int i=0; i<[_defsOrigin count]; i++) {
        CGBattleUnit *b = [[CGBattleUnit alloc] initWithUnit:_defsOrigin[i]];
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
        if (o.belong == type) {
            count++;
        }
    }
    return count;
}

@end


BOOL randomSkillAndTarget(CGBattleUnit *src, id units, CGAction* action)
{
#warning TODO
    int sid = 0;
    
    CGSkill *sk = [CGSkill skillWithSID:sid];
    CGBattleUnit *tar = randomTarget(src, units, sk.targetAvailable);

    if (!tar) {
        return 0;
    }
    
    action.skillID = sid;
    action.desLoc = tar.location;
    action.des = tar;
    
    return 1;
}

CGBattleUnit* randomTarget(CGBattleUnit *src, id units, CGSkillTargetAvailable skTarAva)
{
    assert([units count]>0);
    
    NSMutableSet *set = nil;
    
    if ([units isKindOfClass:[NSSet class]]) {
        set = [units mutableCopy];
    }
    if ([units isKindOfClass:[NSArray class]]) {
        set = [NSMutableSet setWithArray:units];
    }
    
    do {
        CGBattleUnit *unit = [set anyObject];
        
        if (unit.isAlive && canTarget(src, unit, skTarAva)) {
            return unit;
        }
        [set removeObject:unit];
        
    }while ([set count]>0) ;
    
    assert(0);
    return nil;
}


BOOL canTarget(CGBattleUnit *src, CGBattleUnit *des, CGSkillTargetAvailable tarAva)
{
    if (src == des) {
        if (tarAva & CGSkillTargetAvailableSelf) {
            return YES;
        }
    }
    else{
        if (tarAva & CGSkillTargetAvailableFriend) {
            if (src.belong == des.belong) {
                return YES;
            }
        }
        if (tarAva & CGSkillTargetAvailableEnemy) {
            if (src.belong != des.belong) {
                return YES;
            }
        }
    }
    
    return NO;
}

//{
//    NSMutableArray *logs = [NSMutableArray array];
//    [logs addObjectsFromArray:[self _actionLogsActionWithUnits:world]];
//
//    return logs;
//}
//
//- (NSMutableArray *)_actionLogsActionWithUnits:(CGWorld *)world
//{
//    CGSkill *sk = [CGSkill skillWithSID:self.actionSkillID];
//
//    return [sk battleLogsWithUnits:world.aliveSet srcLoc:self.location desLoc:self.actionTargetLocation];
//}
//


