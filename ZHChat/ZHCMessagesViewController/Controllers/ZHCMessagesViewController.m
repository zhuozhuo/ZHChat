//
//  ZHCMessagesViewController.m
//  ZHChat
//
//  Created by aimoke on 16/8/12.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ZHCMessagesViewController.h"
#import "ZHCMessage.h"
#import "ZHCMessagesTableviewLayoutAttributes.h"
#import "ZHCMessagesBubbleCalculator.h"
#import "ZHCMessagesTableViewCellOutcoming.h"
#import "ZHCMessageBubbleImageDataSource.h"
#import "ZHCMessageAvatarImageDataSource.h"
#import "ZHCMessagesTableviewLayoutAttributes.h"
#import "ZHCMessagesCommonParameter.h"
#import "ZHCMessagesComposerTextView.h"
#import "ZHCMessagesToolbarContentView.h"

#import "NSBundle+ZHCMessages.h"
#import "NSString+ZHCMessages.h"
#import "UIColor+ZHCMessages.h"
#import "UIView+ZHCMessages.h"


#import <MobileCoreServices/UTCoreTypes.h>
#import <objc/runtime.h>


static IMP ZHCReplaceMethodWithBlock(Class c, SEL origSEL, id block) {
    NSCParameterAssert(block);
    
    // get original method
    Method origMethod = class_getInstanceMethod(c, origSEL);
    NSCParameterAssert(origMethod);
    
    // convert block to IMP trampoline and replace method implementation
    IMP newIMP = imp_implementationWithBlock(block);
    
    // Try adding the method if not yet in the current class
    if (!class_addMethod(c, origSEL, newIMP, method_getTypeEncoding(origMethod))) {
        return method_setImplementation(origMethod, newIMP);
    } else {
        return method_getImplementation(origMethod);
    }
}

static void ZHCInstallWorkaroundForSheetPresentationIssue26295020(void) {
    __block void (^removeWorkaround)(void) = ^{};
    const void (^installWorkaround)(void) = ^{
        const SEL presentSEL = @selector(presentViewController:animated:completion:);
        __block IMP origIMP = ZHCReplaceMethodWithBlock(UIViewController.class, presentSEL, ^(UIViewController *self, id vC, BOOL animated, id completion) {
            UIViewController *targetVC = self;
            while (targetVC.presentedViewController) {
                targetVC = targetVC.presentedViewController;
            }
            ((void (*)(id, SEL, id, BOOL, id))origIMP)(targetVC, presentSEL, vC, animated, completion);
        });
        removeWorkaround = ^{
            Method origMethod = class_getInstanceMethod(UIViewController.class, presentSEL);
            NSCParameterAssert(origMethod);
            class_replaceMethod(UIViewController.class,
                                presentSEL,
                                origIMP,
                                method_getTypeEncoding(origMethod));
        };
    };
    
    const SEL presentSheetSEL = NSSelectorFromString(@"presentSheetFromRect:");
    const void (^swizzleOnClass)(Class k) = ^(Class klass) {
        const __block IMP origIMP = ZHCReplaceMethodWithBlock(klass, presentSheetSEL, ^(id self, CGRect rect) {
            // Before calling the original implementation, we swizzle the presentation logic on UIViewController
            installWorkaround();
            // UIKit later presents the sheet on [view.window rootViewController];
            // See https://github.com/WebKit/webkit/blob/1aceb9ed7a42d0a5ed11558c72bcd57068b642e7/Source/WebKit2/UIProcess/ios/WKActionSheet.mm#L102
            // Our workaround forwards this to the topmost presentedViewController instead.
            ((void (*)(id, SEL, CGRect))origIMP)(self, presentSheetSEL, rect);
            // Cleaning up again - this workaround would swallow bugs if we let it be there.
            removeWorkaround();
        });
    };
    
    // _UIRotatingAlertController
    Class alertClass = NSClassFromString([NSString stringWithFormat:@"%@%@%@", @"_U", @"IRotat", @"ingAlertController"]);
    if (alertClass) {
        swizzleOnClass(alertClass);
    }
    
    // WKActionSheet
    Class actionSheetClass = NSClassFromString([NSString stringWithFormat:@"%@%@%@", @"W", @"KActio", @"nSheet"]);
    if (actionSheetClass) {
        swizzleOnClass(actionSheetClass);
    }
}

