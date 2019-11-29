//
//  KLCarouselCell.m
//  KLCarousel
//
//  Created by Logic on 2019/11/29.
//

#import "KLCarouselCell.h"

@implementation KLCarouselCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = UIImageView.alloc.init;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.1];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}

@end
