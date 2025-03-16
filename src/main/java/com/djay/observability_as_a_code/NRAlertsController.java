package com.djay.observability_as_a_code;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.ArrayList;

@RestController
public class NRAlertsController {

    @RequestMapping("/alerts")
    public ArrayList<String> getAlerts() {
        ArrayList<String> alerts = new ArrayList<String>();
        alerts.add("Alert 1");
        alerts.add("Alert 2");
        alerts.add("Alert 3");
        return alerts;
    }
}
