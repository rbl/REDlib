//
//  REDCLogMacro.h
//  REDlib
//
//  Created by Tom Seago on 3/5/12.
//  Copyright (c) 2012 Reality Box Labs LLC. All rights reserved.
//

#ifndef REDlib_REDCLog_h
#define REDlib_REDCLog_h

#ifdef __cplusplus
extern "C" {
#endif
    
extern const int RLEVEL_TRACE;
extern const int RLEVEL_DEBUG;
extern const int RLEVEL_INFO;
extern const int RLEVEL_WARNING;
extern const int RLEVEL_WARN;
extern const int RLEVEL_ERROR;
extern const int RLEVEL_ERR;
extern const int RLEVEL_CRITICAL;
extern const int RLEVEL_CRIT;

extern const int RLEVEL_DEFAULT;

extern void RCLog(const char *format, ...);
extern void RCLogLineNo(const char* file, int lineno, int level, const char* facility, const char* format, ...);
extern void RCLogv(int level, const char* facility, const char* format, va_list args);
extern void RCLogLineNov(const char* file, int lineno, int level, const char* facility, const char* format, va_list args);

extern void RCLogEnable(const char* sinkName);

#ifdef __cplusplus
}
#endif
        
// Undefine everything first just in case both this file and REDLog.h get included
#undef RLOG
#undef RLOG_TRACE
#undef RLOG_DEBUG
#undef RLOG_INFO
#undef RLOG_WARNING
#undef RLOG_WARN
#undef RLOG_ERROR
#undef RLOG_ERR
#undef RLOG_CRITICAL
#undef RLOG_CRIT

// Use the C++ clean versions
#define RLOG(facility, ...) RCLogLineNo(__FILE__,__LINE__, RLEVEL_DEFAULT, facility, __VA_ARGS__)

#define RLOG_TRACE(facility, ...) RCLogLineNo(__FILE__,__LINE__, RLEVEL_TRACE, facility, __VA_ARGS__)
#define RLOG_DEBUG(facility, ...) RCLogLineNo(__FILE__,__LINE__, RLEVEL_DEBUG, facility, __VA_ARGS__)
#define RLOG_INFO(facility, ...) RCLogLineNo(__FILE__,__LINE__, RLEVEL_INFO, facility, __VA_ARGS__)
#define RLOG_WARNING(facility, ...) RCLogLineNo(__FILE__,__LINE__, RLEVEL_WARNING, facility, __VA_ARGS__)
#define RLOG_WARN(facility, ...) RCLogLineNo(__FILE__,__LINE__, RLEVEL_WARN, facility, __VA_ARGS__)
#define RLOG_ERROR(facility, ...) RCLogLineNo(__FILE__,__LINE__, RLEVEL_ERROR, facility, __VA_ARGS__)
#define RLOG_ERR(facility, ...) RCLogLineNo(__FILE__,__LINE__, RLEVEL_ERR, facility, __VA_ARGS__)
#define RLOG_CRITICAL(facility, ...) RCLogLineNo(__FILE__,__LINE__, RLEVEL_CRITICAL, facility, __VA_ARGS__)
#define RLOG_CRIT(facility, ...) RCLogLineNo(__FILE__,__LINE__, RLEVEL_CRIT, facility, __VA_ARGS__)


#endif
