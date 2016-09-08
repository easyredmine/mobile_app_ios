#import "GRTJSONSerialization.h"

#import "NSPropertyDescription+Groot.h"
#import "NSAttributeDescription+Groot.h"
#import "NSEntityDescription+Groot.h"
#import "NSDictionary+Groot.h"
#import "NSRelationshipDescription+Groot.h"

NSString * const GRTJSONSerializationErrorDomain = @"GRTJSONSerializationErrorDomain";
const NSInteger GRTJSONSerializationErrorInvalidJSONObject = 0xcaca;
const NSInteger GRTJSONSerializationErrorAbstractEntity = 0xcacb;

@implementation GRTJSONSerialization

+ (id)insertObjectForEntityName:(NSString *)entityName fromJSONDictionary:(NSDictionary *)JSONDictionary inManagedObjectContext:(NSManagedObjectContext *)context error:(NSError *__autoreleasing *)error {
	NSParameterAssert(JSONDictionary);
	
	return [[self insertObjectsForEntityName:entityName fromJSONArray:@[JSONDictionary] inManagedObjectContext:context error:error] firstObject];
}

+ (NSArray *)insertObjectsForEntityName:(NSString *)entityName fromJSONArray:(NSArray *)JSONArray inManagedObjectContext:(NSManagedObjectContext *)context error:(NSError *__autoreleasing *)error {
	NSParameterAssert(entityName);
	NSParameterAssert(JSONArray);
	NSParameterAssert(context);
	
	NSError * __block tmpError = nil;
	NSMutableArray * __block managedObjects = [NSMutableArray arrayWithCapacity:JSONArray.count];
	
	if (JSONArray.count == 0) {
		// Return early and avoid any processing in the context queue
		return managedObjects;
	}
	
	[context performBlockAndWait:^{
		NSArray *localJSONArray = JSONArray;
		NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
		if([entityName isEqualToString:@"CustomField"]){
			for(id cf in JSONArray){
				if(!cf[@"field_format"]){
					cf[@"field_format"] = @"list"; //TODO: whole rm custom fields logic isnt implemented
				}
			}
		}
		//TODO: add subentity mapping logic to other groot public methods
		if(entity.grt_shouldEvaluateSubentities) {
			if(entity.subentities.count == 0){
				NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Cannot map abstract entity %@ with no subentities.", @""), entityName];
				NSDictionary *userInfo = @{
													NSLocalizedDescriptionKey: message
													};
				tmpError = [NSError errorWithDomain:GRTJSONSerializationErrorDomain code:GRTJSONSerializationErrorAbstractEntity userInfo:userInfo];
				return;
			}
			for(NSEntityDescription *subentity in entity.subentities){
				NSAssert(subentity.grt_shouldEvaluateSubentities || subentity.grt_typeKeyPath, @"Cannot evaluate subentity %@, because neither it, nor any of its subentities specify a typeKeyPath.", subentity);
				[managedObjects addObjectsFromArray:[self insertObjectsForEntityName:subentity.name fromJSONArray:JSONArray inManagedObjectContext:context error:error]];
			}
		}
		if(entity.grt_typeKeyPath){
			localJSONArray = [localJSONArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
				id apiValue = [evaluatedObject valueForKeyPath:entity.grt_typeKeyPath];
				if ([apiValue isKindOfClass:[NSNumber class]]) apiValue = [apiValue stringValue];
				id grtValue = entity.grt_typeValue;
				if(![grtValue isKindOfClass:[NSArray class]]) grtValue = @[grtValue];
				for(NSString *val in grtValue){
					if([apiValue isEqualToString:val]){
						return YES;
					}
				}
				return NO;
			}]];
		}

		
		for (NSDictionary *dictionary in localJSONArray) {
			if ([dictionary isEqual:NSNull.null]) {
				continue;
			}
			
			if (![dictionary isKindOfClass:NSDictionary.class]) {
				NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Cannot serialize value %@. Expected a JSON dictionary.", @""), dictionary];
				NSDictionary *userInfo = @{
													NSLocalizedDescriptionKey: message
													};
				
				tmpError = [NSError errorWithDomain:GRTJSONSerializationErrorDomain code:GRTJSONSerializationErrorInvalidJSONObject userInfo:userInfo];
				
				break;
			}
			
			NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
			NSDictionary *propertiesByName = managedObject.entity.propertiesByName;
			
			[propertiesByName enumerateKeysAndObjectsUsingBlock:^(NSString *name, NSPropertyDescription *property, BOOL *stop) {
				if ([property isKindOfClass:NSAttributeDescription.class]) {
					*stop = ![self serializeAttribute:(NSAttributeDescription *)property fromJSONDictionary:dictionary inManagedObject:managedObject merge:NO error:&tmpError];
				} else if ([property isKindOfClass:NSRelationshipDescription.class]) {
					NSRelationshipDescription *relationship = (id)property;
                    *stop = ![self serializeRelationship:relationship fromJSONDictionary:dictionary inManagedObject:managedObject merge:(relationship.destinationEntity.grt_identityAttribute != nil) error:&tmpError];
				}
			}];
			
			if (tmpError == nil) {
				[managedObjects addObject:managedObject];
			} else {
				[context deleteObject:managedObject];
				break;
			}
		}
	}];
	
	if (error != nil) {
		*error = tmpError;
	}
	
	return managedObjects;
}

