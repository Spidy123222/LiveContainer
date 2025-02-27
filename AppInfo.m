#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppInfo.h"

@implementation AppInfo
- (instancetype)initWithBundlePath:(NSString*)bundlePath {
	 self = [super init];
	 if(self) {
        _bundlePath = bundlePath;
        _info = [NSMutableDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/Info.plist", bundlePath]];
    }
    return self;
}

- (NSString*)displayName {
    if (_info[@"CFBundleDisplayName"]) {
        return _info[@"CFBundleDisplayName"];
    } else if (_info[@"CFBundleName"]) {
        return _info[@"CFBundleName"];
    } else if (_info[@"CFBundleExecutable"]) {
        return _info[@"CFBundleExecutable"];
    } else {
        return nil;
    }
}

- (NSString*)version {
    NSString* version = _info[@"CFBundleShortVersionString"];
    if (!version) {
        version = _info[@"CFBundleVersion"];
    }
    return version;
}

- (NSString*)bundleIdentifier {
    return _info[@"CFBundleIdentifier"];
}

- (NSString*)dataUUID {
    if (!_info[@"LCDataUUID"]) {
        self.dataUUID = NSUUID.UUID.UUIDString;
    }
    return _info[@"LCDataUUID"];
}

- (void)setDataUUID:(NSString *)uuid {
    _info[@"LCDataUUID"] = uuid;
    [self save];
}

- (NSString*)bundlePath {
    return _bundlePath;
}

- (NSMutableDictionary*)info {
    return _info;
}

- (UIImage*)icon {
    UIImage* icon = [UIImage imageNamed:[_info valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"][0] inBundle:[[NSBundle alloc] initWithPath: _bundlePath] compatibleWithTraitCollection:nil];
    if(!icon) {
        icon = [UIImage imageNamed:@"DefaultIcon"];
    }
    return icon;
}

- (void)save {
    [_info writeToFile:[NSString stringWithFormat:@"%@/Info.plist", _bundlePath] atomically:YES];
}
@end