@interface ZHCMessagesViewController ()<UITextViewDelegate,ZHCMessagesInputToolbarDelegate>
@property (weak, nonatomic) IBOutlet ZHCMessagesTableView *messageTableView;

@property (strong, nonatomic) IBOutlet ZHCMessagesInputToolbar *inputMessageBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewBottomLayoutGuide;
@property (strong, nonatomic) NSIndexPath *selectedIndexPathForMenu;
@property (strong, nonatomic) NSLayoutConstraint *messagesMoreViewBottomConstraint;
@property (assign, nonatomic) BOOL showFunctionViewBool;

@end

@implementation ZHCMessagesViewController

#pragma mark - Class methods

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([ZHCMessagesViewController class])
                          bundle:[NSBundle bundleForClass:[ZHCMessagesViewController class]]];
}

+ (instancetype)messagesViewController
{
    return [[[self class] alloc] initWithNibName:NSStringFromClass([ZHCMessagesViewController class])
                                          bundle:[NSBundle bundleForClass:[ZHCMessagesViewController class]]];
}

+ (void)initialize {
    [super initialize];
    if (self == [ZHCMessagesViewController self]) {
        ZHCInstallWorkaroundForSheetPresentationIssue26295020();
    }
}


#pragma mark - Initialization

- (void)zhc_configureMessagesViewController
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.modalPresentationCapturesStatusBarAppearance =NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    self.bubbleSizeCalculator = [[ZHCMessagesBubbleCalculator alloc]init];
    self.messageTableView.backgroundColor = [UIColor whiteColor];
    self.messageTableView.tableFooterView = [UIView new];
    self.messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.messageTableView.delegate = self;
    self.messageTableView.dataSource = self;
    self.showFunctionViewBool = NO;
   
    

    self.inputViewHeightConstraint.constant = self.inputMessageBarView.preferredDefaultHeight;
    self.inputMessageBarView.delegate = self;
    self.inputMessageBarView.contentView.textView.placeHolder = [NSBundle zhc_localizedStringForKey:@"new_message"];
    self.inputMessageBarView.contentView.textView.accessibilityLabel = [NSBundle zhc_localizedStringForKey:@"new_message"];
    self.inputMessageBarView.contentView.textView.delegate = self;
    self.automaticallyScrollsToMostRecentMessage = YES;
    
    self.incomingCellIdentifier = [ZHCMessagesTableViewCellIncoming cellReuseIdentifier];
    self.outgoingCellIdentifier = [ZHCMessagesTableViewCellOutcoming cellReuseIdentifier];
    self.incomingMediaCellIdentifier = [ZHCMessagesTableViewCellIncoming mediaCellReuseIdentifier];
    self.outgoingMediaCellIdentifier = [ZHCMessagesTableViewCellOutcoming mediaCellReuseIdentifier];
    //self.messageTableView.estimatedRowHeight = 100.0;//This can't set
    
    
    
    // NOTE: let this behavior be opt-in for now
    

    self.topContentAdditionalInset = 0.0f;
    
    [self zhc_updateTableViewInsets];
}

- (void)dealloc
{
    [self zhc_registerForNotifications:NO];
    
    _messageTableView.dataSource = nil;
    _messageTableView.delegate = nil;
    _inputMessageBarView.contentView.textView.delegate = nil;
    _inputMessageBarView.delegate = nil;
}


#pragma mark - Setters
- (void)setTopContentAdditionalInset:(CGFloat)topContentAdditionalInset
{
    _topContentAdditionalInset = topContentAdditionalInset;
    [self zhc_updateTableViewInsets];
}


-(ZHCMessagesMoreView *)messageMoreView
{
    if (!_messageMoreView) {
        _messageMoreView = [[ZHCMessagesMoreView alloc]init];
        _messageMoreView.dataSource = self;
        _messageMoreView.delegate = self;
        _messageMoreView.numberItemPerLine = 4;
        _messageMoreView.edgeInsets = UIEdgeInsetsMake(10.0f, 5.0f, 10.0f, 5.0f);
    }
    return _messageMoreView;
}


#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [[[self class] nib] instantiateWithOwner:self options:nil];
    [self zhc_configureMessagesViewController];
    [self zhc_registerForNotifications:YES];
    [self initialSubViews];
    // Do any additional setup after loading the view from its nib.
}


