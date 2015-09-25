//
//  CGBattle.h
//  CGBattle
//
//  Created by Samuel on 9/19/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGBattle.h"

@interface CGBattleManager : NSObject


+ (CGBattleManager *)shared;

- (CGBattle *)battleWithAtkers:(NSArray *)atkers
                        Defers:(NSArray *)defers;

@end

