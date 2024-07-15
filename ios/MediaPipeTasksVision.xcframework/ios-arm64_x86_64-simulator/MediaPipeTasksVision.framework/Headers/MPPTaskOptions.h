// Copyright 2022 The MediaPipe Authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import <Foundation/Foundation.h>
#import "MPPBaseOptions.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * MediaPipe Tasks options base class. Any MediaPipe task-specific options class should extend
 * this class.
 */
NS_SWIFT_NAME(TaskOptions)

@interface MPPTaskOptions : NSObject <NSCopying>
/**
 * Base options for configuring the MediaPipe task.
 */
@property(nonatomic, copy) MPPBaseOptions *baseOptions;

@end

NS_ASSUME_NONNULL_END