-(void)initialSubViews
{
    if (!_messageMoreView) {
        [self.view addSubview:self.messageMoreView];
        _messageMoreView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view zhc_pinSubview:_messageMoreView toEdge:NSLayoutAttributeLeading withConstant:0.0f];
        [self.view zhc_pinSubview:_messageMoreView toEdge:NSLayoutAttributeTrailing withConstant:0.0f];
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_messageMoreView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:kZHCMessagesFunctionViewHeight];
        [self.view addConstraint:constraint];
        [_messageMoreView zhc_pinSelfToEdge:NSLayoutAttributeHeight withConstant:kZHCMessagesFunctionViewHeight];
        
        self.messagesMoreViewBottomConstraint = constraint;
    }

}


-(void)clickRightItem:(id)sender
{
    if (self.inputViewBottomLayoutGuide.constant == 0) {
        self.inputViewBottomLayoutGuide.constant = 100;
    }else{
        self.inputViewBottomLayoutGuide.constant = 0;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.inputViewHeightConstraint.constant = self.inputMessageBarView.preferredDefaultHeight;
    [self.view layoutIfNeeded];
    if (self.automaticallyScrollsToMostRecentMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self scrollToBottomAnimated:NO];
        });
    }
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}



#pragma mark - View rotation

- (BOOL)shouldAutorotate
{
    return YES;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskAll;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.bubbleSizeCalculator prepareForResettingLayoutWithTableView:self.messageTableView];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.messageTableView reloadData];
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self zhc_resetLayoutAndCaches];
}



- (void)zhc_resetLayoutAndCaches
{
    
    [self.bubbleSizeCalculator prepareForResettingLayoutWithTableView:self.messageTableView];
}



#pragma mark - Messages view controller

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    NSAssert(NO, @"Error! required method not implemented in subclass. Need to implement %s", __PRETTY_FUNCTION__);
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    NSAssert(NO, @"Error! required method not implemented in subclass. Need to implement %s", __PRETTY_FUNCTION__);
}

- (void)finishSendingMessage
{
    [self finishSendingMessageAnimated:YES];
}

- (void)finishSendingMessageAnimated:(BOOL)animated {
    
    UITextView *textView = self.inputMessageBarView.contentView.textView;
    textView.text = nil;
    [textView.undoManager removeAllActions];
    
    [self.inputMessageBarView toggleSendButtonEnabled];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:textView];
    
    [self.messageTableView reloadData];
    
    if (self.automaticallyScrollsToMostRecentMessage) {
        [self scrollToBottomAnimated:animated];
    }
}


- (void)finishReceivingMessage
{
    [self finishReceivingMessageAnimated:YES];
}

- (void)finishReceivingMessageAnimated:(BOOL)animated {
    
    
    [self.messageTableView reloadData];
    
    if (self.automaticallyScrollsToMostRecentMessage && ![self zhc_isMenuVisible]) {
        [self scrollToBottomAnimated:animated];
    }
    
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, [NSBundle zhc_localizedStringForKey:@"new_message_received_accessibility_announcement"]);
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    if ([self.messageTableView numberOfSections] == 0) {
        return;
    }
    NSInteger rows = [self.messageTableView numberOfRowsInSection:0];
    NSLog(@"rows:%ld",(long)rows);
    NSIndexPath *lastCellIndexPath = [NSIndexPath indexPathForItem:(rows - 1) inSection:0];
    
    [self scrollToIndexPath:lastCellIndexPath animated:animated];
}


