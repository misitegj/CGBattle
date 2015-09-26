//
//  CGBattleLog.m
//  CGBattle
//
//  Created by Samuel on 9/20/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import "CGBattleLog.h"
#import "CGBattleUnit.h"
#import <UIKit/UIKit.h>


@interface CGBattleLog()
@property (nonatomic, strong) NSString *desc;
@end

@implementation CGBattleLog

- (instancetype)init
{
    self = [super init];
    
    if (self) {
    }
    
    return self;
}

- (NSString *)description
{
    assert(0);
    return @"子类实现";
}

- (void)setDesc:(NSString *)desc
{
    _desc = desc;
    NSLog(@"%@", _desc);
}
@end


@implementation CGBattleMeleeLog

- (NSString *)description
{
    CGBattleUnit *src = self.src;
    
    assert([self.deses count]>0);
    
    if (!self.desc) {
        
        NSMutableString *mstr = [[NSMutableString alloc] init];
        
        for (CGBattleUnit *des in self.deses) {
            CGSkill *sk = [CGSkill skillWithSID:self.SID];
            
            [mstr appendString:[src.name length]?src.name:@"未知"];
            [mstr appendFormat:@"[%d]", src.hp];
            [mstr appendString:@" 对 "];
            [mstr appendString:[des.name length]?des.name:@"未知"];
            [mstr appendFormat:@"[%d]", des.hp];
            [mstr appendString:@" 使用 "];
            [mstr appendString:sk.name];
            [mstr appendString:@", 造成"];
            [mstr appendFormat:@"%d点 ", self.value];
            [mstr appendString:@"物理伤害"];
            
            [mstr appendString:@"\n"];
        }
        
        self.desc = mstr;
    }
    
    return self.desc;
}

- (id)initWithSID:(CGSkillID)SID
              src:(CGBattleUnit *)src
            deses:(NSArray *)deses
            value:(int)value
{
    self = [super init];
    if (self) {
        self.SID = SID;
        self.src = src;
        self.deses = deses;
        self.value = value;
        self.desc = [self description];
    }
    return self;
}

@end


@implementation CGBattleMeleeHitBackLog


@end

@implementation CGBattleMeleeMissLog

- (id)initWithSID:(CGSkillID)SID
              src:(CGBattleUnit *)src
            deses:(NSArray *)deses
{
    self = [super init];
    if (self) {
        self.SID = SID;
        self.src = src;
        self.deses = deses;
        self.value = 0;
        self.desc = [self description];
    }
    return self;
}

- (NSString *)description
{
    assert([self.deses count]>0);
    
    if (!self.desc) {
        NSMutableString *mstr = [[NSMutableString alloc] init];
        
        for (CGBattleUnit *des in self.deses) {
            CGSkill *sk = [CGSkill skillWithSID:self.SID];
            
            [mstr appendString:[self.src.name length] ? self.src.name : @"未知"];
            [mstr appendFormat:@"[%d]", self.src.hp];
            [mstr appendFormat:@"的 "];
            [mstr appendFormat:@"%@ 被 ", sk.name];
            [mstr appendString:[des.name length] ? des.name : @"未知"];
            [mstr appendFormat:@"[%d]", des.hp];
            [mstr appendString:@" 闪避了 "];
            [mstr appendString:@"\n"];
        }
        self.desc = mstr;
    }
    
    return self.desc;
}

@end

@implementation CGBattleDeadLog

- (id)initWithSrc:(CGBattleUnit *)src
{
    self = [super init];
    if (self) {
        self.src = src;
        [self description];
    }
    return self;
}
- (NSString *)description
{
    if (!self.desc) {
        self.desc = [NSString stringWithFormat:@"%@ 倒下了!", self.src.name];
    }
    return self.desc;
}
@end


@implementation CGBattleRoundBeginLog

- (void)setRound:(int)round
{
    _round = round;
    [self description];
}

- (NSString *)description
{
    if (!self.desc) {
        self.desc = [NSString stringWithFormat:@"第%d回合开始", self.round];
    }
    return self.desc;
}
@end

@implementation CGBattleRoundEndLog

- (void)setRound:(int)round
{
    _round = round;
    [self description];
}

- (NSString *)description
{
    if (!self.desc) {
        self.desc = [NSString stringWithFormat:@"第%d回合结束", self.round];
    }
    return self.desc;
}
@end


@implementation CGBattleBeginLog

- (id)init
{
    self = [super init];
    if (self) {
        [self description];
    }
    return self;
}
- (NSString *)description
{
    if (!self.desc) {
        self.desc = [NSString stringWithFormat:@"战斗开始"];
    }
    return self.desc;
}
@end

@implementation CGBattleEndLog

- (id)init
{
    self = [super init];
    if (self) {
        [self description];
    }
    return self;
}

- (NSString *)description
{
    if (!self.desc) {
        self.desc = [NSString stringWithFormat:@"战斗结束"];
    }
    return self.desc;
}
@end

@implementation CGBattleOjbsStatusLog
- (id)initWithUnits:(NSArray *)units
{
    self = [super init];
    if (self) {
        self.deses = units;
        [self description];
    }
    return self;
}
- (NSString *)description
{
    assert([self.deses count]>0);
    
    if (!self.desc) {
        NSMutableString *mstr = [[NSMutableString alloc] init];
        
        for (CGBattleUnit *unit in self.deses) {
            [mstr appendFormat:@"%@[%ld]\n", unit.name, (long)unit.hp];
        }
        self.desc = mstr;
    }
    
    return self.desc;
}
@end

@implementation CGBattleSelectActionLog
- (id)initWithUnits:(NSArray *)units
{
    self = [super init];
    if (self) {
        self.deses = units;
        [self description];
    }
    return self;
}

- (NSString *)description
{
    assert([self.deses count]>0);
    
//    if (!self.desc) {
//        NSMutableString *mstr = [[NSMutableString alloc] init];
//        
//        for (CGBattleUnit *unit in self.deses) {
//            CGSkill *sk = [CGSkill skillWithSID:unit.actionSkillID];
//            [mstr appendFormat:@"%@[%d] %@ [%d]位 \n", unit.origin.name, unit.location, sk.name, unit.actionTargetLocation];
//        }
//        self.desc = mstr;
//    }
    
    return self.desc;
}
@end


@implementation CGBattleSortLog
- (id)initWithUnits:(NSArray *)units
{
    self = [super init];
    if (self) {
        self.deses = units;
        [self description];
    }
    return self;
}

- (NSString *)description
{
    assert([self.deses count]>0);
    
//    if (!self.desc) {
//        NSMutableString *mstr = [[NSMutableString alloc] init];
//        
//        for (CGBattleUnit *unit in self.deses) {
//            [mstr appendFormat:@"%@ 第[%d]出手 \n", unit.origin.name, unit.actionOrder];
//        }
//        self.desc = mstr;
//    }
    
    return self.desc;
}
@end