+ (id)mergeObjectForEntityName:(NSString *)entityName fromJSONDictionary:(NSDictionary *)JSONDictionary inManagedObjectContext:(NSManagedObjectContext *)context error:(NSError *__autoreleasing *)error {
	NSParameterAssert(JSONDictionary);
	
	return [[self mergeObjectsForEntityName:entityName fromJSONArray:@[JSONDictionary] inManagedObjectContext:context error:error] firstObject];
}

+ (NSArray *)mergeObjectsForEntityName:(NSString *)entityName fromJSONArray:(NSArray *)JSONArray inManagedObjectContext:(NSManagedObjectContext *)context error:(NSError *__autoreleasing *)error {
	NSParameterAssert(entityName);
	NSParameterAssert(JSONArray);
	NSParameterAssert(context);
	
	NSError * __block tmpError = nil;
	NSMutableArray * __block managedObjects = [NSMutableArray arrayWithCapacity:JSONArray.count];
	
	if (JSONArray.count == 0) {
		// Return early and avoid any processing in the context queue
		return managedObjects;
	}
	
	[context performBlockAndWait:^{
		NSArray *localJSONArray = JSONArray;
		NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
		
		//TODO: add subentity mapping logic to other groot public methods
		if(entity.grt_shouldEvaluateSubentities) {
			if(entity.subentities.count == 0){
				NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Cannot map abstract entity %@ with no subentities.", @""), entityName];
				NSDictionary *userInfo = @{
													NSLocalizedDescriptionKey: message
													};
				tmpError = [NSError errorWithDomain:GRTJSONSerializationErrorDomain code:GRTJSONSerializationErrorAbstractEntity userInfo:userInfo];
				return;
			}
			for(NSEntityDescription *subentity in entity.subentities){
				NSAssert(subentity.grt_shouldEvaluateSubentities || subentity.grt_typeKeyPath, @"Cannot evaluate subentity %@, because neither it, nor any of its subentities specify a typeKeyPath.", subentity);
				[managedObjects addObjectsFromArray:[self mergeObjectsForEntityName:subentity.name fromJSONArray:JSONArray inManagedObjectContext:context error:error]];
			}
		}
		if(entity.grt_typeKeyPath){
			localJSONArray = [localJSONArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
				id apiValue = [evaluatedObject valueForKeyPath:entity.grt_typeKeyPath];
				if ([apiValue isKindOfClass:[NSNumber class]]) apiValue = [apiValue stringValue];
				id grtValue = entity.grt_typeValue;
				if(![grtValue isKindOfClass:[NSArray class]]) grtValue = @[grtValue];
				for(NSString *val in grtValue){
					if([apiValue isEqualToString:val]){
						return YES;
					}
				}
				return NO;
			}]];
		}
		
		
		NSAttributeDescription *identityAttribute = [entity grt_identityAttribute];
		NSAssert(identityAttribute != nil, @"An identity attribute must be specified in order to merge objects");
		NSAssert([identityAttribute grt_JSONKeyPath] != nil, @"The identity attribute must have an valid JSON key path");
		
		NSMutableArray *identifiers = [NSMutableArray arrayWithCapacity:localJSONArray.count];
		for (NSDictionary *dictionary in localJSONArray) {
			if ([dictionary isEqual:NSNull.null]) {
				continue;
			}
			
			if (![dictionary isKindOfClass:NSDictionary.class]) {
				NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Cannot serialize value %@. Expected a JSON dictionary.", @""), dictionary];
				NSDictionary *userInfo = @{
													NSLocalizedDescriptionKey: message
													};
				
				tmpError = [NSError errorWithDomain:GRTJSONSerializationErrorDomain code:GRTJSONSerializationErrorInvalidJSONObject userInfo:userInfo];
				return;
			}
			
			id identifier = [dictionary grt_valueForAttribute:identityAttribute];
			if (identifier != nil) [identifiers addObject:identifier];
		}
		
		NSDictionary *existingObjects = [self fetchObjectsForEntity:entity withIdentifiers:identifiers inManagedObjectContext:context error:&tmpError];
		
		for (NSDictionary *dictionary in localJSONArray) {
			if ([dictionary isEqual:NSNull.null]) {
				continue;
			}
			
			NSManagedObject *managedObject = nil;
			id identifier = [dictionary grt_valueForAttribute:identityAttribute];
			
			if (identifier) {
				managedObject = existingObjects[identifier];
			}
			
			if (!managedObject) {
				managedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
			}
			
			NSDictionary *propertiesByName = managedObject.entity.propertiesByName;
			
			[propertiesByName enumerateKeysAndObjectsUsingBlock:^(NSString *name, NSPropertyDescription *property, BOOL *stop) {
				if ([property isKindOfClass:NSAttributeDescription.class]) {
					*stop = ![self serializeAttribute:(NSAttributeDescription *)property fromJSONDictionary:dictionary inManagedObject:managedObject merge:YES error:&tmpError];
				} else if ([property isKindOfClass:NSRelationshipDescription.class]) {
					NSRelationshipDescription *relationship = (id)property;


                    *stop = ![self serializeRelationship:relationship fromJSONDictionary:dictionary inManagedObject:managedObject merge:(relationship.destinationEntity.grt_identityAttribute != nil)  error:&tmpError];
				}
			}];
			
			if (tmpError == nil) {
				[managedObjects addObject:managedObject];
			} else {
				[context deleteObject:managedObject];
				break;
			}
		}
	}];
	
	if (error != nil) {
		*error = tmpError;
	}
	
	return managedObjects;
}

