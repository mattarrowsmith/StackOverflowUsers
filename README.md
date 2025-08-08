# StackOverFlowUsers

Contained is a repository with the xcode project to build and run StackOverflowUsers, a small application with the following capabilities:
 - Fetches 20 stackoverflow user details and presents them in a list.
 - Allows the user to follow and unfollow users.
 - Saves followed users to a local storage for inter session persistence.
 - Displays an error if the fetch fails.

![screenshot](https://i.imgur.com/yyEjHlZ.png)

## Run instructions:
- Clone the repo.
- Open StackOverflowUsers.xcodeproj in Xcode.
- Select StackOverflowUsers as the active scheme (this is the only scheme so this should be automatically selected).
- Select a valid device, simulator is recommended to avoid signing certificate woes.
- Hit the play button or run with CMD + R.

## Design Considerations
### Architecture:

I went with MVVM as the architecure for this project as I feel it strikes a good balance between separation of concerns and complexity.

**MVVM**
- Allows for decoupled code, business logic has no dependency on UIKit.
- Clear separation of concerns.
- Easily testable.
- Doesn't have too much boilerplate vs similar patterns e.g VIPER
- Didn't need any navigation logic which is not as explicit as VIPER's `Router`.

The application is structured into three parts, `Presentation`, `Domain`, `Data`. The Presentation layer depends on the Domain, and the Data layer depends on the Domain, but the Domain layer depends on nothing. This allows components to be easily swapped out.

### UI Framework:
There were two choices for UI, Swift or UIKit. From what I have learned, the Times app is a UIKit application so that was the chosen UI framework. 

Having used both, I feel SwiftUI gives you great speed and efficiency when creating views, however UIKit gives you great granular control over views and their lifecycles. 

I feel a project of this size would have massively benefited from being written in SwiftUI due to how much Apple have simplifed creating and communicating view and state changes.


**UIKit implementation:**

I prefer separate nibs to storyboards, as I feel storyboards tend to hide implemenation details and are difficult to reason about in source control. Nibs are a more modularised but still have the same review issues, 
however I like how they give you a clear picture of what components are supposed to look like in interface builder. A project with more than one person working on it could have benefited from views declared programatically.

### Loading Requests:
Currently `UserService` uses a hard coded url. To extend this the base urls should be set by configs and use a builder to set parameters on the calls.
A limitation of the simple request is that only the first 20 users are ever loaded, improvements to this would involve some form of pagination to allow for infinite scrolls.
Images are also not preloaded and have no involved caching mechanism.

### Communication Pattern
**Delegate**

As this was a small project with simple communication between one ViewController and ViewModel I went with delegate pattern to communicate changes between viewmodel and view.
Ideally this would use some form of binding or publisher pattern such as Combine, but due to scope I felt this was unnecessary.
As soon as views start to get more complicated and nested something that can better communicate changes throughout view hierarchies would be preferred.

### Local Store:
**CoreData**

The choice of persistent store was a toss up between UserDefaults and CoreData. In the end I went with CoreData as I felt that was more suited to the nature of the data I was saving.
Having CoreData is a lot more expandable and scalable so if this app were to be built upon further, CoreData is the better choice. For example you might want to query or relate followed users IDs to other data in the future.

UserDefaults is more suited to simple key value lookups for things like user settings. 

In hindsight this may have been a mistake when you consider the scope of this specific application, as a UserDefaults solution would have massively simplified the implementation while still giving the desired functionality.


### Testing
Unit testing on the non view classes
- UserListViewModel
- FollowRepository
- UserService

As dependencies are injected as protocols through inits they can easily be mocked for testing purposes.
