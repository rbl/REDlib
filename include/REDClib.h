//
//  REDClib.h
//  REDlib
//
//  Created by Tom Seago on 3/5/12.
//  Copyright (c) 2012 Reality Box Labs LLC. All rights reserved.
//

#ifndef REDlib_REDClib_h
#define REDlib_REDClib_h

#define REDLIB_VERSION_MAJOR    0
#define REDLIB_VERSION_MINOR    3
#define REDLIB_VERSION_STRING   "0.3"

#ifdef __cplusplus
extern "C" {
#endif

extern void red_showControlWindow(void);
extern void red_hideControlWindow(void);

extern const int red_int(const char* name);
extern const int red_intd(const char* name, const int def);
extern const double red_double(const char* name);
extern const double red_doubled(const char* name, const double def);

#ifdef __cplusplus
}
#endif
        
#endif
