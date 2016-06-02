# WesterosKit
Swift client for [An Api of Ice and Fire](https://anapioficeandfire.com/) service.

You can find the server project in [this GitHub](https://github.com/joakimskoog/AnApiOfIceAndFire) repository.

##Usage

You can look for *Characters*, *Books*, and *Houses*

```swift
WesterosClient.westerosInstance.books() { (result) -> (Void) in
    switch result
    {
        case let WesterosResult.Success(result):
            for book in result
            {
                print("> \(book.name) (\(book.pages))")
            }
                
        case let WesterosResult.Error(reason):
            print("#err \(reason)")
                
    }
}
```

##Contact

Your feedback is welcome, find me on my twitter account [@fitomad](https://twitter.com/fitomad)
