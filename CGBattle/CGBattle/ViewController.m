//
//  ViewController.m
//  CGBattle
//
//  Created by Samuel on 9/19/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import "ViewController.h"
#import "CGBattleManager.h"
#import "CGUnit.h"
#import "CGBattleLog.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self doNewFight:nil];
}

- (IBAction)doNewFight:(id)sender {
    CGUnit *unit0 = [[CGUnit alloc] init];
    unit0.name = @"张辽";
    unit0.hp = 135;
    unit0.atk = 120;
    unit0.def = 90;
    unit0.belong = 0;
    unit0.UID = 100;
    
    CGUnit *unit1 = [[CGUnit alloc] init];
    unit1.name = @"乐进";
    unit1.hp = 160;
    unit1.atk = 105;
    unit1.def = 95;
    unit1.belong = 0;
    unit1.UID = 101;
    
    CGUnit *unit2 = [[CGUnit alloc] init];
    unit2.name = @"许褚";
    unit2.hp = 150;
    unit2.atk = 130;
    unit2.def = 88;
    unit2.belong = 0;
    unit2.UID = 102;
    
    CGUnit *unit3 = [[CGUnit alloc] init];
    unit3.name = @"典韦";
    unit3.hp = 160;
    unit3.atk = 120;
    unit3.def = 95;
    unit3.belong = 0;
    unit3.UID = 103;
    
    CGUnit *unit4 = [[CGUnit alloc] init];
    unit4.name = @"徐晃";
    unit4.hp = 150;
    unit4.atk = 100;
    unit4.def = 95;
    unit4.belong = 0;
    unit4.UID = 104;
    
    ///
    CGUnit *unit10 = [[CGUnit alloc] init];
    unit10.name = @"关羽";
    unit10.hp = 165;
    unit10.atk = 128;
    unit10.def = 95;
    unit10.belong = 1;
    unit10.UID = 200;
    
    CGUnit *unit11 = [[CGUnit alloc] init];
    unit11.name = @"赵云";
    unit11.hp = 150;
    unit11.atk = 120;
    unit11.def = 98;
    unit11.belong = 1;
    unit11.UID = 201;
    
    CGUnit *unit12 = [[CGUnit alloc] init];
    unit12.name = @"张飞";
    unit12.hp = 140;
    unit12.atk = 136;
    unit12.def = 78;
    unit12.belong = 1;
    unit12.UID = 202;
    
    CGUnit *unit13 = [[CGUnit alloc] init];
    unit13.name = @"黄忠";
    unit13.hp = 120;
    unit13.atk = 120;
    unit13.def = 85;
    unit13.belong = 1;
    unit13.UID = 203;
    
    CGUnit *unit14 = [[CGUnit alloc] init];
    unit14.name = @"诸葛亮";
    unit14.hp = 80;
    unit14.atk = 95;
    unit14.def = 90;
    unit14.belong = 1;
    unit14.UID = 204;
    
    NSArray *atks = @[unit0, unit1, unit2, unit3, unit4];
    NSArray *defs = @[unit10, unit11, unit12, unit13, unit14];
    
    CGBattle *b = [[CGBattleManager shared] battleWithAtkers:atks Defers:defs];
    
    b.bBattleStateDidEndBlock = ^(CGBattle *b) {
        NSLog(@"battle state = %ld", b.battleState);
        if (b.battleState == CGBattleStateEnd) {
            CGBattleOjbsStatusLog *sl = [[CGBattleOjbsStatusLog alloc] initWithUnits:b.world.aliveSet.allObjects];
            NSLog(@"%@", [sl description]);
        }
    };
    __weak CGBattle *__b = b;
    b.bRoundStateDidEndBlock = ^(CGRound *r) {
        if (r.roundState == CGRoundStateSort) {
            CGBattleSelectActionLog *log = [[CGBattleSelectActionLog alloc] initWithUnits:__b.world.aliveSet.allObjects];

        }
        else if (r.roundState == CGRoundStateUnitsAction) {
            CGBattleSortLog *log = [[CGBattleSortLog alloc] initWithUnits:__b.world.aliveSet.allObjects];
        }
        
        NSLog(@"round[%d] state = %ld", r.round, r.roundState);
    };
    
    if ([b canFire]) {
        [b fire];
    }
    
    
    NSMutableString *mstr = [[NSMutableString alloc] init];
  
    
    for (CGBattleLog *log in b.logs) {
        [mstr appendFormat:@"%@ \n", [log description]];
    }
    self.textView.text = mstr;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
