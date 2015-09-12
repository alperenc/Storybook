//
//  Story.h
//  Storybook
//
//  Created by Alp Eren Can on 11/09/15.
//  Copyright © 2015 Alp Eren Can. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Story : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) UIImage *coverImage;
@property (strong, nonatomic) NSURL *audioURL;

- (instancetype)initWithTitle:(NSString *)title author:(NSString *)author;

@end
