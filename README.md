REDlib
======

The **R**eality Box Labs **E**xpert **D**ebugging **lib**rary is a client library for iOS (and eventually javascript) that provides networked logging and on-device parameter modification.

![Control UI](/rbl/REDlib/raw/master/docs/ControlUI.jpg)

The network logging component allows you to watch debug logs in realtime even when not connected to Xcode. This is not only handy for situations where you need to use the dock connector for an accessory or need to be further away from a computer than a cable will allow, but we've also found it useful in general as a nicer UI for device logging.  The library is configured by default to send logs to [redlib.realityboxlabs.com](http://redlib.realityboxlabs.com) which provides a free service for viewing your logs, but it can also be configured to send them to your own server.

On device parameter modification allows you to easily tweak numerical parameters that your software relies on without going back to the compiler and without loading a manual configuration file.  This functionality was originally created to help tweak animation settings, but it has provided to be useful for more non-UI centric things like digital filter adjustment etc. 

The library is provided under an MIT License so feel free to use it wherever you would like.

iOS
===

The library began life as an iOS library at the 2011 iOS Dev Camp. It was originally called "ParmyLib" because it's hard to come up with decent names quickly when sleep deprived at a weekend hackathon. Since that event the basic concepts have stayed the same, but the UI was entirely re-written, logging was added, and the name was changed.

Getting It
----------

If you want to grab the source and build it from scratch, see the section further down.

Most people will just want to grab the latest pre-compiled binary from <http://redlib.realityboxlabs.com/download>

A full example application is included in the source distribution.

Adding the Library to Your Project
----------------------------------

The library comes with a binary library file and a set of `.h` header files. The basics are that you need to link against the `.a` and make the `.h` files available in your header search path. Here's the step by step on how to do that.

### Step 1: Place the library somewhere reasonable

It is recommended that you check a specific version of the library into your version control system. The recommended practice is to simply place a copy of the library in a `REDlib` folder at the same level of your source code like this:

    MyXCodeApp
    +-MyXCodeApp
    +-MyXCodeApp.xcodeproj
    +-REDlib
      +-libREDlib.a
      +-usr
        +-local
          +-include
            +- << .h header files here >>

### Step 2: Add the .a file to your project

In the project navigator area of Xcode (the panel on the left), right click and select "Add Files to MyXCodeApp". Add the entire `REDlib` directory and the `.a` should get added to the target, plus you'll have easy access to the `.h` files

### Step 3: Add the header search path

Unfortunately adding a `.h` to the project doesn't automatically make it findable to `#include` and `@import` statements. Select your project in the project navigator, select the proper target within your project, and then select the build settings tab. Search for the "header search" build settings or simply scroll down to the Search Paths section.

In this section add the path `../REDlib/usr/local/include` to either the system header search path or the user search path. It's probably best to add it to the user search path and to refer to it using double quotes instead of angle brackets since it's not really installed as a system library.

### Step 4: (Optional) Enable the NSString Categories

If you are going to use the on device parameter modification you will need to add the `-all_load` flag to the Other Linker Flags option in the Build Settings for the target. This is because right now the parameters are accessed using a category on `NSString`. Because of compiler issues/bugs, custom categories on system classes won't be found unless the `-all_load` flag is used.

If you don't do this, your app will compile and start but will immediately terminate with something along the lines of this.

```
2012-03-21 19:10:28.538 MyXcodeApp[35034:f803] -[__NSCFDictionary setREDlibSet:]: unrecognized selector sent to instance 0x6aa0490
2012-03-21 19:10:28.584 MyXcodeApp[35034:f803] *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[__NSCFDictionary setREDlibSet:]: unrecognized selector sent to instance 0x6aa0490'
*** First throw call stack:
(0x13c3052 0x1554d0a 0x13c4ced 0x1329f00 0x1329ce2 0x2e19 0x2fcd 0x189d6 0x198a6 0x28743 0x291f8 0x1caa9 0x12adfa9 0x13971c5 0x12fc022 0x12fa90a 0x12f9db4 0x12f9ccb 0x192a7 0x1aa9b 0x26d8 0x2635 0x1)
terminate called throwing an exceptionsharedlibrary apply-load-rules all
```

### Using the library

From here on the detailed steps are likely to vary by project. A typical use would include creating a project specific header file that contains the initialization of the library and then call this from `application:didFinishLaunchingWithOptions:` when the program starts. See the file `ExampleREDparms.h` in the include directory for an example. Copy this file and list the parameters you'd like to be able to modify within your application.

