// {{f_name}}.cpp create by {{user_created}} on {{date_created}}
#include "{{f_name}}.h"

Scene* {{class_name}}::createScene(){
    auto scene = Scene::create();
    
    auto layer = {{class_name}}::create();
    
    scene->addChild(layer);
    
    return scene;
}

bool {{class_name}}::init(){
    
    if (!Layer::init()) {
        return false;
    }
    
    Size visibleSize = Director::getInstance()->getVisibleSize();
    Vec2 origin = Director::getInstance()->getVisibleOrigin();

    // Start coding Scene/Layer here

    return true;
}