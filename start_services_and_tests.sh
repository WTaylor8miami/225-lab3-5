#!/bin/bash

service nginx start
md /cache/selenium
python3 test_html_elements.py