- (void)scrollToIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    if ([self.messageTableView numberOfSections] <= indexPath.section) {
        return;
    }
    
    NSInteger numberOfItems = [self.messageTableView numberOfRowsInSection:indexPath.section];
    if (numberOfItems == 0) {
        return;
    }
    
    CGFloat tableViewContentHeight = self.messageTableView.contentSize.height;
    CGFloat tableViewHeight = CGRectGetHeight(self.messageTableView.bounds);
    BOOL isContentTooSmall = (tableViewContentHeight < tableViewHeight);
    if (isContentTooSmall) {
        //  workaround for the first few messages not scrolling
        //  when the collection view content size is too small, `scrollToItemAtIndexPath:` doesn't work properly
        //  this seems to be a UIKit bug, see #256 on GitHub
        [self.messageTableView scrollRectToVisible:CGRectMake(0.0, tableViewContentHeight - 1.0f, 1.0f, 1.0f)
                                        animated:animated];
        return;
    }
    NSInteger row = MAX(MIN(indexPath.row, numberOfItems - 1), 0);
    indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    //  workaround for really long messages not scrolling
    //  if last message is too long, use scroll position bottom for better appearance, else use top
    //  possibly a UIKit bug, see #480 on GitHub
    CGFloat cellHeight = [self tableView:self.messageTableView heightForRowAtIndexPath:indexPath];
    CGFloat maxHeightForVisibleMessage = CGRectGetHeight(self.messageTableView.bounds)
    - self.messageTableView.contentInset.top
    - self.messageTableView.contentInset.bottom
    - CGRectGetHeight(self.inputMessageBarView.bounds);
     UITableViewScrollPosition scrollPosition = (cellHeight > maxHeightForVisibleMessage) ? UITableViewScrollPositionBottom : UITableViewScrollPositionTop;


    [self.messageTableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];

}


- (BOOL)isOutgoingMessage:(id<ZHCMessageData>)messageItem
{
    NSString *messageSenderId = [messageItem senderId];
    NSParameterAssert(messageSenderId != nil);
    
    return [messageSenderId isEqualToString:[self.messageTableView.dataSource senderId]];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark － TableView datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}


-(CGFloat)tableView:(ZHCMessagesTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHCMessage *message = (ZHCMessage *)[tableView.dataSource tableView:tableView messageDataForCellAtIndexPath:indexPath];
    CGFloat height = 0.0;
    CGSize size = [self.bubbleSizeCalculator messageBubbleSizeForMessageData:message atIndexPath:indexPath withTableView:tableView];

    CGFloat avatarHeight = 0.0f;
    BOOL isOutgoingMessage = [self isOutgoingMessage:message];
    if (isOutgoingMessage) {
        avatarHeight = tableView.tableViewLayout.outgoingAvatarViewSize.height;
    }else{
        avatarHeight = tableView.tableViewLayout.incomingAvatarViewSize.height;
    }
    
    CGFloat bubbleHeight = size.height>avatarHeight?size.height:avatarHeight;
    
    CGFloat cellTopLabelHeight = [tableView.dataSource tableView:tableView heightForMessageBubbleTopLabelAtIndexPath:indexPath];
    CGFloat cellBubbleTopLabelHeight = [tableView.dataSource tableView:tableView  heightForMessageBubbleTopLabelAtIndexPath:indexPath];
    CGFloat cellBottomLabelHeight = [tableView.dataSource tableView:tableView heightForCellBottomLabelAtIndexPath:indexPath];
    
    height = kZHCMessagesTableViewCellSpaceDefault + cellTopLabelHeight + cellBubbleTopLabelHeight + cellBottomLabelHeight + bubbleHeight + 2.0*[UIScreen mainScreen].scale;\
    return height;

}


