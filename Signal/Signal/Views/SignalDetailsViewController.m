//
//  SignalDetailsViewController.m
//  Signal
//
//  Created by Sam Son on 2/6/16.
//  Copyright © 2016 zdzdz. All rights reserved.
//

#import "SignalDetailsViewController.h"
#import "Signal-Swift.h"

@interface SignalDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UITextView *mainTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateAddedLabel;

@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *country;

@property (weak, nonatomic) IBOutlet UITextField *numberLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailLabel;
- (IBAction)phoneButton:(UIButton *)sender;
- (IBAction)emailButton:(UIButton *)sender;
- (IBAction)gpsButton:(UIButton *)sender;

@end

@implementation SignalDetailsViewController{
    CLGeocoder *_geocoder;
    CLPlacemark *_placemark;
    CLLocationManager *_locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Details";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManager

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *newLocation = [locations lastObject];
    
    // 42.650874, 23.379293
    [_geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            _placemark = [placemarks lastObject];
            
            
            
            self.latitude = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
            self.longitude = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
            self.state = _placemark.administrativeArea;
            self.country = _placemark.country;
            
            NSString *storyBoardId = @"MapID";
            
            MapViewController *mapVC =
            [self.storyboard instantiateViewControllerWithIdentifier:storyBoardId];
            mapVC.latitude = self.latitude;
            mapVC.longitude = self.longitude;
            [self.navigationController pushViewController:mapVC animated:YES];
        } else {
            [self showAlertWithTitle:@"Error" andMessage:[error localizedDescription]];
        }
        [manager stopUpdatingLocation];
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [self showAlertWithTitle:@"Error" andMessage:[error localizedDescription]];
}


#pragma mark - IBAction

- (IBAction)phoneButton:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", self.numberLabel.text]]];
}

- (IBAction)emailButton:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", self.emailLabel.text]]];
}

- (IBAction)gpsButton:(UIButton *)sender {
    _geocoder = [[CLGeocoder alloc] init];
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.delegate  = self;
        _locationManager.distanceFilter = 500;
    }
    
    [_locationManager requestAlwaysAuthorization];
    
    [_locationManager startUpdatingLocation];
}


- (void) showAlertWithTitle: (NSString*) title andMessage:(NSString*) message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }];
    
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end
