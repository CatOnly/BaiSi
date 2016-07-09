
#import <UIKit/UIkit.h>

typedef enum {
    SFLTopicTypeAll = 1,
    SFLTopicTypePicture = 10,
    SFLTopicTypeWord = 29,
    SFLTopicTypeVoice = 31,
    SFLTopicTypeVideo = 41
} SFLTopicType;

/** 精华-顶部标题的高度 */
UIKIT_EXTERN CGFloat const SFLTitlesViewH;
/** 精华-顶部标题的Y */
UIKIT_EXTERN CGFloat const SFLTitlesViewY;

/** 精华-cell-间距 */
UIKIT_EXTERN CGFloat const SFLTopicCellMargin;
/** 精华-cell-文字内容的Y值 */
UIKIT_EXTERN CGFloat const SFLTopicCellTextY;
/** 精华-cell-底部工具条的高度 */
UIKIT_EXTERN CGFloat const SFLTopicCellBottomBarH;

/** 精华-cell-图片帖子的最大高度 */
UIKIT_EXTERN CGFloat const SFLTopicCellPictureMaxH;
/** 精华-cell-图片帖子一旦超过最大高度,就是用Break */
UIKIT_EXTERN CGFloat const SFLTopicCellPictureBreakH;