#import <CoreData/CoreData.h>

/**
 Manages a Core Data stack.
 */
@interface GRTManagedStore : NSObject

/**
 The persistent store coordinator.
 */
@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 The managed object model.
 */
@property (strong, nonatomic, readonly) NSManagedObjectModel *managedObjectModel;

/**
 Creates and returns a `GRTManagedStore` that will persist its data in memory.
 */
+ (instancetype)managedStoreWithModel:(NSManagedObjectModel *)managedObjectModel;

/**
 Creates and returns a `GRTManagedStore` that will persist its data in a temporary file.
 */
+ (instancetype)temporaryManagedStore;

/**
 Creates and returns a `GRTManagedStore` that will persist its data in the application caches directory.
 
 @param cacheName The file name.
 */
+ (instancetype)managedStoreWithCacheName:(NSString *)cacheName;

/**
 Initializes the receiver with the specified path and managed object model.
 
 This is the designated initializer.
 
 @param path The persistent store path. If `nil` the persistent store will be created in memory.
 @param managedObjectModel The managed object model. If `nil` all models in the current bundle will be used.
 */
- (id)initWithPath:(NSString *)path managedObjectModel:(NSManagedObjectModel *)managedObjectModel;

@end
