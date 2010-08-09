@protocol ViewController <NSObject>

- (void) hasBecomeKeyView;
- (void) resignedAsKeyView;

- (NSDictionary *) values;
- (void) clear;

@end