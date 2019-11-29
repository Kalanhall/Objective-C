//
//  KLModel.h
//  KLModel <https://github.com/kalanhall/KLModel>
//
//  Created by kalan on 19/5/10.
//  Copyright (c) 2015 kalan.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

#if __has_include(<KLModel/KLModel.h>)
FOUNDATION_EXPORT double KLModelVersionNumber;
FOUNDATION_EXPORT const unsigned char KLModelVersionString[];
#import <KLModel/NSObject+KLModel.h>
#import <KLModel/KLClassInfo.h>
#else
#import "NSObject+KLModel.h"
#import "KLClassInfo.h"
#endif
