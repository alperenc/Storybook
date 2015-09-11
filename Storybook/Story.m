//
//  Story.m
//  Storybook
//
//  Created by Alp Eren Can on 11/09/15.
//  Copyright © 2015 Alp Eren Can. All rights reserved.
//

#import "Story.h"

@implementation Story

- (instancetype)initWithTitle:(NSString *)title author:(NSString *)author coverImage:(UIImage *)coverImage
{
    self = [super init];
    if (self) {
        self.title = title;
        self.author = author;
        self.coverImage = coverImage;
    }
    return self;
}

@end
