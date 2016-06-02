//
//  String+Encode.swift
//  QuoteThrones
//
//  Created by Adolfo Vera Blasco on 2/6/16.
//  Copyright © 2016 Adolfo Vera Blasco. All rights reserved.
//

import Foundation

extension String
{
    /// Returns a string ready to use as an URL parameter
    public var encoded: String
    {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())!
    }
}
