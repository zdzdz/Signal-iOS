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
#import "Signal-Swift.h"

@interface SignalTableViewController()
@property(nonatomic,readonly) NSManagedObjectContext *managedContext;

@end

@implementation SignalTableViewController{
    NSString *_currentName;
    UIView *_pageView;
    UITableView *_tableView;
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
    
    //Opening sqlite db
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Profile" inManagedObjectContext:self.managedContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [self.managedContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *userName in fetchedObjects) {
        _currentName = [userName valueForKey:@"name"];
    }

    //Adding side drawer
    _pageView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _pageView.backgroundColor = [UIColor clearColor];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    self.sideDrawerView = [[TKSideDrawerView alloc] initWithFrame:self.view.bounds];
    
    [self.sideDrawerView.mainView addSubview:_pageView];
    self.sideDrawerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_sideDrawerView];
    
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
    sideDrawer.fill = [TKSolidFill solidFillWithColor:[UIColor colorWithRed:0.424 green:0.565 blue:0.592 alpha:1]];
    sideDrawer.width = 250;
    sideDrawer.transitionManager = [[PhysicsTransitionManager alloc] initWithSideDrawer:sideDrawer];
    sideDrawer.title = @"Be active!";
    sideDrawer.autoresizesSubviews = YES;
    //sideDrawer.transition = TKSideDrawerTransitionTypePush;
    sideDrawer.delegate = self;
    
    TKSideDrawerSection *section = [sideDrawer addSectionWithTitle:[NSString stringWithFormat:@"Hello, %@", _currentName]];
    [section addItemWithTitle:@"Profile"];
    [section addItemWithTitle:@"About"];
    
    section = [sideDrawer addSectionWithTitle:@"Exit"];
    [section addItemWithTitle:@"Log out"];
    
    //Adding search bar
    [self addSearchBarWithTitle:@"Search" target:self selector:@selector(showSideDrawer)];
    
    //Adding tableview
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchField.bounds.size.height + 10, self.view.bounds.size.width, self.view.bounds.size.height - (self.searchField.bounds.size.height + 140)) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.backgroundColor = [UIColor cyanColor];
    
    [_pageView addSubview:_tableView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _sideDrawerView.frame = CGRectMake(0, 55, CGRectGetWidth(self.view.bounds), self.view.bounds.size.height - 55);
    _pageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.sideDrawerView.mainView.bounds));
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
    self.searchButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - (titleSize.width + 10), 0, titleSize.width + 5, 30)];
    self.searchButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.searchButton.layer setBorderWidth:1.0];
    [self.searchButton.layer setBorderColor:[UIColor colorWithRed:0.541 green:0.565 blue:0.565 alpha:1].CGColor];
    [self.searchButton.layer setCornerRadius:3.f];
    self.searchButton.backgroundColor = [UIColor colorWithRed:0.424 green:0.565 blue:0.592 alpha:1];
    [self.searchButton setTitle:title forState:UIControlStateNormal];
    [self.searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.searchButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [_pageView addSubview:self.searchButton];
    
    self.searchField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x + 50, 0, self.view.bounds.size.width - (self.searchButton.bounds.size.width + 60),30)];
    self.searchField.backgroundColor = [UIColor clearColor];
    self.searchField.placeholder = @"Search here";
    [self.searchField.layer setBorderWidth:1];
    [self.searchField.layer setBorderColor:[UIColor colorWithRed:0.541 green:0.565 blue:0.565 alpha:1].CGColor];
    [self.searchField.layer setCornerRadius:3];
    [_pageView addSubview:self.searchField];
    
    UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x + 15, 0, self.view.bounds.size.width - (self.searchButton.bounds.size.width + self.searchField.bounds.size.width + 30), 30)];
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

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = @"Testing";
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected %ld row", indexPath.row);
}

@end
