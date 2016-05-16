//
//  ViewController.m
//  ibeaconProject
//
//  Created by Hadeel on 4/10/16.
//  Copyright © 2016 Gannon University. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self startBeacon];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// beacons methods

-(void)startBeacon

{
    
    [self initBeaconMang];
    [self BeaconRegion];
    
}

-(void)initBeaconMang
{
    self.beaconManager = [[KTKBeaconManager alloc] initWithDelegate:self];
    // Request Location Authorization
    [self.beaconManager requestLocationAlwaysAuthorization];
}

-(void)BeaconRegion
{
    
    // Kontakt.io proximity UUID
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:@"f7826da6-4fa2-4e98-8024-bc5b71e0893e"];
    
    // Create region instance
    
    self.region = [[KTKBeaconRegion alloc] initWithProximityUUID: proximityUUID major:1 identifier:@"identifier"];
    
    self.region.notifyOnEntry=YES;
    self.region.notifyOnExit=YES;
    self.region.notifyEntryStateOnDisplay=YES;
    
    // Start ranging
    [self.beaconManager startRangingBeaconsInRegion: self.region];
    
    // Start Monitoring
    [self.beaconManager startMonitoringForRegion: self.region];
    
}

-(NSString*)getBeaconProximity:(CLBeacon*)beacon

{
    NSString *proximity;
    switch (beacon.proximity) {
        case CLProximityNear:
            proximity = @"Near";
            break;
        case CLProximityImmediate:
            proximity = @"Immediate";
            break;
        case CLProximityFar:
            proximity = @"Far";
            break;
        case CLProximityUnknown:
        default:
            proximity = @"Unknown";
            break;
    }
    
    //    NSLog(@"the proximity %@", proximity);
    return proximity;
    
    
}

- (void)beaconManager:(KTKBeaconManager*)manager didStartMonitoringForRegion:(__kindof KTKBeaconRegion*)region
{
    [self.beaconManager requestStateForRegion:self.region];
    
}

- (void)beaconManager:(KTKBeaconManager*)manager didDetermineState:(CLRegionState)state forRegion:(__kindof KTKBeaconRegion*)region
{
    if (state == CLRegionStateInside)
    {
        // Start ranging ...
        //    [manager startRangingBeaconsInRegion:self.region];
        
    }
    
    else
    {
        NSLog(@"Failed");
    }
    
    
    
}

- (void)beaconManager:(KTKBeaconManager*)manager didChangeLocationAuthorizationStatus:(CLAuthorizationStatus)status;
{
    // ...
}

- (void)beaconManager:(KTKBeaconManager*)manager didEnterRegion:(__kindof KTKBeaconRegion*)region
{
    NSLog(@"Enter region %@", region);
}

- (void)beaconManager:(KTKBeaconManager*)manager didExitRegion:(__kindof KTKBeaconRegion*)region
{
    NSLog(@"Exit region %@", region);
}

- (void)beaconManager:(KTKBeaconManager*)manager didRangeBeacons:(NSArray <CLBeacon *>*)beacons inRegion:(__kindof KTKBeaconRegion*)region
{

    [self writeDistanceWithProxToList:[beacons mutableCopy]];

}

-(double)calculateAccuracyWithRssi:(double)rssi forMinor:(NSNumber*)minor  {
    
    double calibratedRSSI = 0.0;
//    double newCalibratedRSSI = 0.0;
    
    if(minor){
        
    
    if (minor.intValue == 1 )
    {
        calibratedRSSI = 71.1;
//        71.1
//        78.9   with 30 m away
    }
    
    if (minor.intValue == 2 )
    {
        calibratedRSSI = 67.7;
    }
    
    if (minor.intValue == 3 )
    {
        calibratedRSSI = 71.0;
    }
    
    
    if (minor.intValue == 4 )
    {
        calibratedRSSI = 70.2;
    }
    
    
    if (minor.intValue == 5 )
    {
        calibratedRSSI = 71.3;
    }
    
    // device off
    if (minor.intValue == 6 )
    {
        calibratedRSSI = 70.7;
    }
    
    
    if (minor.intValue == 7 )
    {
        calibratedRSSI = 77.0;
    }
    }
    
    if (rssi == 0) {
        return -1.0; // if we cannot determine accuracy, return -1.
    }

    //value = txPower * pow((d - .111)/ (0.89976), (1/7.7095));
    
//    double value = 4 * pow((30 - .111)/ (0.89976), (1/7.7095));
//    
//    newCalibratedRSSI = rssi * (11.8165 / calibratedRSSI);
//    
//    double ratio = newCalibratedRSSI*1.0/-12;
//        if (ratio < 1.0) {
//            return pow(ratio,10);
//        }
//        else {
//    double accuracy =  (0.89976)*pow(ratio,7.7095) + 0.111;
//    
//    return accuracy;
//        }
    

    
//
//    double ratio = rssi*1.0/-calibratedRSSI;
//    if (ratio < 1.0) {
//        return pow(10,ratio);
//    }
//    else {
//        double accuracy =  (0.89976)*pow(7.7095,ratio) + 0.111;
//    
//        return accuracy;
//    }
//    
    
    
    // what i calculated
    
        double accuracy = pow(10, (- calibratedRSSI - rssi) / (10 * 2));
    
    
//    double ratio = - calibratedRSSI - rssi;
//    double ratio_linear = pow(10,ratio/10);
//    
//
//    double accuracy =  sqrt(ratio_linear);
    
    return accuracy;
    
}


