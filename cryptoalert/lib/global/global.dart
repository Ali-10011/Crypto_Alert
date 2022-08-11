library globals;

import 'package:flutter/material.dart';

var length = 0;

int page = 1;
// you can change this value to fetch more or less posts per page (10, 15, 5, etc)
final int limit = 20;

// There is next page or not
bool hasNextPage = true;

// Used to display loading indicators when _firstLoad function is running
bool isFirstLoadRunning = true;

// Used to display loading indicators when _loadMore function is running
bool isLoadMoreRunning = false;

late ScrollController controller;


