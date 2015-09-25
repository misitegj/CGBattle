//
//  CGBattle.m
//  CGBattle
//
//  Created by Samuel on 9/19/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import "CGBattleManager.h"
#import "CGUnit.h"
#import "CG.h"
#import "CGBattleUnit.h"
#import "CGBattleLog.h"

@interface CGBattleManager() {

}

@end


static CGBattleManager *_instance = nil;

@implementation CGBattleManager


+ (CGBattleManager *)shared
{
    @synchronized (self) {
        if (!_instance) {
            _instance = [[CGBattleManager alloc] init];
        }
    }
    
    return _instance;
}

- (CGBattle *)battleWithAtkers:(NSArray *)atkers
                        Defers:(NSArray *)defers
{
    CGBattleWorld *world = [[CGBattleWorld alloc] initWithAtks:atkers defs:defers];
    CGBattle *battle = [[CGBattle alloc] initWithBattleWorld:world];
    
    return battle;
}

@end

