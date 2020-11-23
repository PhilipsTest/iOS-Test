//
//  Logger.h
//  Registration
//
//  Created by viswaradh on 06/02/14.
//  Copyright (c) 2014 Philips. All rights reserved.
//

#ifndef Registration_Logger_h
#define Registration_Logger_h

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#ifdef RELEASE_LOG
#define RLog(fmt, ...) NSLog((fmt), ##__VA_ARGS__);
#else
#define RLog(...)
#endif

#define InLog() DLog (@"%s : IN",__PRETTY_FUNCTION__);

#define OutLog() DLog (@"%s : OUT", __PRETTY_FUNCTION__);


#endif
