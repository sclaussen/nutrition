#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"com.sclaussen.nutrition";

/// The "Automatic" asset catalog color resource.
static NSString * const ACColorNameAutomatic AC_SWIFT_PRIVATE = @"Automatic";

/// The "Black" asset catalog color resource.
static NSString * const ACColorNameBlack AC_SWIFT_PRIVATE = @"Black";

/// The "BlackWhite" asset catalog color resource.
static NSString * const ACColorNameBlackWhite AC_SWIFT_PRIVATE = @"BlackWhite";

/// The "BlackWhiteSecondary" asset catalog color resource.
static NSString * const ACColorNameBlackWhiteSecondary AC_SWIFT_PRIVATE = @"BlackWhiteSecondary";

/// The "Blue" asset catalog color resource.
static NSString * const ACColorNameBlue AC_SWIFT_PRIVATE = @"Blue";

/// The "BlueYellow" asset catalog color resource.
static NSString * const ACColorNameBlueYellow AC_SWIFT_PRIVATE = @"BlueYellow";

/// The "BlueYellowSecondary" asset catalog color resource.
static NSString * const ACColorNameBlueYellowSecondary AC_SWIFT_PRIVATE = @"BlueYellowSecondary";

/// The "Green" asset catalog color resource.
static NSString * const ACColorNameGreen AC_SWIFT_PRIVATE = @"Green";

/// The "Manual" asset catalog color resource.
static NSString * const ACColorNameManual AC_SWIFT_PRIVATE = @"Manual";

/// The "ProgressLineBackground" asset catalog color resource.
static NSString * const ACColorNameProgressLineBackground AC_SWIFT_PRIVATE = @"ProgressLineBackground";

/// The "Red" asset catalog color resource.
static NSString * const ACColorNameRed AC_SWIFT_PRIVATE = @"Red";

/// The "Yellow" asset catalog color resource.
static NSString * const ACColorNameYellow AC_SWIFT_PRIVATE = @"Yellow";

#undef AC_SWIFT_PRIVATE
