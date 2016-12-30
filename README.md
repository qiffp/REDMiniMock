# REDMiniMock

A barebones mocking framework. Pass the class or protocol you want to mock and the implementations of the methods you want to stub.

# Examples

### Using the REDMock static methods

```objectivec
NSObject *mock = [REDMock mockClass:[NSObject class]
                          selectors:@{
                                      REDMockMethod(isEqual:): ^BOOL(id _self, id obj) { return YES; }
                                      }];
```

```objectivec
id<NSObject> *mock = [REDMock mockProtocol:@protocol(NSObject)
                                 selectors:@{
                                             REDMockMethod(isEqual:): ^BOOL(id _self, id obj) { return YES; }
                                             }];
```

```objectivec
@interface MyClass : NSObject
- (instancetype)initWithProperty:(id)property;
@end

MyClass *mock = [REDMock mockClass:[MyClass class]
                         initBlock:^id(Class cls) {
                             return [[cls alloc] initWithProperty:@"mock"];
                         } selectors:@{
                                       REDMockMethod(isEqual:): ^BOOL(id _self, id obj) { return YES; }
                                       }];
```

### Using the NSObject category

```objectivec
NSObject *mock = [NSObject mock:@{
                                  REDMockMethod(isEqual:): ^BOOL(id _self, id obj) { return YES; }
                                  }];
```

==

Built using a subset of [MABlockForwarding](https://github.com/mikeash/MABlockForwarding) by [Mike Ash](https://github.com/mikeash)