-(UITableViewCell *)tableView:(ZHCMessagesTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    
    id<ZHCMessageData> messagecell = [tableView.dataSource tableView:tableView messageDataForCellAtIndexPath:indexPath];
    NSParameterAssert(messagecell != nil);
    BOOL isOutgoingMessage = [self isOutgoingMessage:messagecell];
    BOOL isMediaMessage = [messagecell isMediaMessage];
    
    NSString *cellIdentifier = nil;
    if (isMediaMessage) {
        cellIdentifier = isOutgoingMessage ? self.outgoingMediaCellIdentifier : self.incomingMediaCellIdentifier;
    }
    else {
        cellIdentifier = isOutgoingMessage ? self.outgoingCellIdentifier : self.incomingCellIdentifier;
    }
    
    ZHCMessagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = tableView;
    [cell applyLayoutAttributes];
    if (!isMediaMessage) {
        cell.textView.text = [messagecell text];
        NSParameterAssert(cell.textView.text != nil);
        id<ZHCMessageBubbleImageDataSource> bubbleImageDataSource = [tableView.dataSource tableView:tableView messageBubbleImageDataForCellAtIndexPath:indexPath];
        cell.messageBubbleImageView.image = [bubbleImageDataSource messageBubbleImage];
        cell.messageBubbleImageView.highlightedImage = [bubbleImageDataSource messageBubbleHighlightedImage];
        
    }else{
        id<ZHCMessageMediaData> messageMedia = [messagecell media];
        cell.mediaView = [messageMedia mediaView] ?:[messageMedia mediaPlaceholderView];
        NSParameterAssert(cell.mediaView !=nil);
    }
    BOOL needsAvatar = YES;
    if (isOutgoingMessage && CGSizeEqualToSize(tableView.tableViewLayout.outgoingAvatarViewSize, CGSizeZero)) {
        needsAvatar = NO;
    }else if (!isOutgoingMessage && CGSizeEqualToSize(tableView.tableViewLayout.incomingAvatarViewSize, CGSizeZero)){
        needsAvatar = NO;
    }
    id<ZHCMessageAvatarImageDataSource> avatarImageDataSource = nil;
    if (needsAvatar) {
        avatarImageDataSource = [tableView.dataSource tableView:tableView avatarImageDataForCellAtIndexPath:indexPath];
        if (avatarImageDataSource != nil) {
            UIImage *avatarImage = [avatarImageDataSource avatarImage];
            if (avatarImage == nil) {
                cell.avatarImageView.image = [avatarImageDataSource avatarPlaceholderImage];
                cell.avatarImageView.highlightedImage = nil;
            }else{
                cell.avatarImageView.image = avatarImage;
                cell.avatarImageView.highlightedImage = [avatarImageDataSource avatarHighlightedImage];
            }
            
        }
    }
    
    cell.cellTopLabel.attributedText = [tableView.dataSource tableView:tableView attributedTextForCellTopLabelAtIndexPath:indexPath];
    cell.messageBubbleTopLabel.attributedText = [tableView.dataSource tableView:tableView attributedTextForMessageBubbleTopLabelAtIndexPath:indexPath];
    cell.cellBottomLabel.attributedText = [tableView.dataSource tableView:tableView attributedTextForCellBottomLabelAtIndexPath:indexPath];
    
    CGFloat cellTopLabelHeight = [tableView.dataSource tableView:tableView heightForMessageBubbleTopLabelAtIndexPath:indexPath];
    CGFloat cellBubbleTopLabelHeight = [tableView.dataSource tableView:tableView  heightForMessageBubbleTopLabelAtIndexPath:indexPath];
    CGFloat cellBottomLabelHeight = [tableView.dataSource tableView:tableView heightForCellBottomLabelAtIndexPath:indexPath];
    
    cell.cellTopLabelHeight = cellTopLabelHeight;
    cell.messageBubbleTopLabelHeight = cellBubbleTopLabelHeight;
    cell.cellBottomLabelHeight = cellBottomLabelHeight;
    
    CGFloat bubbleTopLableInset = (avatarImageDataSource != nil)? 60.0f: 15.0f;
    if (isOutgoingMessage) {
        cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, bubbleTopLableInset);
    }else{
        cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsMake(0.0f, bubbleTopLableInset, 0.0f, 0.0f);
    }
    
    cell.textView.dataDetectorTypes = UIDataDetectorTypeAll;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    cell.layer.shouldRasterize = YES;
    
    return cell;
}

-(ZHCMessagesTableViewCell *)messageTableViewDequeueReusableCellWithIndexPath:(NSIndexPath *)indexPath
{
    id<ZHCMessageData> messagecell = [self.messageTableView.dataSource tableView:self.messageTableView messageDataForCellAtIndexPath:indexPath];
    NSParameterAssert(messagecell != nil);
    BOOL isOutgoingMessage = [self isOutgoingMessage:messagecell];
    BOOL isMediaMessage = [messagecell isMediaMessage];
    
    NSString *cellIdentifier = nil;
    if (isMediaMessage) {
        cellIdentifier = isOutgoingMessage ? self.outgoingMediaCellIdentifier : self.incomingMediaCellIdentifier;
    }
    else {
        cellIdentifier = isOutgoingMessage ? self.outgoingCellIdentifier : self.incomingCellIdentifier;
    }
    
    ZHCMessagesTableViewCell *cell = [self.messageTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!isMediaMessage) {
        cell.textView.text = [messagecell text];
        NSParameterAssert(cell.textView.text != nil);
    }
    return cell;
    
}



#pragma mark - TableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}





#pragma mark - ZHCMessagesTableViewDataSource

