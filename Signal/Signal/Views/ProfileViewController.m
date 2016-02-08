//
//  ProfileViewController.m
//  Signal
//
//  Created by Sam Son on 2/7/16.
//  Copyright © 2016 zdzdz. All rights reserved.
//
#import <CoreData/CoreData.h>

#import "ProfileViewController.h"

#import "Parse/Parse.h"
#import "AppDelegate.h"

#import "Signal.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UITableView *signalsTable;

@property(nonatomic,readonly) NSManagedObjectContext *managedContext;
@property(nonatomic,strong) NSMutableArray *fetchedData;

- (IBAction)changeProfilePic:(UIButton *)sender;

@end

@implementation ProfileViewController{
    NSString *_currentUser;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    self.usernameLabel.text = _currentUser;
    
    self.signalsTable.delegate = self;
    self.signalsTable.dataSource = self;
    
    
    PFQuery *dataQuery = [PFQuery queryWithClassName:@"Signal"];
    [dataQuery whereKey:@"username" containsString:_currentUser];
    [dataQuery fromLocalDatastore];
    [dataQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.fetchedData = [[NSMutableArray alloc] initWithArray:objects];
        [self.signalsTable reloadData];
    }];
    
    PFQuery *imageQuery = [PFQuery queryWithClassName:@"ProfilePicture"];
    [imageQuery whereKey:@"userName" containsString:_currentUser];
    [imageQuery getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (!object) {
            
        }
        
        PFFile *imageFile = object[@"picture"];
        
        [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (!error) {
                self.profilePicture.image = [UIImage imageWithData:data];
            }
        }];
    }];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Profile";
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [self.profilePicture setUserInteractionEnabled:YES];
    [self.profilePicture addGestureRecognizer:singleTap];
    
}

-(NSManagedObjectContext*)managedContext{
    NSManagedObjectContext *managedContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    return managedContext;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapDetected{
    if (self.editButton.hidden == YES) {
        self.editButton.hidden = NO;
        [UIView animateWithDuration:2.0
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^ {
                             self.editButton.alpha = 1.0;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    } else {
        [UIView animateWithDuration:1.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^ {
                             self.editButton.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             self.editButton.hidden = YES;
                         }];
    }
}


- (IBAction)changeProfilePic:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.editButton.hidden = YES;
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    NSData *imageData = UIImagePNGRepresentation(chosenImage);
    
    PFFile *imageFile = [PFFile fileWithName:@"photo.png" data: imageData];
    
    PFQuery *query = [PFQuery queryWithClassName:@"ProfilePicture"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count == 1) {
            [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj[@"picture"] = imageFile;
                [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        self.profilePicture.image = chosenImage;
                        [picker dismissViewControllerAnimated:YES completion:NULL];
                    }
                }];
            }];
        } else {
            PFObject *profilePic = [PFObject objectWithClassName:@"ProfilePicture"];
            profilePic[@"picture"] = imageFile;
            profilePic[@"userName"] = _currentUser;
            
            
            [profilePic saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                if (succeeded) {
                    self.profilePicture.image = chosenImage;
                    [picker dismissViewControllerAnimated:YES completion:NULL];
                } else {
                    [profilePic saveEventually];
                    NSString *errorString = [error userInfo][@"error"];
                    [self showAlertWithTitle:@"Error" andMessage:errorString];
                }
            }];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fetchedData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    PFObject *fetchedSignal = [self.fetchedData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@    %@", [fetchedSignal objectForKey:@"title"], [fetchedSignal objectForKey:@"addedOn"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFObject *fetchedSignal = [self.fetchedData objectAtIndex:indexPath.row];
        [fetchedSignal deleteInBackground];
        [self.fetchedData removeObjectAtIndex:indexPath.row];
        [self.signalsTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    }
}

-(void) showLoader{
    [self.view setUserInteractionEnabled:NO];
    UIActivityIndicatorView *loader = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    loader.center = self.view.center;
    loader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:loader];
    [loader startAnimating];
}
@end