If you just want to use the `RLog` functions or the `RLOG_` macros you only need to import the `REDLog.h` header. Typically the full `REDlib.h` header is imported though which gives you access to the full library throughout your application.

A minimal test to make sure the library is working is to add

```objc
@import "REDlib.h"
```
    
to your application delegate `.m` file, then at the beginning of `application:didFinishLaunchingWithOptions:` add the lines

```objc
RLogEnable("nslog");
RLOG_INFO(@"application", @"MyXCodeApp has started. The launch options are:\n%@", launchOptions);
```

Build and run your application. In the console you should see something similar to

    2012-03-21 18:23:21.167 MyXcodeApp[34659:f803] info application MXAAppDelegate.m:23 MyXCodeApp has started. The launch options are:
    (null)
    
For more information about using the parameter UI and the logging see the reference section below.

Building From Source
--------------------

Building from the Xcode project file will no longer create a fat library automatically. In other words, the output of just loading the Xcode project and hitting build is only going to run on a device or a simulator, but not both.

That's not what we want for a distribution build though because it's annoying. Thus, there is a make file. Simply running `make` in the root directory should take care of you. It will build the project 4 different times, twice for arm and twice for the simulator, and will combine everything together into a single `.a` file.

The final static library suitable for inclusion in any type of iOS project is placed in the `dist` directory along with the header files that match it. This is what is included in all binary distributions of the project.

Reference
---------

### Logging

REDlib provides a reasonably robust logging infrastructure that can log to NSLog, send logs lines to a remote server, or support custom log sinks.  To use the library call one of the `RLOG_XXXXX()` macros. Each log message includes both a **level** which represents the importance of the message and a **facility** description the part of the program the message relates to. The default level is **info** and the default facility is **general**.

Several variations of the RLOG macros are provided for each level as follows

  * Trace
    * `RLOG_TRACE()`
  * Debug
    * `RLOG_DEBUG()`
  * Info (the default level)
    * `RLOG()`
    * `RLOG_INFO()`
  * Warning
    * `RLOG_WARNING()`
    * `RLOG_WARN()`
  * Error
    * `RLOG_ERROR()`
    * `RLOG_ERR()`
  * Critical
    * `RLOG_CRITICAL()`
    * `RLOG_CRIT()`

The signature of all of these macros is the same.

```objc
RLOG(const NSString* facility, const NSString* format, ...)
```

The facility must be given, but after that the format and additional arguments are optional. The format string works the same as `[NSString stringWithFormat:]` because that's what gets used internally.

These macros all supply the filename and line number to the lower level logging functions, which makes them quite useful. If you hate macros or don't care about that data you can directly call the lower level functions found in the `REDLog.h` header file. 


#### Log Sinks

By default, log messages go nowhere. You must add or enable a log sink before they will. If you want to see your logs on the regular console, enable the sink for `NSLog()`.

```objc
RLogEnable(@"nslog");
```

If you want to use a network logging service, obtain an application key from that service and configure the REDlib library with it at startup time.

```objc
[[REDLog sharedInstance] addNetworkKey:@"rpPdKOJpTBU5kBzLZZauruR2dJJJicXX" forURL:@"http://localhost:3000/log"];
```
    
If you're using the [redlib.realityboxlabs.com](http://redlib.realityboxlabs.com) service you don't have to specify the URL.

```obj
[[REDLog sharedInstance] addNetworkKey:@"m6VjjaJW0xB32RMfKKCGzb7PXxwZeBXX"];
```

