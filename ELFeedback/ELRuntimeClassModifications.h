#import <Foundation/Foundation.h>

void ELSwapInstanceMethods(Class cls, SEL originalSel, SEL newSel);
void ELSwapClassMethods(Class cls, SEL originalSel, SEL newSel);