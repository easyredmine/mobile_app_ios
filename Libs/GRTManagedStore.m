#import "GRTManagedStore.h"

static NSString *GRTApplicationCachePath() {
    static dispatch_once_t onceToken;
    static NSString *path;
    
    dispatch_once(&onceToken, ^{
        path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        path = [path stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]];
        
        NSError *error = nil;
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:path
                                                 withIntermediateDirectories:YES
                                                                  attributes:nil
                                                                       error:&error];
        
        if (!success) {
            NSLog(@"%s Error creating the application cache directory: %@", __PRETTY_FUNCTION__, error);
        }
    });
    
    return path;
}

@interface GRTManagedStore ()

@property (strong, nonatomic, readwrite) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic, readwrite) NSManagedObjectModel *managedObjectModel;

@property (copy, nonatomic) NSString *path;

@end

@implementation GRTManagedStore

#pragma mark - Properties

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        NSString *storeType = self.path ? NSSQLiteStoreType : NSInMemoryStoreType;
        NSURL *storeURL = self.path ? [NSURL fileURLWithPath:self.path] : nil;
        
        NSDictionary *options = @{
                                  NSMigratePersistentStoresAutomaticallyOption: @YES,
                                  NSInferMappingModelAutomaticallyOption: @YES
                                  };
        
        NSError *error = nil;
        NSPersistentStore *store = [_persistentStoreCoordinator addPersistentStoreWithType:storeType
                                                                             configuration:nil
                                                                                       URL:storeURL
                                                                                   options:options
                                                                                     error:&error];
        if (!store) {
            NSLog(@"%@ Error creating persistent store: %@", self, error);
        }
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    
    return _managedObjectModel;
}

#pragma mark - Lifecycle

+ (instancetype)managedStoreWithModel:(NSManagedObjectModel *)managedObjectModel {
    return [[self alloc] initWithPath:nil managedObjectModel:managedObjectModel];
}

+ (instancetype)temporaryManagedStore {
    NSString *fileName = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    
    return [[self alloc] initWithPath:path managedObjectModel:nil];
}

+ (instancetype)managedStoreWithCacheName:(NSString *)cacheName {
    NSParameterAssert(cacheName);
    
    NSString *path = [GRTApplicationCachePath() stringByAppendingPathComponent:cacheName];
    return [[self alloc] initWithPath:path managedObjectModel:nil];
}

- (id)init {
    return [self initWithPath:nil managedObjectModel:nil];
}

- (id)initWithPath:(NSString *)path managedObjectModel:(NSManagedObjectModel *)managedObjectModel {
    self = [super init];
    
    if (self) {
        _path = [path copy];
        _managedObjectModel = managedObjectModel;
    }
    
    return self;
}

@end