+ (NSDictionary *)JSONDictionaryFromManagedObject:(NSManagedObject *)managedObject {
	// Keeping track of in process relationships avoids infinite recursion when serializing inverse relationships
	NSMutableSet *processingRelationships = [NSMutableSet set];
	return [self JSONDictionaryFromManagedObject:managedObject processingRelationships:processingRelationships];
}

+ (NSArray *)JSONArrayFromManagedObjects:(NSArray *)managedObjects {
	// Keeping track of in process relationships avoids infinite recursion when serializing inverse relationships
	NSMutableSet *processingRelationships = [NSMutableSet set];
	return [self JSONArrayFromManagedObjects:managedObjects processingRelationships:processingRelationships];
}

#pragma mark - Private

+ (NSDictionary *)JSONDictionaryFromManagedObject:(NSManagedObject *)managedObject processingRelationships:(NSMutableSet *)processingRelationships {
	NSMutableDictionary * __block JSONDictionary = nil;
	NSManagedObjectContext *context = managedObject.managedObjectContext;
	
	if (!managedObject) {
		return nil;
	}
	
	[context performBlockAndWait:^{
		NSDictionary *propertiesByName = managedObject.entity.propertiesByName;
		JSONDictionary = [NSMutableDictionary dictionaryWithCapacity:propertiesByName.count];
		
		[propertiesByName enumerateKeysAndObjectsUsingBlock:^(NSString *name, NSPropertyDescription *property, BOOL *stop) {
			NSString *JSONKeyPath = [property grt_JSONKeyPath];
			
			if (JSONKeyPath == nil) {
				return;
			}
			
			id value = [managedObject valueForKey:name];
			
			if ([property isKindOfClass:NSAttributeDescription.class]) {
				NSAttributeDescription *attribute = (NSAttributeDescription *)property;
				NSValueTransformer *transformer = [attribute grt_JSONTransformer];
				
				if (transformer != nil && [transformer.class allowsReverseTransformation]) {
					value = [transformer reverseTransformedValue:value];
				}
			} else if ([property isKindOfClass:NSRelationshipDescription.class]) {
				NSRelationshipDescription *relationship = (NSRelationshipDescription *)property;
				
				if ([processingRelationships containsObject:relationship.inverseRelationship]) {
					// Skip if the inverse relationship is being serialized
					return;
				}
				
				[processingRelationships addObject:relationship];
				
				if ([relationship isToMany]) {
					NSArray *objects = [value isKindOfClass:NSOrderedSet.class] ? [value array] : [value allObjects];
					value = [self JSONArrayFromManagedObjects:objects processingRelationships:processingRelationships];
				} else {
					value = [self JSONDictionaryFromManagedObject:value processingRelationships:processingRelationships];
				}
			}
			
			if (value == nil) {
				value = NSNull.null;
			}
			
			NSArray *components = [JSONKeyPath componentsSeparatedByString:@"."];
			
			if (components.count > 1) {
				// Create a dictionary for each key path component
				id obj = JSONDictionary;
				for (NSString *component in components) {
					if ([obj valueForKey:component] == nil) {
						[obj setValue:[NSMutableDictionary dictionary] forKey:component];
					}
					
					obj = [obj valueForKey:component];
				}
			}
			
			[JSONDictionary setValue:value forKeyPath:JSONKeyPath];
		}];
	}];
	
	return JSONDictionary;
}

