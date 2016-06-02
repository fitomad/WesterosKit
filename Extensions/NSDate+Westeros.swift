//
//  NSDate+Westeros.swift
//  WesterosKit
//
//  Created by Adolfo on 01/06/16.
//  Copyright (c) 2016 Adolfo Vera. All rights reserved.
//

import Foundation

extension NSDate
{
    
    /**
        Crea una fecha a partir de una cadena de texto
        con el formato `1996-08-01T00:00:00`
    */
    public convenience init?(publishFormat date_string: String)
    {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-ddTHH:mm:ss"
        
        if let helper_date = formatter.dateFromString(date_string)
        {
            self.init(timeIntervalSince1970: helper_date.timeIntervalSince1970)
        }
        else
        {
            return nil
        }
    }
}
