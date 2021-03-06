/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2009 Lam Pham
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "CCTransition.h"
#import "CCProgressTimer.h"
#import "CCProgressTimerActions.h"

/** CCTransitionRadialCCW transition.
 A counter colock-wise radial transition to the next scene
 */
@interface CCTransitionRadialCCW : CCTransitionScene
@end

/* will be removed in v1.0.1 */
DEPRECATED_ATTRIBUTE @interface CCRadialCCWTransition : CCTransitionRadialCCW
@end

/** CCTransitionRadialCW transition.
 A counter colock-wise radial transition to the next scene
*/
@interface CCTransitionRadialCW : CCTransitionRadialCCW
@end

/* will be removed in v1.0.1 */
DEPRECATED_ATTRIBUTE @interface CCRadialCWTransition : CCTransitionRadialCW
@end
