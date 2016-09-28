#import <UIKit/UIKit.h>
#import "CalendarKit.h"
#import "CKCalendarHeaderView.h"

@interface AppointmentViewController : UIViewController<CKCalendarViewDataSource,CKCalendarViewDelegate,CKCalendarHeaderViewDelegate>

@property (nonatomic, strong) CKCalendarView *calendar;
@property (nonatomic, strong) UIScrollView *calScrollView;
@property (nonatomic, strong) UIView *calView;

@end