- (NSString *)senderDisplayName
{
    NSAssert(NO, @"ERROR: required method not implemented: %s", __PRETTY_FUNCTION__);
    return nil;
}

- (NSString *)senderId
{
    NSAssert(NO, @"ERROR: required method not implemented: %s", __PRETTY_FUNCTION__);
    return nil;
}

- (id<ZHCMessageData>)tableView:(ZHCMessagesTableView*)tableView messageDataForCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"ERROR: required method not implemented: %s", __PRETTY_FUNCTION__);
    return nil;
}

-(void)tableView:(ZHCMessagesTableView *)tableView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"ERROR: required method not implemented: %s", __PRETTY_FUNCTION__);
}




- (nullable id<ZHCMessageBubbleImageDataSource>)tableView:(ZHCMessagesTableView *)tableView messageBubbleImageDataForCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"ERROR: required method not implemented: %s", __PRETTY_FUNCTION__);
    return nil;

}

- (nullable id<ZHCMessageAvatarImageDataSource>)tableView:(ZHCMessagesTableView *)tableView avatarImageDataForCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"ERROR: required method not implemented: %s", __PRETTY_FUNCTION__);
    return nil;
}


-(NSAttributedString *)tableView:(ZHCMessagesTableView *)tableView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"ERROR: required method not implemented: %s", __PRETTY_FUNCTION__);
    return nil;
}


-(NSAttributedString *)tableView:(ZHCMessagesTableView *)tableView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"ERROR: required method not implemented: %s", __PRETTY_FUNCTION__);
    return nil;
}


- (NSAttributedString *)tableView:(ZHCMessagesTableView *)tableView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"ERROR: required method not implemented: %s", __PRETTY_FUNCTION__);
    return nil;

}

#pragma mark - Adjusting cell label heights
-(CGFloat)tableView:(ZHCMessagesTableView *)tableView heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}


-(CGFloat)tableView:(ZHCMessagesTableView *)tableView  heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;

}


-(CGFloat)tableView:(ZHCMessagesTableView *)tableView  heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    
   return 0.0f;
}


#pragma mark - ZHCMessagesTableViewDelegate
-(void)tableView:(ZHCMessagesTableView *)tableView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    [self recoverMessageInputToolBar];
}


-(void)tableView:(ZHCMessagesTableView *)tableView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
     [self recoverMessageInputToolBar];
    

}


-(void)tableView:(ZHCMessagesTableView *)tableView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
     [self recoverMessageInputToolBar];
}


-(void)tableView:(ZHCMessagesTableView *)tableView performAction:(SEL)action forcellAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{

    
}


#pragma mark - Public Methods

-(void)recoverMessageInputToolBar
{
    if (self.messagesMoreViewBottomConstraint.constant != kZHCMessagesFunctionViewHeight) {
        self.messagesMoreViewBottomConstraint.constant = kZHCMessagesFunctionViewHeight;
    }
    if ([self.inputMessageBarView.contentView.textView isFirstResponder]) {
        [self.inputMessageBarView.contentView.textView resignFirstResponder];
    }else{
        [self zhc_updateInputViewBottomConstraint:0];
        
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self zhc_setTableViewInsetsTopValue:self.messageTableView.contentInset.top bottomValue:self.inputMessageBarView.preferredDefaultHeight];
        [self.view layoutIfNeeded];
    }];

}


-(void)showMoreView
{
    self.showFunctionViewBool = YES;
    self.messagesMoreViewBottomConstraint.constant = 0.0f;
    self.inputViewBottomLayoutGuide.constant = kZHCMessagesFunctionViewHeight;
  
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self zhc_setTableViewInsetsTopValue:self.messageTableView.contentInset.top
                                                  bottomValue:(kZHCMessagesFunctionViewHeight+self.inputMessageBarView.preferredDefaultHeight)];
                            [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         self.showFunctionViewBool = NO;
                         [self scrollToBottomAnimated:YES];
                     }];
}

-(void)hiddenMoreView
{
    if (_messageMoreView && self.messagesMoreViewBottomConstraint) {
        self.messagesMoreViewBottomConstraint.constant = kZHCMessagesFunctionViewHeight;
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}


#pragma mark ScrollView delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == self.messageTableView) {
        [self recoverMessageInputToolBar];
    }
}


