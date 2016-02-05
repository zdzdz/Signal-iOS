//
//  SignalTableViewController.m
//  Signal
//
//  Created by Sam Son on 2/3/16.
//  Copyright © 2016 zdzdz. All rights reserved.
//
#import <CoreData/CoreData.h>

#import "SignalTableViewController.h"
#import "Parse/Parse.h"

#import "AddSignalViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"

#import "SideDrawerHeaderView.h"

#import "AppDelegate.h"

@interface SignalTableViewController()
@property(nonatomic,readonly) NSManagedObjectContext *managedContext;
@property (weak, nonatomic) IBOutlet UIButton *buttonName;

- (IBAction)LogOut:(UIButton *)sender;

@property (nonatomic,strong) TKSideDrawerView *sideDrawerView;
@property (nonatomic, strong) UINavigationItem *navItem;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UITextField *searchField;
@end

@implementation SignalTableViewController{
    NSString *currentName;
    UIView *_pageView;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationItem setHidesBackButton:YES];
    
    @try{
        NSArray *viewControllers = self.navigationController.viewControllers;
        UIViewController *rootViewController = (UIViewController *)[viewControllers objectAtIndex:viewControllers.count - 2];
        
        
        if([rootViewController isKindOfClass:[RegisterViewController class]]){
            [self showAlert:@"Welcome" :@"You have successfully registered."];
        }
    } @catch(NSException *exception){
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *addBarButton =
    [[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
     target:self
     action:@selector(showAddButton)];
    
    self.title = @"All Signals";
    self.navigationItem.rightBarButtonItem = addBarButton;
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Profile" inManagedObjectContext:self.managedContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [self.managedContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *userName in fetchedObjects) {
        currentName = [userName valueForKey:@"name"];
        [self.buttonName setTitle:[userName valueForKey:@"name"] forState: UIControlStateNormal];
    }

    _pageView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _pageView.backgroundColor = [UIColor purpleColor];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    self.sideDrawerView = [[TKSideDrawerView alloc] initWithFrame:self.view.bounds];
    
    [self.sideDrawerView.mainView addSubview:_pageView];
    self.sideDrawerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_sideDrawerView];
    
//    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.sideDrawerView.mainView.bounds];
//    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    backgroundView.backgroundColor = [UIColor blackColor];
//    [self.sideDrawerView.mainView addSubview:backgroundView];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.sideDrawerView.mainView.bounds), 55)];
    _navItem = [[UINavigationItem alloc] init];
    _navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(showSideDrawer)];
    navBar.items = @[_navItem];
    navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.sideDrawerView.mainView addSubview:navBar];
    
    TKSideDrawer *sideDrawer = self.sideDrawer;
    sideDrawer.style.shadowMode = TKSideDrawerShadowModeSideDrawer;
    sideDrawer.fill = [TKSolidFill solidFillWithColor:[UIColor grayColor]];
    sideDrawer.title = @"Be active!";
    sideDrawer.autoresizesSubviews = YES;
    sideDrawer.transition = TKSideDrawerTransitionTypePush;
    sideDrawer.delegate = self;
    
    TKSideDrawerSection *section = [sideDrawer addSectionWithTitle:[NSString stringWithFormat:@"Hello, %@", currentName]];
    [section addItemWithTitle:@"Profile"];
    [section addItemWithTitle:@"About"];
    
    section = [sideDrawer addSectionWithTitle:@"Exit"];
    [section addItemWithTitle:@"Log out"];
    
    [self addSearchBarWithTitle:@"Search" target:self selector:@selector(showSideDrawer)];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _sideDrawerView.frame = CGRectMake(0, 55, CGRectGetWidth(self.view.bounds), self.view.bounds.size.height - 55);
    _pageView.frame = CGRectMake(0, 44, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.sideDrawerView.mainView.bounds) - 44);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)showSideDrawer
{
    [self.sideDrawer show];
}

- (void)dismissSideDrawer
{
    [self.sideDrawer dismiss];
}

- (TKSideDrawer *)sideDrawer
{
    return _sideDrawerView.defaultSideDrawer;
}

-(void)sideDrawer:(TKSideDrawer *)sideDrawer didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"Selected item in section: %d at index: %d", (int)indexPath.section, (int)indexPath.row);
    if ((int)indexPath.section == 1 && (int)indexPath.row == 0){
        [PFUser logOut];
        NSString *storyBoardId = @"LoginScreen";
        
        LoginViewController *loginVC =
        [self.storyboard instantiateViewControllerWithIdentifier:storyBoardId];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

-(void) showAddButton {
    NSString *storyBoardId = @"AddSignal";
    
    AddSignalViewController *addSignalVC =
    [self.storyboard instantiateViewControllerWithIdentifier:storyBoardId];
    [self.navigationController pushViewController:addSignalVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LogOut:(UIButton *)sender {
    [PFUser logOut];
    NSString *storyBoardId = @"LoginScreen";
    
    LoginViewController *loginVC =
    [self.storyboard instantiateViewControllerWithIdentifier:storyBoardId];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void) showAlert: (NSString*) title :(NSString*) message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }];
    
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(NSManagedObjectContext*)managedContext{
    NSManagedObjectContext *managedContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    return managedContext;
}

- (void)addSearchBarWithTitle:(NSString *)title target:(id)target selector:(SEL)selector
{
    CGSize titleSize = [title sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:18] }];
    self.searchButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - (titleSize.width + 5), 15, titleSize.width, 30)];
    self.searchButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.searchButton.layer setBorderWidth:1.0];
    [self.searchButton.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.searchButton.layer setCornerRadius:3.f];
    self.searchButton.backgroundColor = [UIColor colorWithRed:0.424 green:0.565 blue:0.592 alpha:1];
    [self.searchButton setTitle:title forState:UIControlStateNormal];
    [self.searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.searchButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [_pageView addSubview:self.searchButton];
    
    self.searchField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x + 50, 15, self.view.bounds.size.width - (self.searchButton.bounds.size.width + 70),30)];
    self.searchField.backgroundColor = [UIColor clearColor];
    self.searchField.placeholder = @"Search here";
    [self.searchField.layer setBorderWidth:1];
    [self.searchField.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.searchField.layer setCornerRadius:3];
    [_pageView addSubview:self.searchField];
    
    UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x + 15, 15, self.view.bounds.size.width - (self.searchButton.bounds.size.width + self.searchField.bounds.size.width + 40), 30)];
    [searchIcon setImage:[UIImage imageNamed:@"search"]];
    [_pageView addSubview:searchIcon];
}

#pragma mark TKSideDrawerDelegate

- (void)sideDrawer:(TKSideDrawer *)sideDrawer updateVisualsForItem:(NSInteger)item inSection:(NSInteger)section
{
    TKSideDrawerItem *currentItem = ((TKSideDrawerSection *)sideDrawer.sections[section]).items[item];
    currentItem.style.contentInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    currentItem.style.separatorColor = [TKSolidFill solidFillWithColor:[UIColor clearColor]];
}

- (void)sideDrawer:(TKSideDrawer *)sideDrawer updateVisualsForSection:(NSInteger)sectionIndex
{
    TKSideDrawerSection *section = sideDrawer.sections[sectionIndex];
    section.style.contentInsets = UIEdgeInsetsMake(0, -15, 0, 0);
}


@end