+ (NSArray *)JSONArrayFromManagedObjects:(NSArray *)managedObjects processingRelationships:(NSMutableSet *)processingRelationships {
	NSMutableArray *JSONArray = [NSMutableArray arrayWithCapacity:managedObjects.count];
	
	for (NSManagedObject *managedObject in managedObjects) {
		NSDictionary *JSONDictionary = [self JSONDictionaryFromManagedObject:managedObject processingRelationships:processingRelationships];
		[JSONArray addObject:JSONDictionary];
	}
	
	return JSONArray;
}

+ (BOOL)serializeAttribute:(NSAttributeDescription *)attribute fromJSONDictionary:(NSDictionary *)JSONDictionary inManagedObject:(NSManagedObject *)managedObject merge:(BOOL)merge error:(NSError *__autoreleasing *)error {
	NSString *keyPath = [attribute grt_JSONKeyPath];
	
	if (keyPath == nil) {
		return YES;
	}

	
	id value = [JSONDictionary valueForKeyPath:keyPath];
	
	if (merge && value == nil) {
		if([attribute grt_resetOnMerge]){
			value = attribute.defaultValue;
			NSAssert(value, @"trying to reset to default value, but default value isnt set");
		}else{
			return YES;
		}
	}
	
	if ([value isEqual:NSNull.null]) {
		value = nil;
	}
	
	if (value != nil) {
		NSValueTransformer *transformer = [attribute grt_JSONTransformer];
		if (transformer) {
			value = [transformer transformedValue:value];
		}
	}
	
	if ([managedObject validateValue:&value forKey:attribute.name error:error]) {
		[managedObject setValue:value forKey:attribute.name];
		return YES;
	}
	
	return NO;
}

