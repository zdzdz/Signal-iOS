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
#import "SignalDetailsViewController.h"
#import "SignalCustomCell.h"
#import "AboutViewController.h"

#import "SideDrawerHeaderView.h"

#import "AppDelegate.h"
#import "Signal-Swift.h"

@interface SignalTableViewController()
@property(nonatomic,readonly) NSManagedObjectContext *managedContext;
@property(nonatomic,strong) SignalCustomCell *customCell;
@property(nonatomic,strong) UIButton *alertBtn;

@end

@implementation SignalTableViewController{
    NSString *_currentUser;
    UIView *_pageView;
    UITableView *_tableView;
    NSArray *_items;
    UINavigationItem *_navItem;
    UIDynamicAnimator *_animator;
    UIGravityBehavior *_gravity;
    UICollisionBehavior *_collision;
    UIDynamicItemBehavior *_itemBehaviour;
    UIButton *holder;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationItem setHidesBackButton:YES];
    
    @try{
        NSArray *viewControllers = self.navigationController.viewControllers;
        UIViewController *rootViewController = (UIViewController *)[viewControllers objectAtIndex:viewControllers.count - 2];
        
        
        if([rootViewController isKindOfClass:[RegisterViewController class]]){
            [self showAlertWithTitle:@"Welcome" andMessage:@"You have successfully registered."];
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
    //self.navigationItem.rightBarButtonItem = addBarButton;
    
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
    _navItem.title = @"Be active!";
    _navItem.rightBarButtonItem = addBarButton;
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
    
    TKSideDrawerSection *section = [sideDrawer addSectionWithTitle:[NSString stringWithFormat:@"Hello, %@", _currentUser]];
    [section addItemWithTitle:@"Profile"];
    [section addItemWithTitle:@"About"];
    
    section = [sideDrawer addSectionWithTitle:@"Exit"];
    [section addItemWithTitle:@"Log out"];

    //Swipe gesture detection
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showSideDrawer)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.sideDrawerView.mainView addGestureRecognizer:rightSwipeGestureRecognizer];
    
    //Adding search bar
    [self addSearchBarWithTitle:@"Search" target:self selector:@selector(showSideDrawer)];
    
    //Adding tableview
    
    _items = [[NSArray alloc] initWithObjects:@"Item", @"Item",@"Item",@"Item",@"Item",@"Item",@"Item",@"Item",@"Item",@"Item",@"Item",@"Item",@"Item",@"Item",@"Item",@"Item",@"Item",@"Item",@"Item",@"Item",@"Item",@"Item",nil];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchField.bounds.size.height + 10, self.view.bounds.size.width, self.view.bounds.size.height - (self.searchField.bounds.size.height + 140)) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.backgroundColor = [UIColor colorWithRed:0.424 green:0.565 blue:0.592 alpha:1];
    
    [_pageView addSubview:_tableView];
    
    //Add alert button
    [self addAlertButtonWithTarget:self selector:@selector(showEmergencyDial)];
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
    
    if ((int)indexPath.section == 0 && (int)indexPath.row == 1){
        NSString *storyBoardId = @"AboutID";
        
        AboutViewController *aboutVC =
        [self.storyboard instantiateViewControllerWithIdentifier:storyBoardId];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}

-(void) showAddButton {
    NSString *storyBoardId = @"AddSignal";
    
    AddSignalViewController *addSignalVC =
    [self.storyboard instantiateViewControllerWithIdentifier:storyBoardId];
    [self.navigationController pushViewController:addSignalVC animated:YES];
}

