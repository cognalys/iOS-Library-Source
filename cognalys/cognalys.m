//
//  cognalys.m
//  cognalys
//
//  Created by Neeraj Apps on 08/07/15.
//  Copyright (c) 2015. Ltd. All rights reserved.
//

#import "cognalys.h"
#import "UNIRest.h"
#import "JSON.h"
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@interface cognalys ()
@property(nonatomic,retain) NSString*        status;
@property(nonatomic,retain) NSString*        keymatch;
@property(nonatomic,retain) NSString*        mobile;
@property(nonatomic,retain) NSString*        otp_start;
@property(nonatomic,retain) NSString*        confirmationStatus;
@property(nonatomic,retain) NSString*        confirmationMessage;
@property(nonatomic,retain) CTCallCenter*    callCenter;
@property(nonatomic,retain) NSTimer*         timer;
@property(nonatomic,assign) int              retryCounter;
@end


@implementation cognalys

@synthesize delegate;
@synthesize status;
@synthesize keymatch;
@synthesize mobile;
@synthesize otp_start;
@synthesize confirmationStatus;
@synthesize access_token;
@synthesize app_ID;
@synthesize locationManager;
@synthesize Currentlatitude,Currentlongitude;
@synthesize confirmationMessage;
@synthesize currentDevice;
@synthesize model;
@synthesize systemVersion;
@synthesize DeviceId;
@synthesize getLocation;
@synthesize callCenter;

id mainClass;

@synthesize retryCounter;
- (id) init
{
    if (self = [super init])
    {
        
        
        
       
        
        [self initGPS];
        
        [self initCoreTelephony];
        
        
        
        mainClass=self;
        
        self.retryCounter=10;
        
       
        
    }
    return self;
}


-(void)initCoreTelephony
{
    
  
     __weak typeof(self) weakSelf = self;
    
    self.callCenter = [[CTCallCenter alloc] init];
    [self.callCenter setCallEventHandler:^(CTCall *call)
     {
         NSLog(@"Event handler called");
         
         if ([call.callState isEqualToString: CTCallStateConnected])
         {
             
             NSLog(@"Connected");
             dispatch_async(dispatch_get_main_queue(), ^{
                 
             });
             
         }
         else if ([call.callState isEqualToString: CTCallStateDialing])
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                
                 
             });
             
             NSLog(@"CTCallStateDialing");
             
         }
         else if ([call.callState isEqualToString: CTCallStateDisconnected])
         {
             
           NSLog(@"Disconnected");
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 
             });
             
             
         } else if ([call.callState isEqualToString: CTCallStateIncoming])
         {
             
              NSLog(@"connected successfullu >>>>>>>>>>>>>>>>>>>>>>");
              dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                
                 [weakSelf sendReceivedMiscallMessageToDelegate];
                 
                 [weakSelf.delegate cog_APISuccessAndReceivedMiscall];

             });
            
             
         }
     }];

}

-(void)sendReceivedMiscallMessageToDelegate
{
    
    

    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        self.retryCounter=10;
        
       
            [self.timer invalidate];
            self.timer = nil;
        
        
       
    
    // [delegate cog_APISuccessAndReceivedMiscall];
        
        });
    
}


/* ***************************************************************
 * **********------> initGPS  <------------------------------------**
 * Function to initiate GPS tracking upon API initialization
 * ******************---------------------------------------------***
 * ***************************************************************/