#pragma mark - InputView utilities
-(void)zhc_updateInputViewBottomConstraint:(CGFloat)constant
{
    self.inputViewBottomLayoutGuide.constant = constant;
}

#pragma mark - TableView utilities

- (void)zhc_updateTableViewInsets
{
    [self zhc_setTableViewInsetsTopValue:self.topLayoutGuide.length + self.topContentAdditionalInset
                                  bottomValue:CGRectGetMaxY(self.messageTableView.frame) - CGRectGetMinY(self.inputMessageBarView.frame)];
}

- (void)zhc_setTableViewInsetsTopValue:(CGFloat)top bottomValue:(CGFloat)bottom
{
    bottom = bottom +10;
    NSLog(@"Bottom Value:%f",bottom);
    UIEdgeInsets insets = UIEdgeInsetsMake(top, 0.0f, bottom, 0.0f);
    self.messageTableView.contentInset = insets;
    self.messageTableView.scrollIndicatorInsets = insets;
    
}

- (BOOL)zhc_isMenuVisible
{
    //  check if cell copy menu is showing
    //  it is only our menu if `selectedIndexPathForMenu` is not `nil`
    return self.selectedIndexPathForMenu != nil && [[UIMenuController sharedMenuController] isMenuVisible];
}



#pragma mark - Input toolbar delegate
- (void)messagesInputToolbar:(ZHCMessagesInputToolbar *)toolbar didPressRightBarButton:(UIButton *)sender
{
    if (sender.selected) {
        [self showMoreView];
    }else{
        [self hiddenMoreView];
        [self.inputMessageBarView.contentView.textView becomeFirstResponder];
    }
    

}

- (void)messagesInputToolbar:(ZHCMessagesInputToolbar *)toolbar didPressLeftBarButton:(UIButton *)sender
{
    

}


-(void)messagesInputToolbar:(ZHCMessagesInputToolbar *)toolbar didPressMiddelBarButton:(UIButton *)sender
{
    
}

- (NSString *)zhc_currentlyComposedMessageText
{
    //  auto-accept any auto-correct suggestions
    [self.inputMessageBarView.contentView.textView.inputDelegate selectionWillChange:self.inputMessageBarView.contentView.textView];
    [self.inputMessageBarView.contentView.textView.inputDelegate selectionDidChange:self.inputMessageBarView.contentView.textView];
    
    return [self.inputMessageBarView.contentView.textView.text zhc_stringByTrimingWhitespace];
}

#pragma mark - Input
/**
 *  This can't set
 */
//- (UIView *)inputAccessoryView
//{
//    return self.inputMessageBarView;
//}
//
//- (BOOL)canBecomeFirstResponder
//{
//    return YES;
//}

#pragma mark - ZHCMessagesMoreViewDataSource
-(void)messagesMoreView:(ZHCMessagesMoreView *)moreView selectedMoreViewItemWithIndex:(NSInteger)index
{
    NSAssert(NO, @"ERROR: required method not implemented: %s", __PRETTY_FUNCTION__);
}

-(NSArray *)messagesMoreViewTitles:(ZHCMessagesMoreView *)moreView
{
    NSAssert(NO, @"ERROR: required method not implemented: %s", __PRETTY_FUNCTION__);
    return nil;
}


-(NSArray *)messagesMoreViewImgNames:(ZHCMessagesMoreView *)moreView
{
    NSAssert(NO, @"ERROR: required method not implemented: %s", __PRETTY_FUNCTION__);
    return nil;
}


#pragma mark - Text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView != self.inputMessageBarView.contentView.textView) {
        return;
    }
    
    [textView becomeFirstResponder];
    
    if (self.automaticallyScrollsToMostRecentMessage) {
        [self scrollToBottomAnimated:YES];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView != self.inputMessageBarView.contentView.textView) {
        return;
    }
    
    [self.inputMessageBarView toggleSendButtonEnabled];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView != self.inputMessageBarView.contentView.textView) {
        return;
    }
    
    [textView resignFirstResponder];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if ([textView.text zhc_stringByTrimingWhitespace].length>0) {
            [self didPressSendButton:nil
                              withMessageText:[self zhc_currentlyComposedMessageText]
                                     senderId:[self.messageTableView.dataSource senderId]
                            senderDisplayName:[self.messageTableView.dataSource senderDisplayName]
                                         date:[NSDate date]];
        }
        
        return NO;
    }
    return YES;
}

