//
//  AppDelegate.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 20/01/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <GoogleSignIn/GoogleSignIn.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (strong, nonatomic) NSString *deviceToken;
@property (strong, nonatomic) NSDictionary *notificationUserInfo;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