-(void)initGPS
{
    //self.getLocation=TRUE;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    NSLog(@"%d",[CLLocationManager authorizationStatus]);
    
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
    {
        if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
 
    
    [self.locationManager startUpdatingLocation];
    
    
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        // This is will run if it is iOS6
        self.DeviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else {
        // This is will run before iOS6 and you can use openUDID or other
        // method to generate an identifier
        
        self.DeviceId=@"";
    }
    
    
    
    
    UIDevice *currentDevice1 = [UIDevice currentDevice];
    NSString *model1 = [currentDevice1 model];
    NSString *systemVersion1 = [currentDevice1 systemVersion];
    
    
    //self.currentDevice = [UIDevice currentDevice];
    self.model = model1;
    self.systemVersion = systemVersion1;
    
   
}


/* ***************************************************************
 * **********------> didUpdateLocations  <------------------------------------**
 * Receives each location updates of the device
 * ******************---------------------------------------------***
 * ***************************************************************/
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self locationManager:locationManager didUpdateLocations:[[NSArray alloc] initWithObjects:newLocation, nil]];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations objectAtIndex:0];
    NSString *latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    
    NSLog(@"here Latitude : %@", latitude);
    NSLog(@"here Longitude : %@",longitude);
    
    self.Currentlatitude=[NSString stringWithFormat:@"%@",latitude];
    self.Currentlongitude=[NSString stringWithFormat:@"%@",longitude];
    
}


-(void)initiateAPIWithMobileNumber:(NSString *) mobileNumber
{
    [delegate getLog:@" ------------------------ > initiateAPIWithMobileNumber"];
    
    
    [self initCoreTelephony];
    
    mainClass=self;
    
    if ([self.timer isValid]) {
        
        [self.timer invalidate];
        self.timer = nil;
    }
    
    
    
    if ([self.model length]==0 || self.model==[NSNull null]) {
        
        self.model=@"";
    }
    if ([self.systemVersion length]==0 || self.systemVersion==[NSNull null]) {
        
        self.systemVersion=@"";
    }
    if ([self.Currentlatitude length]==0 || self.Currentlatitude==[NSNull null]) {
        
        self.Currentlatitude=@"";
    }
    if ([self.Currentlongitude length]==0 || self.Currentlongitude==[NSNull null]) {
        
        self.Currentlongitude=@"";
    }
    if ([self.DeviceId length]==0 || self.DeviceId==[NSNull null]) {
        
        self.DeviceId=@"";
    }

    
    
    NSDictionary *headers = @{@"Cognalys": @"objectivec"};
    UNIUrlConnection *asyncConnection = [[UNIRest get:^(UNISimpleRequest *request) {
       
        if (self.getLocation==TRUE) {
            
           
            
             [request setUrl:[NSString stringWithFormat:@"https://www.cognalys.com/api/v1/otp/ios?access_token=%@&app_id=%@&mobile=%@&deviceModel=%@&systemVersion=%@&lattitude=%@&longitude=%@&deviceID=%@",self.access_token,self.app_ID,mobileNumber,self.model,self.systemVersion,self.Currentlatitude,self.Currentlongitude,self.DeviceId]];
            
           // [request setUrl:[NSString stringWithFormat:@"https://www.cognalys.com/api/v1/otp/?access_token=%@&app_id=%@&mobile=%@&deviceModel=%@&systemVersion=%@&lattitude=%@&longitude=%@&deviceID=%@",self.access_token,self.app_ID,mobileNumber,self.model,self.systemVersion,self.Currentlatitude,self.Currentlongitude,self.DeviceId]];
        }
        else
        {
             [request setUrl:[NSString stringWithFormat:@"https://www.cognalys.com/api/v1/otp/ios?access_token=%@&app_id=%@&mobile=%@&deviceModel=%@&systemVersion=%@&deviceID=%@",self.access_token,self.app_ID,mobileNumber,self.model,self.systemVersion,self.DeviceId]];
           // [request setUrl:[NSString stringWithFormat:@"https://www.cognalys.com/api/v1/otp/?access_token=%@&app_id=%@&mobile=%@&deviceModel=%@&systemVersion=%@&deviceID=%@",self.access_token,self.app_ID,mobileNumber,self.model,self.systemVersion,self.DeviceId]];
        }
        
        
       
        
        [request setHeaders:headers];
       
        
    }] asJsonAsync:^(UNIHTTPJsonResponse *response, NSError *error) {
        
        
        NSInteger code = response.code;
        NSDictionary *responseHeaders = response.headers;
        UNIJsonNode *body = response.body;
        NSData *rawBody = response.rawBody;
        
        
        NSLog(@"response headers : %@",responseHeaders);
        
        NSString *responseString = [[NSString alloc] initWithData:rawBody encoding:NSUTF8StringEncoding];
        
        
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: nil];
        
        NSLog(@"%@",dict);
        
        
        
        
        NSLog(@"%@",[dict valueForKey:@"status"]);
        NSLog(@"%@",[dict valueForKey:@"keymatch"]);
        NSLog(@"%@",[dict valueForKey:@"mobile"]);
        NSLog(@"%@",[dict valueForKey:@"otp_start"]);
        
        
        [[NSUserDefaults standardUserDefaults]setValue:[dict valueForKey:@"keymatch"] forKey:@"keymatch"];
        
        self.status =[dict valueForKey:@"status"];
        
        if ([self.status isEqualToString:@"success"]) {
            
            self.keymatch =[dict valueForKey:@"keymatch"];
            self.mobile =[dict valueForKey:@"mobile"];
            self.otp_start =[dict valueForKey:@"otp_start"];
            
            
            
            
            [delegate cog_CallConnectedSuccessNotif:dict];
            
            
            
            if (self.canRetryVerification==YES) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.canRetryVerification=NO;
                    
                    
                    NSTimer *theTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownTracker:) userInfo:nil repeats:YES];
                    // Assume a there's a property timer that will retain the created timer for future reference.
                    
                    
                    [[NSRunLoop currentRunLoop] addTimer:theTimer forMode:NSRunLoopCommonModes];
    
                    self.timer = theTimer;
                    
            
                    
              
                    
                });
                
              
            }
            else
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
               
                    NSTimer *theTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(sendRetryFailMessageToDelegate) userInfo:nil repeats:NO];
               
                    [[NSRunLoop currentRunLoop] addTimer:theTimer forMode:NSRunLoopCommonModes];
                    
                    self.timer = theTimer;
                });
              
                
                
            }
            
            
        }
        else
        {
            
            [delegate cog_CallConnectedErrorNotif:dict];
            
            self.keymatch =@"";
            self.mobile =@"";
            self.otp_start =@"";
            
           
        }
        
        
        
        
    }];
}
-(void)sendRetryFailMessageToDelegate
{
    [delegate mobileVerificationRetryFailedWithMessage:@"Retry failed"];
}

