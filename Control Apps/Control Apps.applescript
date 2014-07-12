--
--  Control Apps.applescript
--  Control Apps
--
--  Created by Monty on 9/24/12.
--  Copyright (c) 2012 taolam. All rights reserved.
--

script AppDelegate
	property parent : class "NSObject"
    -- this property will be used to configure our notification
	property myNotification : missing value
    
    property theAppName : "Control Apps"
    property theSetMessage : "All Work Applications have been started."
    property theClearMessage : "All Home Applications have been started."
    property theHomeList : {"Mail", "iTunes", "Safari", "Reeder", "Messages"}
    property theWorkList : {"Calendar", "Evernote", "Reminders", "Adium"}

	
	on applicationWillFinishLaunching_(aNotification)
        
        if utilAppIsRunning("Calendar") is true or utilAppIsRunning("Evernote") or utilAppIsRunning("Reminders") or utilAppIsRunning("Adium") then
            my openHomeApps()
        else
            my openWorkApps()
        end if
        
        quit
        
	end applicationWillFinishLaunching_
	
	on applicationShouldTerminate_(sender)
		-- Insert code here to do any housekeeping before your application quits 
		return current application's NSTerminateNow
	end applicationShouldTerminate_

    -- Launch a few applications, then hide them
    on openWorkApps()
        repeat with theApp in theHomeList
            if utilAppIsRunning(theApp) is false then
                tell application theApp to activate
                delay 2
                -- Hide the application
                tell application "System Events"
                    set visible of process theApp to false
                end tell
            end if
        end repeat
        repeat with theApp in theWorkList
            if utilAppIsRunning(theApp) is false then
                tell application theApp to activate
                delay 2
                -- Hide the application
                tell application "System Events"
                    set visible of process theApp to false
                end tell
            end if
        end repeat
        -- send a notification to indicate the applications have been started
        sendNotificationWithTitle_AndMessage_(theAppName,theSetMessage)
    end LoadApps

    on openHomeApps()
        repeat with theApp in theHomeList
            if utilAppIsRunning(theApp) is false then
                tell application theApp to activate
                delay 2
                -- Hide the application
                tell application "System Events"
                    set visible of process theApp to false
                end tell
            end if
        end repeat
        repeat with theApp in theWorkList
            if utilAppIsRunning(theApp) is true then
                tell application theApp to quit
            end if
        end repeat
        -- send a notification to indicate the applications have been closed
        sendNotificationWithTitle_AndMessage_(theAppName,theClearMessage)
    end CloseApps

    on utilAppIsRunning(appName)
        tell application "System Events" to set appNameIsRunning to exists (processes where name is appName)
        if appNameIsRunning is true then
            log appName & " is already running"
        else
            log appName & " is not running"
        end if
        return appNameIsRunning
    end utilAppIsRunning
    
	-- Method for sending a notification based on supplied title and text
	on sendNotificationWithTitle_AndMessage_(aTitle, aMessage)
		set myNotification to current application's NSUserNotification's alloc()'s init()
		set myNotification's title to aTitle
		set myNotification's informativeText to aMessage
		current application's NSUserNotificationCenter's defaultUserNotificationCenter's deliverNotification_(myNotification)
	end sendNotification
    
end script