For more information about how logs are submitted, check out the source for `REDSinglePostSink.m` or see the documentation at [http://redlib.realityboxlabs.com/docs](http://redlib.realityboxlabs.com/docs)

### On Device Parameter Management

The original purpose of REDlib was to provide a way to edit parameters on a device without needing to edit code and recompile, or edit a config file and restart the application.  If you want to use this feature, be sure you've added the `-all_load` linker flag or your app will terminate as soon as it tries to use any of the functions or properties in the custom `NSString` category. This is described in Step #4 above.

Parameters are named using strings, and their value is accessed using properties and functions in a custom class of NSString. This allows very terse, yet still descriptive code.

```objc
[[UIView alloc] initWithFrame:CGRectMake(0,0, @"rect size w".pvi, @"rect size h".pvi)]
```
    
REDlib currently supports three types of parameters: `floats`, `ints`, and `strings`.  Each type has a property following the pattern "pTv" where T is a character representing the type. The 'p' standard for parameter and the 'v' stands for value. The types are simple

  * `float = f` (these are actually doubles)
  * `int = i`
  * `string = s` (can not yet be modified on-device)
  
In addition to the property, a function which takes a default value to return in case the parameter isn't defined in the current parameter set. This has the same name as the property with a 'd' added at the end. 

  * `[@"a float" pfvd:1.2]`
  * `[@"an int" pivd:12]`
  * `[@"a string" psvd:@"Default text"]`
  
If you have an object which respects key-value coding, you can also directly bind a named REDlib parameter to a specific key on that object. If you do this, when the parameter changes the object will receive messages to update the value of that key. Since `UIView` respects key-value coding, this means you can bind parameters directly to a view and watch the view change in realtime as you manipulate the parameter using the on-device REDlib UI. Neat.

Two of the most typical things you need to see update live on a view are it's frame and it's center. These have been special cased as key names.

  * x = `frame.origin.x`
  * y = `frame.origin.y`
  * width = `frame.size.width`
  * height = `frame.size.height`
  * center.x = `frame.center.x`
  * center.y = `frame.center.y`
  
If you use one of these special names as a key name, then the object the parameter is bound to is assumed to be a view, the appropriate structure is read from the object, modified, and set back to the object.

To bind parameters to objects use the `bindToProperty:onObject:` method added to `NSString`. 

```objc
UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0,0,10,10)];
[@"view center x" bindToProperty:@"center.x" onObject:view];
[@"view center y" bindToProperty:@"center.y" onObject:view];
[@"master width" bindToProperty:@"width" onObject:view];
```

If you would like to implement your own custom handler for changes in parameters, all you need to do is listen for the `REDLIB_PARAM_CHANGED` notification on the default `NSNotificationCenter`. The object of the notification will be the parameter name.

#### Parameter Control UI

Integrating the control UI is simple within most applications.  If your app only uses a single window as Apple recommends and doesn't have any complex gesture recognition requirements you can add a single line of code to `application:didFinishLaunchingWithOptions:`

```objc
// Assuming self.window is the applications key window.
// Be sure to add this AFTER the window has been created.
[REDlib attachGestureRecognizerToWindow:self.window];
```

When you use this included utility function, a gesture recognizer is attached to the provided window which recognizes a triple tap of 2 or more fingers. When this gesture recognizer fires, the REDlib control window is opened above your application's main window.

If you have a more complex set of windows or gestures, you can also programmatically show and hide the control window from wherever makes sense within your code.

```objc
[REDlib showControlWindow];
[REDlib hideControlWindow];
```

The control window allows you to see the current value of all defined parameters and let's you select a parameter to modify. If your parameter names contain spaces, the first word of the parameter is used to group them in the list.

When a parameter is tapped in the UI, the window changes to the parameter slider for numerical parameters. Currently only numerical parameters can be changed.  The parameter slider shows:

![Parameter Slider](/rbl/REDlib/raw/master/docs/Slider.jpg)

  * The name of the parameter (minus the first word if the name contains spaces)
  * The current value at the top
  * The current multiplier at the bottom

To change the value of the parameter, touch the middle of the slider area and drag up or down. The parameter will vary by an amount that is dependent on both the distance you drag as well as the current multiplier.  To change the parameter quickly, make the multiplier big. To change it more slowly, make the multiplier small.

To change the multiplier, tap on the drag area instead of dragging. The multiplier value will turn red indicating it is what will change as you drag. Adjust as necessary and when you're ready to modify the parameter again, tap once more to switch back. The value in red is always the one which will be modified as you drag.

#### Parameter Sets

Parameter sets will let you easily swap between an A and B (or more) set of parameters all at once. This feature is currently only partially implemented and should largely be ignored for now.

Credits
=======

REDlib began life as ParmyLib at the 2011 iOS Dev Camp in Santa Clara, CA. It was originally conceived by [Tom Seago](https://github.com/tomseago) and [Ollie Wagner](https://github.com/olliewagner). The original ParmyLib included only the on-device parameter manipulation and used a very different UI.

Since then, Tom (hey, that's me!) added the logging capability and entirely re-wrote the UI layer. This new version of the library has been given a more appealing name that also works in the branding of his small company [Reality Box Labs](http://www.realityboxlabs.com/)

To provide the maximum utility this library is licensed under a permissive MIT license contained in the `license.txt` file. Basically, do what you want, buyer beware, and don't be a dick (i.e. leave the copyright notices intact). Commercial or Open Source, go nuts.



**Copyright (c) 2012-2014 Reality Box Labs, LLC**