- (void)countdownTracker:(NSTimer *)theTimer {
    
    [delegate getLog:[NSString stringWithFormat:@"%d",self.retryCounter]];
    
    self.retryCounter--;
    if (self.retryCounter < 0) {
        
        
        
            
        [delegate mobileVerificationRetryWithMessage:[NSString stringWithFormat:@"Started retry verification after %d seconds",self.retryCounter]];
    
        
        [self.timer invalidate];
        self.timer = nil;
        self.retryCounter=10;
        
        [self initiateAPIWithMobileNumber:self.mobile];
        
       
        
        
        
        
    }
}

-(void)verifyOTP_withNumberCopyedFromTheLog:(NSString *) mobileNumber
{
    
    NSString *keyMatch=[[NSUserDefaults standardUserDefaults]valueForKey:@"keymatch"];
    
    
    
    
    if ([self.model length]==0 || self.model==[NSNull null]) {
        
        self.model=@"";
    }
    if ([self.systemVersion length]==0 || self.systemVersion==[NSNull null]) {
        
        self.systemVersion=@"";
    }
    if ([self.Currentlatitude length]==0 || self.Currentlatitude==[NSNull null]) {
        
        self.Currentlatitude=@"";
    }
    if ([self.Currentlongitude length]==0 || self.Currentlongitude==[NSNull null]) {
        
        self.Currentlongitude=@"";
    }
    if ([self.DeviceId length]==0 || self.DeviceId==[NSNull null]) {
        
        self.DeviceId=@"";
    }
    
    
    // These code snippets use an open-source library. http://unirest.io/objective-c
    NSDictionary *headers = @{@"Cognalys": @"objctivec"};
    UNIUrlConnection *asyncConnection = [[UNIRest get:^(UNISimpleRequest *request) {
     
        
            NSString *urlString=[NSString string];
        
        if (self.getLocation==TRUE) {

            urlString=[NSString stringWithFormat:@"https://www.cognalys.com/api/v1/otp/ios/confirm/?access_token=%@&app_id=%@&otp=%@&keymatch=%@&deviceModel=%@&systemVersion=%@&lattitude=%@&longitude=%@&deviceID=%@",self.access_token,self.app_ID,mobileNumber,keyMatch,self.model,self.systemVersion,self.Currentlatitude,self.Currentlongitude,self.DeviceId];
            
        [request setUrl:[NSString stringWithFormat:@"https://www.cognalys.com/api/v1/otp/ios/confirm/?access_token=%@&app_id=%@&otp=%@&keymatch=%@&deviceModel=%@&systemVersion=%@&lattitude=%@&longitude=%@&deviceID=%@",self.access_token,self.app_ID,mobileNumber,keyMatch,self.model,self.systemVersion,self.Currentlatitude,self.Currentlongitude,self.DeviceId]];
            
          //  [request setUrl:[NSString stringWithFormat:@"https://www.cognalys.com/api/v1/otp/confirm/?access_token=%@&app_id=%@&otp=%@&keymatch=%@&deviceModel=%@&systemVersion=%@&lattitude=%@&longitude=%@&deviceID=%@",self.access_token,self.app_ID,mobileNumber,keyMatch,self.model,self.systemVersion,self.Currentlatitude,self.Currentlongitude,self.DeviceId]];
            
        }
        else
        {
            urlString=[NSString stringWithFormat:@"https://www.cognalys.com/api/v1/otp/ios/confirm/?access_token=%@&app_id=%@&otp=%@&keymatch=%@&deviceModel=%@&systemVersion=%@&deviceID=%@",self.access_token,self.app_ID,mobileNumber,keyMatch,self.model,self.systemVersion,self.DeviceId];
            
            [request setUrl:[NSString stringWithFormat:@"https://www.cognalys.com/api/v1/otp/ios/confirm/?access_token=%@&app_id=%@&otp=%@&keymatch=%@&deviceModel=%@&systemVersion=%@&deviceID=%@",self.access_token,self.app_ID,mobileNumber,keyMatch,self.model,self.systemVersion,self.DeviceId]];
            
           // [request setUrl:[NSString stringWithFormat:@"https://www.cognalys.com/api/v1/otp/confirm/?access_token=%@&app_id=%@&otp=%@&keymatch=%@&deviceModel=%@&systemVersion=%@&deviceID=%@",self.access_token,self.app_ID,mobileNumber,keyMatch,self.model,self.systemVersion,self.DeviceId]];
        }
        
               
        
       // [delegate getLog:urlString];
        
        [request setHeaders:headers];
    }] asJsonAsync:^(UNIHTTPJsonResponse *response, NSError *error) {
        NSInteger code = response.code;
        NSDictionary *responseHeaders = response.headers;
        UNIJsonNode *body = response.body;
        NSData *rawBody = response.rawBody;
        
        
        NSString *responseString = [[NSString alloc] initWithData:rawBody encoding:NSUTF8StringEncoding];
        
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: nil];
        
        NSLog(@"%@",[dict valueForKey:@"status"]);
        
//        if ([[dict valueForKey:@"status"] isKindOfClass:[NSNumber class]]) {
//            
//            
//        }
        
        self.confirmationStatus=[dict valueForKey:@"status"];
        
     
        if ([self.confirmationStatus isEqualToString:@"success"]) {
            
            self.confirmationMessage=[dict valueForKey:@"message"];
            
            
            
            [delegate cog_OTPVerificationSuccessNotif:dict];
            
        }
        else
        {
            [delegate cog_OTPVerificationErrorNotif:dict];
            
            NSString *errorMessage=[[dict valueForKey:@"errors"]valueForKey:@"ERROR_CODE"];
            
        }
        
        
        
        //#################################################
        //############################## Clearing stored values
        
//        self.access_token=@"";
//        self.app_ID=@"";
//        self.self.keymatch=@"";
        
        //#################################################
        //#################################################
        //#################################################
        
        
    }];
}



@end