-(void)avgPrint

{
    
    NSLog(@"avg = %@", [self.bm1 valueForKeyPath:@"@avg.doubleValue"]);
    self.bm1 = [[NSMutableArray alloc] init];
}


-(void)writedistancetoCSVFile:(NSMutableArray *)list
{
    
    NSMutableString *buffer = [NSMutableString string];
    
    for (NSUInteger i = 0; i < list.count; i++) {
//        NSNumber *temp = self.list[i];
        
        NSString *value = list[i];
        
        if (i > 0) {
            if (i % 5 == 0) { //after every 5th value
                //
                
                [buffer appendString:@"\n"]; //end line
            }
            else {
                [buffer appendString:@","];
            }
        }
        
        [buffer appendString:value];
        
        //if your values contain spaces, you should add quotes around values...
        //buffer.appendFormat(@"\"%@\"", value);
    }
    
    NSLog(@"%@",buffer);
    
//    self.list = [[NSMutableArray alloc] init];
    
    
}

-(void)writeDistanceWithProxToList:(NSArray <CLBeacon *>*)beacons

{
        if (beacons.count > 0)
        {

            
            
            for (NSUInteger i = 0; i < beacons.count; i++)
            {
//                NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TheBeacons" ofType:@"plist"];
                double DistA, DistB, DistC, DistD, DistE, DistF , DistG;
                double DistATest, DistBTest, DistCTest, DistDTest, DistETest, DistFTest, DistGTest;
                NSInteger DistAAcc, DistBAcc, DistCAcc, DistDAcc , DistEAcc , DistFAcc , DistGAcc;
                NSString *proximityA, *proximityB , *proximityC, *proximityD, *proximityE, *proximityF, *proximityG;
                NSNumber *minorA, *minorB, *minorC, *minorD, *minorE, *minorF, *minorG;
                
                CLBeacon *abeacon = [beacons objectAtIndex:i];
                
                if (abeacon.minor.intValue == 1) {
                    minorA = abeacon.minor;
                    DistA = abeacon.accuracy;
                    proximityA = [self getBeaconProximity:abeacon];
                    DistAAcc = abeacon.rssi;
                    DistATest = [self calculateAccuracyWithRssi:abeacon.rssi forMinor:abeacon.minor];
                    
                    
                    
                    if (!self.list) {
                        self.list = [[NSMutableArray alloc] init];
                        [self.list addObject:@"ibeacon minor"];
                        [self.list addObject:@"accuracy"];
                        [self.list addObject:@"proximity"];
                        [self.list addObject:@"RSSI"];
                        [self.list addObject:@"Calbration"];
                        
                    }
                    
                    [self.list addObject:[minorA stringValue]];
                    [self.list addObject:[[NSNumber numberWithDouble:DistA] stringValue]];
                    [self.list addObject:proximityA];
                    [self.list addObject:[[NSNumber numberWithInteger:DistAAcc] stringValue ]];
                    [self.list addObject:[[NSNumber numberWithDouble:DistATest] stringValue]];
                    
                    if (!self.bm1) {
                        self.bm1 = [[NSMutableArray alloc] init];
                    }
                    
                    if (!(DistAAcc == -1)) {
                        [self.bm1 addObject:[NSNumber numberWithDouble:DistAAcc]];
                    }
//                    [self.bm1 addObject:[NSNumber numberWithDouble:DistAAcc]];
                    
                    if (self.bm1.count > 30) {
//                        [self avgPrint];
                    }
                    
                    if (self.list.count  > 350) {
                        [self writedistancetoCSVFile:self.list];
                        self.list = [[NSMutableArray alloc] init];
                       
                    }
                    
                }
                
                
                
                if (abeacon.minor.intValue == 2) {
                 minorB = abeacon.minor;
                 DistB = abeacon.accuracy;
                 proximityB = [self getBeaconProximity:abeacon];
                 DistBAcc =abeacon.rssi;
                 DistBTest = [self calculateAccuracyWithRssi:abeacon.rssi forMinor:abeacon.minor];
                    
                    if (!self.bm2) {
                        self.bm2 = [[NSMutableArray alloc] init];
                        [self.bm2 addObject:@"ibeacon minor"];
                        [self.bm2 addObject:@"accuracy"];
                        [self.bm2 addObject:@"proximity"];
                        [self.bm2 addObject:@"RSSI"];
                        [self.bm2 addObject:@"Calbration"];
                        
                    }
                    
                    [self.bm2 addObject:[minorB stringValue]];
                    [self.bm2 addObject:[[NSNumber numberWithDouble:DistB] stringValue]];
                    [self.bm2 addObject:proximityB];
                    [self.bm2 addObject:[[NSNumber numberWithInteger:DistBAcc] stringValue ]];
                    [self.bm2 addObject:[[NSNumber numberWithDouble:DistBTest] stringValue]];
                    
                    
                    if (self.bm2.count  > 350) {
                        [self writedistancetoCSVFile:self.bm2];
                        
                        self.bm2 = [[NSMutableArray alloc] init];
                        
                    }
                    
                }
                
                
                if (abeacon.minor.intValue == 3) {
                minorC = abeacon.minor;
                DistC = abeacon.accuracy;
                proximityC = [self getBeaconProximity:abeacon];
                DistCAcc =abeacon.rssi;
                DistCTest = [self calculateAccuracyWithRssi:abeacon.rssi forMinor:abeacon.minor];
                    
                    if (!self.bm3) {
                        self.bm3 = [[NSMutableArray alloc] init];
                        [self.bm3 addObject:@"ibeacon minor"];
                        [self.bm3 addObject:@"accuracy"];
                        [self.bm3 addObject:@"proximity"];
                        [self.bm3 addObject:@"RSSI"];
                        [self.bm3 addObject:@"Calbration"];
                        
                    }
                    
                    [self.bm3 addObject:[minorC stringValue]];
                    [self.bm3 addObject:[[NSNumber numberWithDouble:DistC] stringValue]];
                    [self.bm3 addObject:proximityC];
                    [self.bm3 addObject:[[NSNumber numberWithInteger:DistCAcc] stringValue ]];
                    [self.bm3 addObject:[[NSNumber numberWithDouble:DistCTest] stringValue]];
                    
                    
                    if (self.bm3.count  > 350) {
                        [self writedistancetoCSVFile:self.bm3];

                        self.bm3 = [[NSMutableArray alloc] init];

                    }
                    
                }
                
                if (abeacon.minor.intValue == 4) {
                    minorD = abeacon.minor;
                    DistD = abeacon.accuracy;
                    proximityD = [self getBeaconProximity:abeacon];
                    DistDAcc =abeacon.rssi;
                    DistDTest = [self calculateAccuracyWithRssi:abeacon.rssi forMinor:abeacon.minor];
                    
                    if (!self.bm4) {
                        self.bm4 = [[NSMutableArray alloc] init];
                        [self.bm4 addObject:@"ibeacon minor"];
                        [self.bm4 addObject:@"accuracy"];
                        [self.bm4 addObject:@"proximity"];
                        [self.bm4 addObject:@"RSSI"];
                        [self.bm4 addObject:@"Calbration"];
                        
                    }
                    
                    [self.bm4 addObject:[minorD stringValue]];
                    [self.bm4 addObject:[[NSNumber numberWithDouble:DistD] stringValue]];
                    [self.bm4 addObject:proximityD];
                    [self.bm4 addObject:[[NSNumber numberWithInteger:DistDAcc] stringValue ]];
                    [self.bm4 addObject:[[NSNumber numberWithDouble:DistDTest] stringValue]];
                    
                    
                    if (self.bm4.count  > 350) {
                        [self writedistancetoCSVFile:self.bm4];

                        self.bm4 = [[NSMutableArray alloc] init];

                    }
                    
                }
                
                if (abeacon.minor.intValue == 5) {
                    minorE = abeacon.minor;
                    DistE = abeacon.accuracy;
                    proximityE = [self getBeaconProximity:abeacon];
                    DistEAcc =abeacon.rssi;
                    DistETest = [self calculateAccuracyWithRssi:abeacon.rssi forMinor:abeacon.minor];
                    
                    if (!self.bm5) {
                        self.bm5 = [[NSMutableArray alloc] init];
                        [self.bm5 addObject:@"ibeacon minor"];
                        [self.bm5 addObject:@"accuracy"];
                        [self.bm5 addObject:@"proximity"];
                        [self.bm5 addObject:@"RSSI"];
                        [self.bm5 addObject:@"Calbration"];
                        
                    }
                    
                    [self.bm5 addObject:[minorE stringValue]];
                    [self.bm5 addObject:[[NSNumber numberWithDouble:DistE] stringValue]];
                    [self.bm5 addObject:proximityE];
                    [self.bm5 addObject:[[NSNumber numberWithInteger:DistEAcc] stringValue ]];
                    [self.bm5 addObject:[[NSNumber numberWithDouble:DistETest] stringValue]];
                    
                    
                    if (self.bm5.count  > 350) {
                        [self writedistancetoCSVFile:self.bm5];

                        self.bm5 = [[NSMutableArray alloc] init];

                    }
                    
                }
                
                if (abeacon.minor.intValue == 6) {
                    minorF = abeacon.minor;
                    DistF = abeacon.accuracy;
                    proximityF = [self getBeaconProximity:abeacon];
                    DistFAcc =abeacon.rssi;
                    DistFTest = [self calculateAccuracyWithRssi:abeacon.rssi forMinor:abeacon.minor];
                    
                    if (!self.bm6) {
                        self.bm6 = [[NSMutableArray alloc] init];
                        [self.bm6 addObject:@"ibeacon minor"];
                        [self.bm6 addObject:@"accuracy"];
                        [self.bm6 addObject:@"proximity"];
                        [self.bm6 addObject:@"RSSI"];
                        [self.bm6 addObject:@"Calbration"];
                        
                    }
                    
                    [self.bm6 addObject:[minorF stringValue]];
                    [self.bm6 addObject:[[NSNumber numberWithDouble:DistF] stringValue]];
                    [self.bm6 addObject:proximityF];
                    [self.bm6 addObject:[[NSNumber numberWithInteger:DistFAcc] stringValue ]];
                    [self.bm6 addObject:[[NSNumber numberWithDouble:DistFTest] stringValue]];
                    
                    
                    if (self.bm6.count  > 350) {
                        [self writedistancetoCSVFile:self.bm6];

                        self.bm6 = [[NSMutableArray alloc] init];

                    }
                    
                }
                
                if (abeacon.minor.intValue == 7) {
                    minorG = abeacon.minor;
                    DistG = abeacon.accuracy;
                    proximityG = [self getBeaconProximity:abeacon];
                    DistGAcc =abeacon.rssi;
                    DistGTest = [self calculateAccuracyWithRssi:abeacon.rssi forMinor:abeacon.minor];
                    
                    if (!self.bm7) {
                        self.bm7 = [[NSMutableArray alloc] init];
                        [self.bm7 addObject:@"ibeacon minor"];
                        [self.bm7 addObject:@"accuracy"];
                        [self.bm7 addObject:@"proximity"];
                        [self.bm7 addObject:@"RSSI"];
                        [self.bm7 addObject:@"Calbration"];
                        
                    }
                    
                    [self.bm7 addObject:[minorG stringValue]];
                    [self.bm7 addObject:[[NSNumber numberWithDouble:DistG] stringValue]];
                    [self.bm7 addObject:proximityG];
                    [self.bm7 addObject:[[NSNumber numberWithInteger:DistGAcc] stringValue ]];
                    [self.bm7 addObject:[[NSNumber numberWithDouble:DistGTest] stringValue]];
                    
                    
                    if (self.bm7.count  > 350) {
                        [self writedistancetoCSVFile:self.bm7];

                        self.bm7 = [[NSMutableArray alloc] init];
                    }
                    
                }
            }
        
            

    }
    
    
    
}

@end