-(void) showEmergencyDial{
    self.alertBtn.hidden = YES;
    
    
    CGPoint rightEdge = CGPointMake(CGRectGetWidth(self.view.bounds) - 50, CGRectGetHeight(self.view.bounds) - 230);
    CGPoint leftEdge = CGPointMake(CGRectGetWidth(self.view.bounds) - 350, CGRectGetHeight(self.view.bounds) - 230);
    
    holder = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 350, CGRectGetHeight(self.view.bounds), 320, 100)];
    holder.backgroundColor = [UIColor colorWithRed:0.765 green:0.78 blue:0.78 alpha:1];
    holder.layer.cornerRadius = 10;
    [holder addTarget:self action:@selector(callEmergency) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *pic = [[UIImageView alloc] initWithFrame:CGRectMake(holder.bounds.origin.x + 20, holder.bounds.origin.y + 10, holder.frame.size.width /3.5, holder.frame.size.height - 20)];
    pic.image =[UIImage imageNamed:@"emergency"];
    [holder addSubview:pic];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(holder.bounds.origin.x + 130, holder.bounds.origin.y + 10, holder.frame.size.width /2, holder.frame.size.height - 20)];
    text.backgroundColor = [UIColor clearColor];
    text.text = @"Call 112";
    [text setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:36]];
    [text setCenter:text.center];
    [holder addSubview:text];
    
    UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(holder.frame.size.width -28, holder.bounds.origin.y-7, 35, 35)];
    [close.layer setCornerRadius:20];
    [close setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    close.backgroundColor = [UIColor redColor];
    [close addTarget:self action:@selector(hideDial) forControlEvents:UIControlEventTouchDown];
    [holder addSubview:close];
    
    [_pageView addSubview:holder];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:_pageView];
    _gravity = [[UIGravityBehavior alloc] initWithItems:@[holder]];
    _itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[holder]];
    _gravity.angle = 3* M_PI / 2;
    _gravity.magnitude = 3;
    
    _collision = [[UICollisionBehavior alloc] initWithItems:@[holder]];
    [_collision addBoundaryWithIdentifier:@"barrier"
                                fromPoint:leftEdge
                                  toPoint:rightEdge];
    _collision.translatesReferenceBoundsIntoBoundary = NO;
    
    _itemBehaviour.elasticity = 0.6;
    
    [_animator addBehavior:_itemBehaviour];
    [_animator addBehavior:_collision];
    [_animator addBehavior:_gravity];
}

-(void)hideDial{
    self.alertBtn.hidden = NO;
    
    CGPoint rightEdge = CGPointMake(CGRectGetWidth(self.view.bounds) - 50, CGRectGetHeight(self.view.bounds));
    CGPoint leftEdge = CGPointMake(CGRectGetWidth(self.view.bounds) - 350, CGRectGetHeight(self.view.bounds));
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:_pageView];
    _gravity = [[UIGravityBehavior alloc] initWithItems:@[holder]];
    _gravity.magnitude = 3;
    [_collision addBoundaryWithIdentifier:@"barrier"
                                fromPoint:leftEdge
                                  toPoint:rightEdge];
    _itemBehaviour.elasticity = 0.6;
    
    [_animator addBehavior:_itemBehaviour];
    [_animator addBehavior:_collision];
    [_animator addBehavior:_gravity];
}

-(void) callEmergency{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt:112"]];
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

- (void) showAlertWithTitle: (NSString*) title andMessage:(NSString*) message{
    
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
    
    self.searchField = [[UISearchBar alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x + 50, 0, self.view.bounds.size.width - (self.searchButton.bounds.size.width + 60),30)];
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

- (void)addAlertButtonWithTarget:(id)target selector:(SEL)selector
{
    
    self.alertBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 60, CGRectGetHeight(self.view.bounds) - 200, 45, 45)];
    [self.alertBtn.layer setCornerRadius:27.f];
    self.alertBtn.backgroundColor = [UIColor clearColor];
    [self.alertBtn setImage:[UIImage imageNamed:@"alertBtn"] forState:UIControlStateNormal];
    [self.alertBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    [_pageView addSubview:self.alertBtn];
}

-(NSString*) getDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    
    NSString *stringFromDate = [formatter stringFromDate:[[NSDate alloc] init]];
    
    return stringFromDate;
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CustomCell";
    
    SignalCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"SignalCustomCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(SignalCustomCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.cellTitle.text = @"Traffic accident";
    cell.cellCategory.text = @"Accident";
    cell.cellAuthor.text = @"Pesho";
    cell.cellDate.text = [self getDate];
    cell.cellImage.image = [UIImage imageNamed:@"car-accident"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.customCell) {
        self.customCell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    }
    
//    self.customCell.cellTitle.text = @"Aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaahgcgcgchcchjcjchgchgchgchjgchchchjchgchjchghgcygfytff";
//    self.customCell.cellCategory.text = @"Accident";
//    self.customCell.cellAuthor.text = @"Pesho";
//    self.customCell.cellDate.text = [self getDate];
//    self.customCell.cellImage.image = [UIImage imageNamed:@"car-accident"];
//    
//    [self.customCell layoutIfNeeded];
//    
//    CGFloat height = [self.customCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGFloat height = 280;
    
    return height;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *gsmInfoViewId = @"DetailsView";
    
    SignalDetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:gsmInfoViewId];
    
    [self.navigationController pushViewController:detailsVC animated:YES];
}

@end
