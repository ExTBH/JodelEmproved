//
// Settings.m
// Jodel EMPROVED
//
// Created By Natheer (@ExTBH) on 21/01/2023
//

#import <substrate.h>
#import <UIKit/UIKit.h>
#import "AppHeaders/UserSectionViewController.h"
#import "JodelEMPROVED-Swift.h"


static void (*orig_viewWillAppear)(UserSectionViewController *self, SEL _cmd, BOOL animated);
static void (*orig_moreTap)(UserSectionViewController *self, SEL _cmd, id sender);

static void presentSettingsControllerOn(__kindof UIViewController *controller){
    JESettingsViewController *settingsVC = [JESettingsViewController new];
    [controller.navigationController pushViewController:settingsVC animated:YES];
}

static NSArray<__kindof UIMenuElement*> *settingsMenuElements(UserSectionViewController *weakSelf){
    UIAction *app = [UIAction actionWithTitle:@"App" image:nil identifier:nil handler:^(UIAction *_){
        [weakSelf moreTap:nil];
    }];
    UIAction *tweak = [UIAction actionWithTitle:@"Jodel EMPROVED" image:nil identifier:nil handler:^(UIAction *_){
        presentSettingsControllerOn(weakSelf);
    }];

    return @[app, tweak];
}

static void __unused override_viewWillAppear(UserSectionViewController *self, SEL _cmd, BOOL animated)API_AVAILABLE(ios(14.0)){
    orig_viewWillAppear(self, _cmd, animated);

    self.navigationItem.leftBarButtonItem.action = nil;
    self.navigationItem.leftBarButtonItem.target = nil;

    UserSectionViewController __weak *weakSelf = self;
    UIMenu *menu = [UIMenu menuWithTitle:@"Open Settings for" children:settingsMenuElements(weakSelf)];
    self.navigationItem.leftBarButtonItem.menu = menu;
}

static NSArray<UIAlertAction*> *settingsAlertActions(UserSectionViewController *weakSelf, SEL _cmd){
    UIAlertAction *app = [UIAlertAction actionWithTitle:@"App" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        orig_moreTap(weakSelf, _cmd, nil);
    }];
    UIAlertAction *tweak = [UIAlertAction actionWithTitle:@"Jodel EMPROVED" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        presentSettingsControllerOn(weakSelf);
    }];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_){}];

    return @[app, tweak, cancel];
}

// iOS 13 does not support menu items in Buttons
static void override_moreTap(UserSectionViewController *self, SEL _cmd, id sender){

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Open Settings for" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UserSectionViewController __weak *weakSelf = self;
    for (UIAlertAction *action in (settingsAlertActions(weakSelf, _cmd))){
        [alert addAction:action];
    }
    [self presentViewController:alert animated:YES completion:nil];
}


__attribute__((constructor)) static void initializeHook(void){
    Class _UserSectionViewController = objc_getClass("Jodel.UserSectionViewController");

    if(@available(iOS 14.0, *)){
        MSHookMessageEx(
            _UserSectionViewController,
            @selector(viewWillAppear:),
            (IMP)&override_viewWillAppear,
            (IMP*)&orig_viewWillAppear
        );
        
    }
    else {
        MSHookMessageEx(
            _UserSectionViewController,
            @selector(moreTap:),
            (IMP)&override_moreTap,
            (IMP*)&orig_moreTap
        );
    }
}