+ (BOOL)serializeRelationship:(NSRelationshipDescription *)relationship fromJSONDictionary:(NSDictionary *)JSONDictionary inManagedObject:(NSManagedObject *)managedObject merge:(BOOL)merge error:(NSError *__autoreleasing *)error {
	NSString *keyPath = [relationship grt_JSONKeyPath];
	
	if (keyPath == nil) {
		return YES;
	}
	id value = [JSONDictionary valueForKeyPath:keyPath];
	
	if (merge && value == nil) {
		return YES;
	}
	
    
	if ([value isEqual:NSNull.null]) {
		value = nil;
	}
	
	if (value != nil) {
		NSString *entityName = relationship.destinationEntity.name;
		NSManagedObjectContext *context = managedObject.managedObjectContext;
		NSError *tmpError = nil;

		
		if ([relationship isToMany]) {
			if (![value isKindOfClass:[NSArray class]]) {
				if (error) {
					NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Cannot serialize '%@' into a to-many relationship. Expected a JSON array.", @""), [relationship grt_JSONKeyPath]];
					NSDictionary *userInfo = @{
														NSLocalizedDescriptionKey: message
														};
					
					*error = [NSError errorWithDomain:GRTJSONSerializationErrorDomain code:GRTJSONSerializationErrorInvalidJSONObject userInfo:userInfo];
				}
				
				return NO;
			}
			NSMutableArray *mutableValue = [value mutableCopy];
			for(NSUInteger i = 0; i < [mutableValue count]; i++){
				id elem = mutableValue[i];
            
                if (![elem isKindOfClass:[NSDictionary class]]) {
					NSEntityDescription *destination = relationship.destinationEntity;
					NSPropertyDescription *destinationProperty = relationship.grt_destinationProperty;
					if(!destinationProperty){
						NSString *idKeyPath = [destination grt_identityAttribute].name;
						NSPropertyDescription *idProperty = [destination propertiesByName][idKeyPath];
						destinationProperty = idProperty;
					}
					NSString *JSONKeyPath = [destinationProperty grt_JSONKeyPath];
					if(!JSONKeyPath){
						if (error) {
							NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Cannot serialize '%@' into a to-one relationship. Expected a JSON dictionary.", @""), [relationship grt_JSONKeyPath]];
							NSDictionary *userInfo = @{
																NSLocalizedDescriptionKey: message
																};
							
							*error = [NSError errorWithDomain:GRTJSONSerializationErrorDomain code:GRTJSONSerializationErrorInvalidJSONObject userInfo:userInfo];
						}
						
						return NO;
					}
					mutableValue[i] = @{ JSONKeyPath : elem };
				}
			}
            
            
            if([managedObject.entity.name isEqualToString:@"Issue"] && [relationship.name isEqualToString:@"haveRelations"]){
                
                NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *elem, NSDictionary *bindings) {
                    return [[(id)managedObject identifier] isEqual:[elem valueForKeyPath:@"issue_to_id"]] == false;
                }];
                mutableValue = [[mutableValue filteredArrayUsingPredicate:predicate] mutableCopy];
            }
			
            
			value = [mutableValue copy];
			
			NSArray *objects = merge
			? [self mergeObjectsForEntityName:entityName fromJSONArray:value inManagedObjectContext:context error:&tmpError]
			: [self insertObjectsForEntityName:entityName fromJSONArray:value inManagedObjectContext:context error:&tmpError];
			
			value = [relationship isOrdered] ? [NSOrderedSet orderedSetWithArray:objects] : [NSSet setWithArray:objects];
		} else {
			if (![value isKindOfClass:[NSDictionary class]]) {
				NSEntityDescription *destination = relationship.destinationEntity;
				NSString *idKeyPath = [destination grt_identityAttribute].name;
				NSPropertyDescription *idProperty = [destination propertiesByName][idKeyPath];
				NSString *JSONKeyPath = [idProperty grt_JSONKeyPath];
				if(!JSONKeyPath){
					if (error) {
						NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Cannot serialize '%@' into a to-one relationship. Expected a JSON dictionary.", @""), [relationship grt_JSONKeyPath]];
						NSDictionary *userInfo = @{
															NSLocalizedDescriptionKey: message
															};
						
						*error = [NSError errorWithDomain:GRTJSONSerializationErrorDomain code:GRTJSONSerializationErrorInvalidJSONObject userInfo:userInfo];
					}
					
					return NO;
				}
				
				value = @{ JSONKeyPath : value };
			}
			
			value = merge
			? [self mergeObjectForEntityName:entityName fromJSONDictionary:value inManagedObjectContext:context error:&tmpError]
			: [self insertObjectForEntityName:entityName fromJSONDictionary:value inManagedObjectContext:context error:&tmpError];
		}
		
		if (tmpError != nil) {
			if (error) {
				*error = tmpError;
			}
			return NO;
		}
	}
    

    
	if ([managedObject validateValue:&value forKey:relationship.name error:error]) {

		[managedObject setValue:value forKey:relationship.name];
		return YES;
	}
	
	return NO;
}

+ (NSDictionary *)fetchObjectsForEntity:(NSEntityDescription *)entity withIdentifiers:(NSArray *)identifiers inManagedObjectContext:(NSManagedObjectContext *)context error:(NSError *__autoreleasing *)error {
	NSString *identityKey = [[entity grt_identityAttribute] name];
    
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	fetchRequest.entity = entity;
	fetchRequest.returnsObjectsAsFaults = NO;
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K IN %@", identityKey, identifiers];
	
	NSArray *objects = [context executeFetchRequest:fetchRequest error:error];
	
	if (objects.count > 0) {
		NSMutableDictionary *objectsByIdentifier = [NSMutableDictionary dictionaryWithCapacity:objects.count];
		
		for (NSManagedObject *object in objects) {
			id identifier = [object valueForKey:identityKey];
			objectsByIdentifier[identifier] = object;
		}
		
		return objectsByIdentifier;
	}
	
	return nil;
}

@end
