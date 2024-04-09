#  Food Trucks

This demo application uses the MVVM architecture.  It demonstrates dependency
injection, and uses no singletons.  There is a simple API client that is
responsible for creating a URL query to download only the data we need to
display, i.e, food trucks in operation at the present time (in the San Francisco
time zone).  The API client uses modern Swift concurrency to make the network
call on a background thread, and deliver the results (or throw) without the use
of a complection block, future/promise, etc.  The FoodTrucksViewModel is a
@MainActor, and therefore it delivers its results to the view controller on the
main thread for updating the UI.  The results are kept in a CurrentValueSubject
so that subscribers can be notified when the data has been downloaded, and then
access that data at-will.  The FoodTrucksViewController is a parent view
controller that can switch between its two child view controllers, which display
the list and map.  It injects its view model into its child view controllers so
that the data can be shared.  All views are UIKit and use auto layout.  Some are
constructed in a storyboard, and others are built fully in code.

This application was built to specific design instructions for demonstration
purposes.  However, if I were building this app for the App Store, I would
use a UITabBarController for switching between the list and map views, rather
than a UIBarButtonItem.  I would limit the amount of data shown in the list view
as it can become quite long, and instead let the user navigate to a details view
for the info.  I would implement convenience features, such as the ability to
search by name, menu items, etc.  The list could be sortable by distance from
the user's current location.  The map annotations whould show the name of their
food truck. The user should be able to retrieve directions to a truck. A truck
should be easily shareable with friends via messaging apps.  Trucks could have a
star rating system.  If possible, a separate server store could be used to
retrieve pictures of the trucks or vendor's logos.  The app would have a
companion web-based version.  It would also let the user access data for more
cities than just San Francisco.  Finally, for a real managed project, the code
should be unit-tested.
