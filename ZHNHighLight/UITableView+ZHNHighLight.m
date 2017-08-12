//
//  UITableView+ZHNHighLight.m
//  ZHNHighlight
//
//  Created by zhn on 2017/8/11.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "UITableView+ZHNHighLight.h"
#import <objc/runtime.h>
#import <objc/message.h>
@interface UITableView()<UITableViewDelegate>
@property (nonatomic,strong) UIColor *zhn_normalColor;
@end

@implementation UITableView (ZHNHighLight)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UITableView swizzinClass:[UITableView class] OriginalSEL:@selector(setDelegate:) TonewSEL:@selector(zhn_setDelegate:)];
    });
}

- (void)zhn_setDelegate:(id<UITableViewDelegate>)delegate {
    [self zhn_setDelegate:delegate];
    Class class = [delegate class];
    SEL originSelector = @selector(tableView:didSelectRowAtIndexPath:);
    SEL swizzlSelector = NSSelectorFromString(@"swiz_didSelectRowAtIndexPath");
    BOOL didAddMethod = class_addMethod(class, swizzlSelector, (IMP)swiz_didSelectRowAtIndexPath, "v@:@@");
    if (didAddMethod) {
        Method originMethod = class_getInstanceMethod(class, swizzlSelector);
        Method swizzlMethod = class_getInstanceMethod(class, originSelector);
        method_exchangeImplementations(originMethod, swizzlMethod);
    }
}

void swiz_didSelectRowAtIndexPath(id self, SEL _cmd, id tableView, NSIndexPath *indexpath) {
    SEL selector = NSSelectorFromString(@"swiz_didSelectRowAtIndexPath");
    ((void(*)(id, SEL,id, NSIndexPath *))objc_msgSend)(self, selector, tableView, indexpath);
    UITableView *_tableView = (UITableView *)tableView;
    if (!_tableView.zhn_highLightColor) {return;}
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexpath];
    if (!_tableView.zhn_normalColor) {
        _tableView.zhn_normalColor = cell.backgroundColor;
    }
    cell.backgroundColor = _tableView.zhn_highLightColor;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cell.backgroundColor = _tableView.zhn_normalColor;
    });
}

+ (void)swizzinClass:(Class)swizzingClass OriginalSEL:(SEL)originalSEL TonewSEL:(SEL)newSEL {
    Method originalMehtod = class_getInstanceMethod(swizzingClass, originalSEL);
    Method newMethod = class_getInstanceMethod(swizzingClass, newSEL);
    BOOL didAddMethod = class_addMethod(swizzingClass, originalSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (didAddMethod) {
        class_replaceMethod(swizzingClass, newSEL, method_getImplementation(originalMehtod), method_getTypeEncoding(originalMehtod));
    }else {
        method_exchangeImplementations(originalMehtod, newMethod);
    }
}

// ----------------------- 高亮颜色 -----------------------
- (void)setZhn_highLightColor:(UIColor *)zhn_highLighColor {
    objc_setAssociatedObject(self, @selector(zhn_highLightColor), zhn_highLighColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)zhn_highLightColor {
    return objc_getAssociatedObject(self, @selector(zhn_highLightColor));
}

// ----------------------- 默认状态的颜色 -----------------------
- (void)setZhn_normalColor:(UIColor *)zhn_normalColor {
    objc_setAssociatedObject(self, @selector(zhn_normalColor), zhn_normalColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)zhn_normalColor {
    return objc_getAssociatedObject(self, @selector(zhn_normalColor));
}

@end
