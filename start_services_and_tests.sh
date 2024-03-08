#!/bin/bash

service nginx start
mkdir /.cache/selenium
python3 test_html_elements.py
