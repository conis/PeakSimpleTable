//
//  ViewController.h
//  PeakSimpleTable-Samples
//
//  Created by conis on 8/23/13.
//  Copyright (c) 2013 conis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeakSimpleTable.h"

@interface ViewController : UIViewController<PeakSimpleTableDelegate>

@property (nonatomic, strong) IBOutlet PeakSimpleTable *simpleTable;
@end
