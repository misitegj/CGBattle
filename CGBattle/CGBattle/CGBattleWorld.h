//
//  CGBattleWorld.h
//  CGBattle
//
//  Created by Samuel on 9/24/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTeamBLocationOffset 10

@interface CGBattleWorld : NSObject

@property (nonatomic, strong) NSMutableSet *aliveSet;        // 存活单位集合 CGBattleObject
@property (nonatomic, strong) NSMutableSet *deadSet;         // 死亡单位集合


+ (instancetype)battleWorldWithAtks:(NSArray *)atks
                               defs:(NSArray *)defs;

- (instancetype)initWithAtks:(NSArray *)atks
                        defs:(NSArray *)defs;

- (void)reset;

- (BOOL)hasAtkersAlive;
- (BOOL)hasDefersAlive;

- (BOOL)isOneTeamAllDead;
@end
