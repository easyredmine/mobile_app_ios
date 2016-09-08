#import <UIKit/UIKit.h>

@interface KeyboardLayoutGuideViewController : UIViewController

@property (nonatomic, strong) id<UILayoutSupport> keyboardLayoutGuide;
-(void)keyboardWillShow;
-(void)keyboardWillHide;
@end
