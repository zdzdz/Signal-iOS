//
//  AddSignalViewController.m
//  Signal
//
//  Created by Sam Son on 2/3/16.
//  Copyright © 2016 zdzdz. All rights reserved.
//
#import <CoreData/CoreData.h>

#import "AddSignalViewController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"

@interface AddSignalViewController()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *categoryPicker;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UILabel *chooseLabel;

@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) UIImage *picture;
@property(nonatomic,readonly) NSManagedObjectContext *managedContext;
@property (strong, nonatomic) NSArray *pickerData;
@property (strong, nonatomic) NSString *category;

- (IBAction)getCoordinates:(UIButton *)sender;
- (IBAction)pickFile:(UIButton *)sender;
- (IBAction)addSignal:(UIButton *)sender;

@end

@implementation AddSignalViewController{
    CLGeocoder *_geocoder;
    CLPlacemark *_placemark;
    CLLocationManager *_locationManager;
    NSString *_currentUser;
    NSData *_imageData;
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
    
    self.pickerData = [NSArray arrayWithObjects:@"Choose", @"Accident",@"Crime", @"For repair", @"Danger", @"Speeding", @"Other", nil];
    
    self.categoryPicker.dataSource = self;
    self.categoryPicker.delegate = self;
    
    self.textView.layer.borderWidth = 1.f;
    self.textView.layer.borderColor = [UIColor colorWithRed:0.765 green:0.78 blue:0.78 alpha:1].CGColor;
    self.textView.layer.cornerRadius = 6;
    self.chooseLabel.layer.borderWidth = 1.f;
    self.chooseLabel.layer.borderColor = [UIColor colorWithRed:0.765 green:0.78 blue:0.78 alpha:1].CGColor;
    self.chooseLabel.layer.cornerRadius = 6;
    
    //Opening sqlite db
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Profile" inManagedObjectContext:self.managedContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [self.managedContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *userName in fetchedObjects) {
        _currentUser = [userName valueForKey:@"name"];
    }
}

-(NSManagedObjectContext*)managedContext{
    NSManagedObjectContext *managedContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    return managedContext;
}

-(NSString*) getDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    
    NSString *stringFromDate = [formatter stringFromDate:[[NSDate alloc] init]];
    
    return stringFromDate;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerData.count;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *lbTitle = [[UILabel alloc] init];
    [lbTitle setText:[NSString stringWithFormat:@"%@", self.pickerData[row]]];
    [lbTitle setFont:[UIFont fontWithName:@"Arial" size:17.0]];
    [lbTitle setTextAlignment:NSTextAlignmentCenter];
    
    return lbTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    switch(row) {
        case 1:
            self.category = @"Accident";
            break;
        case 2:
            self.category = @"Crime";
            break;
        case 3:
            self.category = @"For repair";
            break;
        case 4:
            self.category = @"Danger";
            break;
        case 5:
            self.category = @"Speeding";
            break;
        case 6:
            self.category = @"Other";
            break;
        default:
            self.category = @"Unknown";
    }
}

-(void) showCameraButton {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    } else {
        [self showAlertWithTitle:@"Error" andMessage:@"Device has no camera"];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    self.picture = chosenImage;
    self.chooseLabel.text = @"DONE";
    self.chooseLabel.textColor = [UIColor colorWithRed:0.541 green:0.812 blue:0 alpha:1];
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
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)addSignal:(UIButton *)sender {
    
    if (self.titleTextField.text.length == 0 || self.textView.text.length == 0) {
        [self showAlertWithTitle:@"Warning" andMessage:@"You have insert a title and description."];
    } else if([self category].length == 0){
        [self showAlertWithTitle:@"Warning" andMessage:@"Please choose a category"];
    }
    else {
        if(self.picture == nil){
            _imageData = UIImagePNGRepresentation([UIImage imageNamed:@"no-foto"]);
        } else {
            _imageData = UIImagePNGRepresentation(self.picture);
        }
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data: _imageData];
        
        PFObject *signal = [PFObject objectWithClassName:@"Signal"];
        signal[@"title"] = self.titleTextField.text;
        signal[@"category"] = [self category];
        signal[@"description"] = self.textView.text;
        signal[@"latitude"] = self.latitude;
        signal[@"longitude"] = self.longitude;
        signal[@"username"] = _currentUser;
        signal[@"addedOn"] = [self getDate];
        signal[@"picture"] = imageFile;
        
        [self showLoader];
        [signal pinInBackground];
        [signal saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (succeeded) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [signal saveEventually];
                NSString *errorString = [error userInfo][@"error"];
                [self showAlertWithTitle:@"Error" andMessage:errorString];
            }
        }];
    }
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

-(void) showLoader{
    [self.view setUserInteractionEnabled:NO];
    UIActivityIndicatorView *loader = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    loader.center = self.view.center;
    loader.transform = CGAffineTransformMakeScale(1.5, 1.5);
    loader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:loader];
    [loader startAnimating];
}
@end
