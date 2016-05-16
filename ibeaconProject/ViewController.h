//
//  ViewController.h
//  ibeaconProject
//
//  Created by Hadeel on 4/10/16.
//  Copyright © 2016 Gannon University. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
#import <KontaktSDK/KontaktSDK.h>

@interface ViewController : UIViewController <KTKBeaconManagerDelegate>

@property KTKBeaconManager *beaconManager;

@property KTKBeaconRegion *region;

@property NSMutableArray *list;

@property NSMutableArray *bm1;

@property NSMutableArray *bm2;

@property NSMutableArray *bm3;

@property NSMutableArray *bm4;

@property NSMutableArray *bm5;

@property NSMutableArray *bm6;

@property NSMutableArray *bm7;


@end

