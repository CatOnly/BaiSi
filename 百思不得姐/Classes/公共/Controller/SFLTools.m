
#import "SFLTools.h"

NSString * timeFormatWithSec(NSInteger sec){
    NSInteger min = sec / 60;
    if (min < 60) {
        return [NSString stringWithFormat:@"%02zd:%02zd",sec / 60,sec % 60];
    } else {
        return [NSString stringWithFormat:@"%02zd:%02zd:%02zd",min / 60,min % 60,sec % 60];
    }
}

NSString * timeFormatWithMsec(NSInteger msec){
    NSInteger sec = msec / 1000;
    return timeFormatWithSec(sec);
}



