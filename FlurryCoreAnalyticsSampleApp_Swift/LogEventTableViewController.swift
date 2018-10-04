//
//  LogEventTableViewController.swift
//  FlurryCoreAnalyticsSampleApp_Swift
//
//  Created by Yilun Xu on 10/1/18.
//  Copyright © 2018 Flurry. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class LogEventTableViewController: UITableViewController {
    
    let sLogEventName = "sample log event name"
    let sTimedLogEventName = "sample timed log event name"
    let sLogEventNameWithParams = "sample log event name with params"
    let sTimedLogEventNameWithParams = "sample timed log event name with params"
    
    var isLoggingTimedEvent: Bool!
    var isLoggingTimedEventWithParams: Bool!
    var defaultParams: Dictionary<String, String>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLoggingTimedEvent = false
        isLoggingTimedEventWithParams = false
        defaultParams = [
            "item purchased":"cool item"
        ]
        
    }
    
    
    // MARK: - helper function here
    
    // display alert
    func displayAlertWithTitle(title: String, message: String?) -> Void {
        // set alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        self.present(alertController, animated: true, completion: {
            let delay = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: delay){
                alertController.dismiss(animated: true, completion: nil)
            }
        })
        
    }
    
    func stringForEventRecordStatus(status: FlurryEventRecordStatus) -> String {
        switch status {
        case FlurryEventFailed:
            return "Log Event Failed"
        case FlurryEventRecorded:
            return "Log Event Recorded"
        case FlurryEventUniqueCountExceeded:
            return "Log Event Unique Count Exceeded"
        case FlurryEventParamsCountExceeded:
            return "Log Event Params Count Exceeded"
        case FlurryEventLogCountExceeded:
            return "Log Event Count Exceeded"
        case FlurryEventLoggingDelayed:
            return "Log Event Delayed"
        case FlurryEventAnalyticsDisabled:
            return "Log Event Analytics Disabled"
        default:
            return "shoule not be here"
        }
    }
    
    func setEnabled(enabled: Bool, params hasParams: Bool, forRowAtIndexPath indexPath: IndexPath) -> (Void) {
        let cell: UITableViewCell = tableView(self.tableView, cellForRowAt: indexPath)
        if enabled {
            if hasParams {
                cell.textLabel?.text = "Begin Timed Event with Params"
            } else {
                cell.textLabel?.text = "Begin Timed Event"
            }
            cell.textLabel?.textColor = UIColor.green
        } else {
            if hasParams {
                cell.textLabel?.text = "End Timed Event with Params"
            } else {
                cell.textLabel?.text = "End Timed Event"
            }
            cell.textLabel?.textColor = UIColor.red
        }
        cell.textLabel?.textAlignment = NSTextAlignment.center
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0: // log event
            if indexPath.row == 0 {
                // normal event
                let status: FlurryEventRecordStatus = Flurry.logEvent(sLogEventName)
                displayAlertWithTitle(title: "Log Event", message: stringForEventRecordStatus(status: status))
            } else {
                // timed event
                if isLoggingTimedEvent {
                    Flurry.endTimedEvent(sTimedLogEventName, withParameters: nil)
                    displayAlertWithTitle(title: "End timed event ", message: nil)
                } else {
                    let status: FlurryEventRecordStatus = Flurry.logEvent(sTimedLogEventName, timed: true)
                    displayAlertWithTitle(title: "Begin timed event", message: stringForEventRecordStatus(status: status))
                }
                isLoggingTimedEvent = !isLoggingTimedEvent
                setEnabled(enabled: !isLoggingTimedEvent, params: false, forRowAtIndexPath: indexPath)
            }
            break;
        case 1: // log event with params
            if indexPath.row == 0 {
                // normal event with params
                let status: FlurryEventRecordStatus = Flurry.logEvent(sLogEventNameWithParams, withParameters: defaultParams)
                displayAlertWithTitle(title: "Log Event with Params", message: stringForEventRecordStatus(status: status))
            } else {
                // timed event with params
                if isLoggingTimedEventWithParams {
                    Flurry.endTimedEvent(sTimedLogEventNameWithParams, withParameters: defaultParams)
                    displayAlertWithTitle(title: "End timed event", message: nil)
                } else {
                    let status: FlurryEventRecordStatus = Flurry.logEvent(sTimedLogEventNameWithParams, withParameters: defaultParams, timed: true)
                    displayAlertWithTitle(title: "Begin timed event with params", message: stringForEventRecordStatus(status: status))
                }
                isLoggingTimedEventWithParams = !isLoggingTimedEventWithParams
                setEnabled(enabled: !isLoggingTimedEventWithParams, params: true, forRowAtIndexPath: indexPath)
            }
            break;
        default:
            break;
        }
    }
}

