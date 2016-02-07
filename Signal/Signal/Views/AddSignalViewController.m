//
//  AddSignalViewController.m
//  Signal
//
//  Created by Sam Son on 2/3/16.
//  Copyright © 2016 zdzdz. All rights reserved.
//

#import "AddSignalViewController.h"

@interface AddSignalViewController()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *ctegoryPicker;
@property (weak, nonatomic) IBOutlet UITextField *imageField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;

@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *country;

- (IBAction)getCoordinates:(UIButton *)sender;
- (IBAction)pickFile:(UIButton *)sender;

@end

@implementation AddSignalViewController{
    CLGeocoder *_geocoder;
    CLPlacemark *_placemark;
    CLLocationManager *_locationManager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cameraBarButton =
    [[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
     target:self
     action:@selector(showCameraButton)];
    
    self.title = @"Add a signal";
    self.navigationItem.rightBarButtonItem = cameraBarButton;
    
    self.textView.layer.borderWidth = 1.f;
    self.textView.layer.borderColor = [UIColor colorWithRed:0.765 green:0.78 blue:0.78 alpha:1].CGColor;
    self.textView.layer.cornerRadius = 6;
}

-(void) showCameraButton {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Device has no camera"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
        }];
        
        [alert addAction:defaultAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
//    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
//    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pickFile:(UIButton *)sender {
}

- (IBAction)getCoordinates:(UIButton *)sender {
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
            
            self.locationField.text = [NSString stringWithFormat:@"%@, %@", self.latitude, self.longitude];
            
        } else {
            [self showAlertWithTitle:@"Error" andMessage:[error localizedDescription]];
        }
        [manager stopUpdatingLocation];
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [self showAlertWithTitle:@"Error" andMessage:[error localizedDescription]];
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
