//
//  Parseable.swift
//  WesterosKit
//
//  Created by Adolfo on 1/6/16.
//  Copyright (c) 2016 Adolfo Vera. All rights reserved.
//

import Foundation

internal protocol Parseable
{
	/**

	*/
	func parseStringFromDictionary(dictionary: [String: AnyObject], forKey key: String) -> String?

	/**

	*/
	func parseURLFromDictionary(dictionary: [String: AnyObject], forKey key: String) -> NSURL?

	/**

	*/
	func parseStringArrayFromDictionary(dictionary: [String: AnyObject], forKey key: String) -> [String]?

	/**

	*/
	func parseURLArrayFromDictionary(dictionary: [String: AnyObject], forKey key: String) -> [NSURL]?

	/**

	*/
	func parseIntFromDictionary(dictionary: [String: AnyObject], forKey key: String) -> Int?

}

//
// MARK: - Protocol implementation
//

extension Parseable
{
	/**

	*/
	func parseStringFromDictionary(dictionary: [String: AnyObject], forKey key: String) -> String?
	{
		if let value = dictionary[key] as? String where !value.isEmpty
		{
			return value
		}

		return nil
	}

	/**

	*/
	func parseURLFromDictionary(dictionary: [String: AnyObject], forKey key: String) -> NSURL?
	{
		guard let string_value = self.parseStringFromDictionary(dictionary, forKey: key) else 
		{
			return nil	
		}

		return NSURL(string: string_value)
	}

	/**

	*/
	func parseStringArrayFromDictionary(dictionary: [String: AnyObject], forKey key: String) -> [String]?
	{
		guard let values = dictionary[key] as? [String] where !values.isEmpty else
		{
			return nil
		}

		return values
	}

	func parseURLArrayFromDictionary(dictionary: [String: AnyObject], forKey key: String) -> [NSURL]?
	{
		guard let string_values = self.parseStringArrayFromDictionary(dictionary, forKey: key) else
		{
			return nil
		}

		var urls: [NSURL] = [NSURL]()

		for case let value in string_values
		{
			if let url = NSURL(string: value)
			{
				urls.append(url)
			}
		}

		return urls
	}

	/**

	*/
	func parseIntFromDictionary(dictionary: [String: AnyObject], forKey key: String) -> Int?
	{
	    guard let value = dictionary[key] as? Int else {
	        return nil
	    }
	    
	    return value
	}
}