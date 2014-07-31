//
//  UITextField+CustomFont.m
//  watcher
//
//  Created by Alex Wang on 7/31/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import "UITextField+CustomFont.h"

@implementation UITextField (CustomFont)

- (void)setCustomFont {
    self.font = [UIFont fontWithName:@"Quicksand" size:self.font.pointSize];
}

@end
