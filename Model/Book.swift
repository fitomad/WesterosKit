//
//  Book.swift
//  WesterosKit
//
//  Created by Adolfo on 1/6/16.
//  Copyright (c) 2016 Adolfo Vera. All rights reserved.
//

import Foundation

public class Book: Parseable
{
	/**

	*/
	public enum MediaType: String
	{
		case Hardback = "Hardback"
		case Hardcover = "Hardcover"
		case GraphicNovel = "GraphicNovel"
		case Paperback = "Paperback"
	}

	///
	public internal(set) var bookURL: NSURL!
	///
	public internal(set) var name: String!
	///
	public internal(set) var isbn: String!
	///
	public internal(set) var authors: [String]?
	///
	public internal(set) var pages: Int?
	///
	public internal(set) var publisher: String?
	///
	public internal(set) var country: String?
	///
	public internal(set) var mediaType: MediaType?
	///
	public internal(set) var released: NSDate?
	///
	public internal(set) var characters: [NSURL]?
	///
	public internal(set) var povCharacters: [NSURL]?

	/**

	*/
	internal init?(jsonDictionary dictionary: [String: AnyObject])
	{
		guard let name = dictionary["name"] as? String, 
				  isbn = dictionary["isbn"] as? String,
				  uri = dictionary["url"] as? String 
		else
		{
			return nil
		}

		self.name = name
		self.isbn = isbn
		self.bookURL = NSURL(string: uri)!

		self.authors = self.parseStringArrayFromDictionary(dictionary, forKey: "authors")
		self.pages = self.parseIntFromDictionary(dictionary, forKey: "numberOfPages")
		self.publisher = self.parseStringFromDictionary(dictionary, forKey: "publisher")
		self.country = self.parseStringFromDictionary(dictionary, forKey: "country")
		self.characters = self.parseURLArrayFromDictionary(dictionary, forKey: "characters")
		self.povCharacters = self.parseURLArrayFromDictionary(dictionary, forKey: "povCharacters")

		if let 
			type = self.parseStringFromDictionary(dictionary, forKey: "mediaType"),
			mediaType = MediaType(rawValue: type)
		{
			self.mediaType = mediaType
		}

		if let 
			released = self.parseStringFromDictionary(dictionary, forKey: "released"),
			date = NSDate(publishFormat: released)
		{
			self.released = date
		}
	}
}