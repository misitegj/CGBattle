//
//  ViewController.m
//  CGBattle
//
//  Created by Samuel on 9/19/15.
//  Copyright (c) 2015 Samuel. All rights reserved.
//

#import "ViewController.h"
#import "CGBattleManager.h"
#import "CGObject.h"
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
    CGObject *obj0 = [[CGObject alloc] init];
    obj0.name = @"张辽";
    obj0.hp = 135;
    obj0.atk = 120;
    obj0.def = 90;
    obj0.belong = 0;
    obj0.OID = 100;
    
    CGObject *obj1 = [[CGObject alloc] init];
    obj1.name = @"乐进";
    obj1.hp = 160;
    obj1.atk = 105;
    obj1.def = 95;
    obj1.belong = 0;
    obj1.OID = 101;
    
    CGObject *obj2 = [[CGObject alloc] init];
    obj2.name = @"许褚";
    obj2.hp = 150;
    obj2.atk = 130;
    obj2.def = 88;
    obj2.belong = 0;
    obj2.OID = 102;
    
    CGObject *obj3 = [[CGObject alloc] init];
    obj3.name = @"典韦";
    obj3.hp = 160;
    obj3.atk = 120;
    obj3.def = 95;
    obj3.belong = 0;
    obj3.OID = 103;
    
    CGObject *obj4 = [[CGObject alloc] init];
    obj4.name = @"徐晃";
    obj4.hp = 150;
    obj4.atk = 100;
    obj4.def = 95;
    obj4.belong = 0;
    obj4.OID = 104;
    
    ///
    CGObject *obj10 = [[CGObject alloc] init];
    obj10.name = @"关羽";
    obj10.hp = 165;
    obj10.atk = 128;
    obj10.def = 95;
    obj10.belong = 1;
    obj10.OID = 200;
    
    CGObject *obj11 = [[CGObject alloc] init];
    obj11.name = @"赵云";
    obj11.hp = 150;
    obj11.atk = 120;
    obj11.def = 98;
    obj11.belong = 1;
    obj11.OID = 201;
    
    CGObject *obj12 = [[CGObject alloc] init];
    obj12.name = @"张飞";
    obj12.hp = 140;
    obj12.atk = 136;
    obj12.def = 78;
    obj12.belong = 1;
    obj12.OID = 202;
    
    CGObject *obj13 = [[CGObject alloc] init];
    obj13.name = @"黄忠";
    obj13.hp = 120;
    obj13.atk = 120;
    obj13.def = 85;
    obj13.belong = 1;
    obj13.OID = 203;
    
    CGObject *obj14 = [[CGObject alloc] init];
    obj14.name = @"诸葛亮";
    obj14.hp = 80;
    obj14.atk = 95;
    obj14.def = 90;
    obj14.belong = 1;
    obj14.OID = 204;
    
    NSArray *atks = @[obj0, obj1, obj2, obj3, obj4];
    NSArray *defs = @[obj10, obj11, obj12, obj13, obj14];
    
    CGBattle *b = [[CGBattleManager shared] battleWithAtkers:atks Defers:defs];
    
    b.bBattleStateDidEndBlock = ^(CGBattle *b) {
        NSLog(@"battle state = %ld", b.battleState);
        if (b.battleState == CGBattleStateEnd) {
            CGBattleOjbsStatusLog *sl = [[CGBattleOjbsStatusLog alloc] initWithObjs:b.world.aliveSet.allObjects];
            NSLog(@"%@", [sl description]);
        }
    };
    __weak CGBattle *__b = b;
    b.bRoundStateDidEndBlock = ^(CGRound *r) {
        if (r.roundState == CGRoundStateSort) {
            CGBattleSelectActionLog *log = [[CGBattleSelectActionLog alloc] initWithObjs:__b.world.aliveSet.allObjects];

        }
        else if (r.roundState == CGRoundStateUnitsAction) {
            CGBattleSortLog *log = [[CGBattleSortLog alloc] initWithObjs:__b.world.aliveSet.allObjects];
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
