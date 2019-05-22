# Flurry Core Anayltics Sample Application (Swift Version)

This is an Swift-C version sample app based on Flurry Anayltics service. See [Objective-C version](https://github.com/flurrydev/Flurry-iOS-core-analytics-sample-ObjC) here. Flurry Analtyics can help developers to know their audience better. Developers can create custom events -- for example, making a purchase, hitting a button, or tapping on a link. Flurry will track these events and see how users interact with your app.  <br/>

Detailed instructions are written in [Yahoo Developer Network Website](https://developer.yahoo.com/flurry/docs/analytics/gettingstarted/events/ios/). In this sample project, there are five views. They are setting view (landing page), log event view, log error view, log session view and information view. When luanching the app, to enable and start Flurry session, some information needs to be filled in like apiKey, session seconds, and app version. Some fields are required and some are not. Default values will apply if you leave it blank. Default values are stored in FlurryCoreConfig.plist in the app bundle. The app will also save the information input by user into a property list under user's directory. After starting the seesion, some sample events (click buttons) and sample error/exception logging has already been created. You can trigger these event and see the real-time session report in the Flurry Portal.