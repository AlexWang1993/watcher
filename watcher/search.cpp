//
//  search.cpp
//  watcher
//
//  Created by Helen Jiang on 2/19/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#include "search.h"

#include <iostream>
#include <string>
#include <sstream>
#include <fstream>
using namespace std;

int searchFile (string keyword){
    string rating;
    ifstream f(fileName);
    string s;
    while (getline(f,s)) {
        string::sizetype indexName = s.find(keyword);
        if (indexName!=std::string::npos) {
            string::sizetype indexRate = s.find("rate");
            indexRate=indexRate+4;
            rating = s[indexRate]+s[indexRate+1]+s[indexRate+2];
        }
        else{
            rating = "Not found on rate my prof";
        }
    return rating;
}