#pragma mark - Notifications

- (void)didReceiveMenuWillShowNotification:(NSNotification *)notification
{
    if (!self.selectedIndexPathForMenu) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    UIMenuController *menu = [notification object];
    [menu setMenuVisible:NO animated:NO];
    
   ZHCMessagesTableViewCell *selectedCell = (ZHCMessagesTableViewCell *)[self.messageTableView cellForRowAtIndexPath:self.selectedIndexPathForMenu];
    CGRect selectedCellMessageBubbleFrame = [selectedCell convertRect:selectedCell.messageBubbleContainerView.frame toView:self.view];
    
    [menu setTargetRect:selectedCellMessageBubbleFrame inView:self.view];
    [menu setMenuVisible:YES animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMenuWillShowNotification:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
}

- (void)didReceiveMenuWillHideNotification:(NSNotification *)notification
{
    if (!self.selectedIndexPathForMenu) {
        return;
    }
    
    //  per comment above in 'shouldShowMenuForItemAtIndexPath:'
    //  re-enable 'selectable', thus re-enabling data detectors if present
    ZHCMessagesTableViewCell *selectedCell = (ZHCMessagesTableViewCell *)[self.messageTableView cellForRowAtIndexPath:self.selectedIndexPathForMenu];
    selectedCell.textView.selectable = YES;
    self.selectedIndexPathForMenu = nil;
}



#pragma mark - Utilities
- (void)zhc_registerForNotifications:(BOOL)registerForNotifications
{
    if (registerForNotifications) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhc_keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhc_keyboardWillHiden:) name:UIKeyboardWillHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(zhc_didReceiveKeyboardWillChangeFrameNotification:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMenuWillShowNotification:)
                                                     name:UIMenuControllerWillShowMenuNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMenuWillHideNotification:)
                                                     name:UIMenuControllerWillHideMenuNotification
                                                   object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillShowNotification
                                                      object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillHideNotification
                                                      object:nil];

        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillChangeFrameNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIMenuControllerWillShowMenuNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIMenuControllerWillHideMenuNotification
                                                      object:nil];
    }
}

-(void)zhc_keyboardWillShown:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    CGRect keyboardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize size = keyboardEndFrame.size;
    if (CGRectIsNull(keyboardEndFrame)) {
        return;
    }
    
    UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSInteger animationCurveOption = (animationCurve << 16);
    
    double animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:animationCurveOption
                     animations:^{
                         [self zhc_updateInputViewBottomConstraint:size.height];
                         [self zhc_setTableViewInsetsTopValue:self.messageTableView.contentInset.top
                                                  bottomValue:self.inputMessageBarView.preferredDefaultHeight+size.height];
                           [self.view layoutIfNeeded];
                         
                     }
                     completion:nil];

}


-(void)zhc_keyboardWillHiden:(NSNotification *)notification
{
    if (self.showFunctionViewBool) {
        return;
    }
    NSDictionary *userInfo = [notification userInfo];
    
    CGRect keyboardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (CGRectIsNull(keyboardEndFrame)) {
        return;
    }
    
   UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
   NSInteger animationCurveOption = (animationCurve << 16);
    
    double animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:animationCurveOption
                     animations:^{
                         [self zhc_updateInputViewBottomConstraint:0];
                         [self zhc_setTableViewInsetsTopValue:self.messageTableView.contentInset.top
                                                  bottomValue:self.inputMessageBarView.preferredDefaultHeight];
                         [self.view layoutIfNeeded];

                     }
                     completion:nil];
}

- (void)zhc_didReceiveKeyboardWillChangeFrameNotification:(NSNotification *)notification
{
    if (self.showFunctionViewBool) {
        return;
    }
    NSDictionary *userInfo = [notification userInfo];
    
    CGRect keyboardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (CGRectIsNull(keyboardEndFrame)) {
        return;
    }
    
    UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSInteger animationCurveOption = (animationCurve << 16);
    
    double animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:animationCurveOption
                     animations:^{
                         [self zhc_updateInputViewBottomConstraint:CGRectGetHeight(keyboardEndFrame)];
                         [self zhc_setTableViewInsetsTopValue:self.messageTableView.contentInset.top
                                                       bottomValue:CGRectGetHeight(keyboardEndFrame)];
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
