// {{f_name}}.test.{{ext}} created by {{user_created}} on {{date_created}}
#ifndef CATCH_INTERNAL_UNSUPPRESS_PARENTHESES_WARNINGS
#define CATCH_INTERNAL_UNSUPPRESS_PARENTHESES_WARNINGS
#endif
#include "catch.hpp"
#include "fakeit.hpp"
#include <{{f_name}}.h>

// tutorial: https://github.com/philsquared/Catch/blob/master/docs/tutorial.md
// API Reference: https://github.com/philsquared/Catch/blob/master/docs/Readme.md
// FakeIt: https://github.com/eranpeer/FakeIt/wiki/Quickstart

{{class_name}} {{f_name}};
/* 
// TDD Format 
TEST_CASE("Define what you are testing", "[{{class_name}}]"){
    SECTION( "you Can include Sub Sections" ) {}
    REQUIRE(true);
} */

// BDD Format
SCENARIO("Define what you are testing", "[{{class_name}}]"){

   GIVEN("I am a developer"){
       WHEN("I add two numbers"){
           THEN("I should get the sume of the two numbers"){
               REQUIRE(2 + 2 == 4);
           }
       }
   }
}
