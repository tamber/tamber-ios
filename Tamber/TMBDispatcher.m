//
//  TMBDispatcher.m
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2020 Tamber. All rights reserved.
//

#import "TMBDispatcher.h"

void tmbDispatchToMainThreadIfNecessary(dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        block();
    }
    else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}
